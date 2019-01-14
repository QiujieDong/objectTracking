function [positions, time] = tracker(video_path, img_files, pos, target_sz, ...
	padding, kernel, lambda, output_sigma_factor, interp_factor, cell_size, ...
	features, show_visualization)
%TRACKER Kernelized/Dual Correlation Filter (KCF/DCF) tracking.
%   This function implements the pipeline for tracking with the KCF (by
%   choosing a non-linear kernel) and DCF (by choosing a linear kernel).
%
%   It is meant to be called by the interface function RUN_TRACKER, which
%   sets up the parameters and loads the video information.
%
%   Parameters:
%     VIDEO_PATH is the location of the image files (must end with a slash
%      '/' or '\').
%     IMG_FILES is a cell array of image file names.
%     POS and TARGET_SZ are the initial position and size of the target
%      (both in format [rows, columns]).
%     PADDING is the additional tracked region, for context, relative to 
%      the target size.
%     KERNEL is a struct describing the kernel. The field TYPE must be one
%      of 'gaussian', 'polynomial' or 'linear'. The optional fields SIGMA,
%      POLY_A and POLY_B are the parameters for the Gaussian and Polynomial
%      kernels.
%     OUTPUT_SIGMA_FACTOR is the spatial bandwidth of the regression
%      target, relative to the target size.
%     INTERP_FACTOR is the adaptation rate of the tracker.
%     CELL_SIZE is the number of pixels per cell (must be 1 if using raw
%      pixels).
%     FEATURES is a struct describing the used features (see GET_FEATURES).
%     SHOW_VISUALIZATION will show an interactive video if set to true.
%
%   Outputs:
%    POSITIONS is an Nx2 matrix of target positions over time (in the
%     format [rows, columns]).
%    TIME is the tracker execution time, without video loading/rendering.
%
%   Joao F. Henriques, 2014


	%if the target is large, lower the resolution(), we don't need that much
	%detail
    %若目标太大，降低分辨率。将目标区域width*height,若结果大于10000，则认为目标区域过大。
	resize_image = (sqrt(prod(target_sz)) >= 100);  %diagonal size >= threshold
	if resize_image
		pos = floor(pos / 2);%floor - 朝负无穷大四舍五入
		target_sz = floor(target_sz / 2);
	end


	%window size, taking padding into account
	window_sz = floor(target_sz * (1 + padding));%搜索区域为目标区域的2.5倍
	
% 	%we could choose a size that is a power of two, for better FFT
% 	%performance. in practice it is slower, due to the larger window size.
% 	window_sz = 2 .^ nextpow2(window_sz); %nextpow2 - 2 的更高次幂的指数,

	
	%create regression labels, gaussian shaped, with a bandwidth
	%proportional(成比例的) to target size
	output_sigma = sqrt(prod(target_sz)) * output_sigma_factor / cell_size;
	yf = fft2(gaussian_shaped_labels(output_sigma, floor(window_sz / cell_size)));%这里除以cell_size就是考虑一个HOG表示4x4像素单元,每个cell一个label,windows_sz/cell_size可以看成
                                                                                  %在搜索区域windows_sz内有多少个cell
                                                                                  %这里进行了fft2变换，gaussian_shaped_labels能量谱中心由四角回到中心位置

	%store pre-computed cosine window
	cos_window = hann(size(yf,1)) * hann(size(yf,2))';	
	
	
	if show_visualization  %create video interface
		update_visualization = show_video(img_files, video_path, resize_image);
	end
	
	
	%note: variables ending with 'f' are in the Fourier domain.

	time = 0;  %to calculate FPS
	positions = zeros(numel(img_files), 2);  %to calculate precision

	for frame = 1:numel(img_files)
		%load image
		im = imread([video_path img_files{frame}]);
		
        if size(im,3) > 1%将图像变为灰度
			im = rgb2gray(im);
        end
        
        if resize_image%如果上面对图像进行了缩放，那么这里也要对其进行缩放
			im = imresize(im, 0.5);
        end
      
		tic()

		if frame > 1
			%obtain a subwindow for detection at the position from last
			%frame, and convert to Fourier domain (its size is unchanged)
			patch = get_subwindow(im, pos, window_sz);
			zf = fft2(get_features(patch, features, cell_size, cos_window));
			
			%calculate response of the classifier at all shifts
			switch kernel.type
			case 'gaussian'
				kzf = gaussian_correlation(zf, model_xf, kernel.sigma);%kzf是复空间的
			case 'polynomial'
				kzf = polynomial_correlation(zf, model_xf, kernel.poly_a, kernel.poly_b);
			case 'linear'
				kzf = linear_correlation(zf, model_xf);
			end
			response = real(ifft2(model_alphaf .* kzf));  %equation for fast detection，论文中Eq.(15)
			%target location is at the maximum response. we must take into
			%account the fact that, if the target doesn't move, the peak
			%will appear at the top-left(左上方) corner, not at the center (this is
			%discussed in the paper). the responses wrap around cyclically.
			[vert_delta, horiz_delta] = find(response == max(response(:)), 1);%find函数中参数1意味着，只取第一个参数最大值的位置;vert-行位置，horiz-列位置
			if vert_delta > size(zf,1) / 2  %wrap around to negative half-space of vertical axis(缠绕到垂直轴的负半空间)
				vert_delta = vert_delta - size(zf,1);%fft2之后，最大值应在左上角，可是由于元素缠绕，可能导致最大值在其他三个角，因此这里对在其他三个角的情况
            end                                      %进行处理，从而使最大值始终在左上角。这一点在论文4.2节与附录1都有说明。
			if horiz_delta > size(zf,2) / 2  %same for horizontal axis
				horiz_delta = horiz_delta - size(zf,2);
			end
			pos = pos + cell_size * [vert_delta - 1, horiz_delta - 1];%前面求HOG特征缩放了cell_size倍，这里放大cell_size倍
        end                                                           %这里减1是因为如果目标从(1,1)移到(2,1),仅横坐标移动了，所以减是求出最大响应坐标相对于(1,1),也就是左上角坐标移动的距离

		%obtain a subwindow for training at newly estimated target position
		patch = get_subwindow(im, pos, window_sz);
		xf = fft2(get_features(patch, features, cell_size, cos_window));

		%Kernel Ridge Regression, calculate alphas (in Fourier domain) 核脊回归
		switch kernel.type
		case 'gaussian'
			kf = gaussian_correlation(xf, xf, kernel.sigma);
		case 'polynomial'
			kf = polynomial_correlation(xf, xf, kernel.poly_a, kernel.poly_b);
		case 'linear'
			kf = linear_correlation(xf, xf);
		end
		alphaf = yf ./ (kf + lambda);   %equation for fast training %Eq.(17)

		if frame == 1  %first frame, train with a single image
			model_alphaf = alphaf;
			model_xf = xf;
        else
			%subsequent frames, interpolate model %线性插值
			model_alphaf = (1 - interp_factor) * model_alphaf + interp_factor * alphaf;
			model_xf = (1 - interp_factor) * model_xf + interp_factor * xf;
		end

		%save position and timing
		positions(frame,:) = pos;
		time = time + toc();

		%visualization
		if show_visualization
			box = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];%box左上角x,y,框的width,height
			stop = update_visualization(frame, box);
			if stop, break, end  %user pressed Esc, stop early
			
			drawnow
% 			pause(0.05)  %uncomment to run slower
		end
		
	end

	if resize_image
		positions = positions * 2;
	end
end

