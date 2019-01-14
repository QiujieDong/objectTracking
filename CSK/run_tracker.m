
%  Exploiting the Circulant Structure of Tracking-by-detection with Kernels
%
%  Main script for tracking, with a gaussian kernel.
%
%  Jo?o F. Henriques, 2012
%  http://www.isr.uc.pt/~henriques/

clear ;clc
%choose the path to the videos (you'll be able to choose one with the GUI)
base_path = 'D:\objectTracking\configSeqs\OTB-100';


%parameters according to the paper:论文4.4节第四段
padding = 1;					%extra area surrounding the target
output_sigma_factor = 1/16;		%spatial bandwidth (proportional to target)
sigma = 0.2;					%gaussian kernel bandwidth
lambda = 1e-2;					%regularization
interp_factor = 0.075;			%linear interpolation factor for adaptation:论文4.3节第二段提到使用线性插值法,...
                                %将新参数与前一帧参数集合起来集成新模型,使模型具有记忆功能。



%notation: variables ending with f are in the frequency domain.
%表示法：以f为结尾的变量在频域中。

%ask the user for the video
video_path = choose_video(base_path);
if isempty(video_path) %user cancelled
    return
end  
[img_files, pos, target_sz, resize_image, ground_truth, video_path] = load_video_info(video_path);%得到:所有图像;第一帧目标区域中心点坐标位置;
                                                                                                  %目标区域的[hright, width];是否降低图像分辨率;
                                                                                                  %在每一帧目标区域实际中心点坐标;图像所在地址


%window size, taking padding into account
sz = floor(target_sz * (1 + padding));%将目标区域扩大一倍作为截取区域，即截取目标区域大小[height, width]
                                      %这样目标区域与截取区域的中心点位置坐标是一样的，均为pos

%desired output (gaussian shaped), bandwidth proportional(成比例) to target_size
output_sigma = sqrt(prod(target_sz)) * output_sigma_factor; %论文中4.4节第四段式子
[rs, cs] = ndgrid((1:sz(1)) - floor(sz(1)/2), (1:sz(2)) - floor(sz(2)/2));
y = exp(-0.5 / output_sigma^2 * (rs.^2 + cs.^2));%二维高斯公式,(x-x0)就是上面这一步中的((1:sz(1))-floor(sz(1)/2))，这里的对于x与y方差仍取一样值
yf = fft2(y); %二维傅里叶变换

%store pre-computed cosine window
cos_window = hann(sz(1)) * hann(sz(2))';%分别获得长度为sz(1)和sz(2)的窗函数，再分别相乘，得到的cos_windows矩阵为sz(1)行sz(2)列


time = 0;  %to calculate FPS
positions = zeros(numel(img_files), 2);  %to calculate precision

for frame = 1:numel(img_files)
	%load image
	im = imread([video_path img_files{frame}]);
	
    if size(im,3) > 1 
		im = rgb2gray(im); %变为灰度图像
    end
    
    if resize_image %imresize 使用双三次方插值方法实现的图片缩放。
		im = imresize(im, 0.5);
    end
	tic()
	%extract and pre-process subwindow
	x = get_subwindow(im, pos, sz, cos_window);%加窗后图像
	
	if frame > 1
		%calculate(计算) response of the classifier at all locations
		k = dense_gauss_kernel(sigma, x, z);%x为当前帧图像，z为上一帧图像
		response = real(ifft2(alphaf .* fft2(k)));   %(Eq. 9) Fast detection
		
		%target location is at the maximum response
		[row, col] = find(response == max(response(:)), 1);
		pos = pos - floor(sz/2) + [row, col];
	end
	
	%get subwindow at current estimated target position, to train classifer
	x = get_subwindow(im, pos, sz, cos_window);
	
	%Kernel Regularized Least-Squares, calculate alphas (in Fourier domain)
	k = dense_gauss_kernel(sigma, x);
	new_alphaf = yf ./ (fft2(k) + lambda);   %(Eq. 7)
	new_z = x;
	
	if frame == 1  %first frame, train with a single image
		alphaf = new_alphaf;
		z = x;
	else
		%subsequent frames, interpolate model
		alphaf = (1 - interp_factor) * alphaf + interp_factor * new_alphaf;%将新参数与前一帧参数集合起来集成新模型,使模型具有记忆功能。
		z = (1 - interp_factor) * z + interp_factor * new_z;
	end
	
	%save position and calculate FPS
	positions(frame,:) = pos; %保存求出的所有帧上目标区域中心点坐标
	time = time + toc();  %确保时间计算只有跟踪方面，其他数据处理方面不算在时间内
	
	%visualization
	rect_position = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];%跟踪到的目标区域的[x, y, width, height]
	if frame == 1  %first frame, create GUI
		figure( 'Name',['Tracker - ' video_path])
		im_handle = imshow(im, 'Border','tight', 'InitialMag',200);%Border图窗窗口边框空间,'tight' 时，图窗窗口不包含图窗中的图像周围的任何空间;
                                                                   %InitialMagnification图像显示的初始放大倍率
		rect_handle = rectangle('Position',rect_position, 'EdgeColor','g');
	else
		try  %subsequent frames, update GUI
			set(im_handle, 'CData', im) %CData是MATLAB里存放图像数据的一个矩阵
			set(rect_handle, 'Position', rect_position)
		catch  %, user has closed the window
			return
		end
	end
	
	drawnow
% 	pause(0.05)  %uncomment to run slower
end

if resize_image
    positions = positions * 2; 
end

disp(['Frames-per-second: ' num2str(numel(img_files) / time)])

%show the precisions plot
show_precision(positions, ground_truth, video_path)

