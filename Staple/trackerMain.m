function [results] = trackerMain(p, im, bg_area, fg_area, area_resize_factor)
%TRACKERMAIN contains the main loop of the tracker, P contains all the parameters set in runTracker
    %% INITIALIZATION
    num_frames = numel(p.img_files);
    % used for OTB-13 benchmark
    OTB_rect_positions = zeros(num_frames, 4);
	pos = p.init_pos;
    target_sz = p.target_sz;
% 	num_frames = numel(p.img_files);
    % patch of the target + padding
    patch_padded = getSubwindow(im, pos, p.norm_bg_area, bg_area);%输出经过处理后的图像patch
    % initialize hist model
    new_pwp_model = true;
    [bg_hist, fg_hist] = updateHistModel(new_pwp_model, patch_padded, bg_area, fg_area, target_sz, p.norm_bg_area, p.n_bins, p.grayscale_sequence);
    new_pwp_model = false;
    % Hann (cosine) window
    if isToolboxAvailable('Signal Processing Toolbox') %是否存在Signal Processing Toolbox，hann在这个工具箱里    
        hann_window = single(hann(p.cf_response_size(1)) * hann(p.cf_response_size(2))');
    else
        hann_window = single(myHann(p.cf_response_size(1)) * myHann(p.cf_response_size(2))');
    end
    % gaussian-shaped desired response, centred in (1,1)
    % bandwidth proportional to target size
    output_sigma = sqrt(prod(p.norm_target_sz)) * p.output_sigma_factor / p.hog_cell_size;
    y = gaussianResponse(p.cf_response_size, output_sigma);%高斯样本输出
    yf = fft2(y);
    %% SCALE ADAPTATION INITIALIZATION
    if p.scale_adaptation
        % Code from DSST
        scale_factor = 1;
        base_target_sz = target_sz;
        scale_sigma = sqrt(p.num_scales) * p.scale_sigma_factor;
        ss = (1:p.num_scales) - ceil(p.num_scales/2);%ceil - 朝正无穷大四舍五入,将尺度以0为中心分为[-16, 16]
        ys = exp(-0.5 * (ss.^2) / scale_sigma^2);
        ysf = single(fft(ys));
        if mod(p.num_scales,2) == 0
            scale_window = single(hann(p.num_scales+1)); 
            scale_window = scale_window(2:end);%将偶数变为奇数
        else
            scale_window = single(hann(p.num_scales));
        end

        ss = 1:p.num_scales;
        scale_factors = p.scale_step.^(ceil(p.num_scales/2) - ss);%DSST中对于scale_step设为1.02
%         scatter(ss,scale_factors,'k')%通过这个三点图可以看出scale_factors是单调减小的
        
        if p.scale_model_factor^2 * prod(p.norm_target_sz) > p.scale_model_max_area%防止尺度过大
            p.scale_model_factor = sqrt(p.scale_model_max_area/prod(p.norm_target_sz));
        end

        scale_model_sz = floor(p.norm_target_sz * p.scale_model_factor);
        % find maximum and minimum scales
        min_scale_factor = p.scale_step ^ ceil(log(max(5 ./ bg_area)) / log(p.scale_step));%寻找最大与最小区域
        max_scale_factor = p.scale_step ^ floor(log(min([size(im,1) size(im,2)] ./ target_sz)) / log(p.scale_step));
    end

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
    %compute FPS
%     t_imread = 0;%原代码中计算FPS的,其写的计算FPS的代码最终计算的FPS与其他tracker的计算范围不一样，导致与其他相比会小，自己进行了修改
     time = 0; %根据其他tracker改写成好理解的
    %% MAIN LOOP
%     tic;
    for frame = 1:num_frames
        im = imread([p.img_path p.img_files{frame}]);
        
        tic();
        
        if frame>1
%             tic_imread = tic;
%             im = imread([p.img_path p.img_files{frame}]);
%             t_imread = t_imread + toc(tic_imread);
	    %% TESTING step
            % extract patch of size bg_area and resize to norm_bg_area
            im_patch_cf = getSubwindow(im, pos, p.norm_bg_area, bg_area);
            pwp_search_area = round(p.norm_pwp_search_area / area_resize_factor);%area_resize_factor为图像缩放到150^2的比例，pwp_search_area这里可以理解为处理过的背景大小
            % extract patch of size pwp_search_area and resize to norm_pwp_search_area
            im_patch_pwp = getSubwindow(im, pos, p.norm_pwp_search_area, pwp_search_area);
            % compute feature map
            xt = getFeatureMap(im_patch_cf, p.feature_type, p.cf_response_size, p.hog_cell_size);
            % apply Hann window
            xt_windowed = bsxfun(@times, hann_window, xt);%加入hann处理的HOG矩阵
            % compute FFT
            xtf = fft2(xt_windowed);
            % Correlation between filter and test patch gives the response
            % Solve diagonal system per pixel.
            if p.den_per_channel
                hf = hf_num ./ (hf_den + p.lambda);
            else
                hf = bsxfun(@rdivide, hf_num, sum(hf_den, 3)+p.lambda);
            end
            response_cf = ensure_real(ifft2(sum(conj(hf) .* xtf, 3)));%这里response_cf的大值分布在四角

            % Crop square search region (in feature pixels).
            response_cf = cropFilterResponse(response_cf, ...
                floor_odd(p.norm_delta_area / p.hog_cell_size));%floor_odd转换为奇数区域，以便中心像素是精确的。这里将response_cf的大值由四角移到中心
            if p.hog_cell_size > 1
                % Scale up to match center likelihood resolution.
                response_cf = mexResize(response_cf, p.norm_delta_area,'auto');
            end

            [likelihood_map] = getColourMap(im_patch_pwp, bg_hist, fg_hist, p.n_bins, p.grayscale_sequence);%获得bg颜色直方图所占比例
            % (TODO) in theory it should be at 0.5 (unseen colors shoud have max entropy)
            likelihood_map(isnan(likelihood_map)) = 0;

            % each pixel of response_pwp loosely represents the likelihood that
            % the target (of size norm_target_sz) is centred on it
            response_pwp = getCenterLikelihood(likelihood_map, p.norm_target_sz);%获得积分图像

            %% ESTIMATION
            response = mergeResponses(response_cf, response_pwp, p.merge_factor, p.merge_method);%合并HOG颜色直方图
            [row, col] = find(response == max(response(:)), 1);
            center = (1+p.norm_delta_area) / 2;
            pos = pos + ([row, col] - center) / area_resize_factor;
            rect_position = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];

            %% SCALE SPACE SEARCH
            if p.scale_adaptation
                im_patch_scale = getScaleSubwindow(im, pos, base_target_sz, scale_factor * scale_factors, scale_window, scale_model_sz, p.hog_scale_cell_size);
                xsf = fft(im_patch_scale,[],2);
                scale_response = real(ifft(sum(sf_num .* xsf, 1) ./ (sf_den + p.lambda) ));
                recovered_scale = ind2sub(size(scale_response),find(scale_response == max(scale_response(:)), 1));%找尺度最大值位置，recovered_scale为响应最大值尺度下标
                %set the scale
                scale_factor = scale_factor * scale_factors(recovered_scale);

                if scale_factor < min_scale_factor
                    scale_factor = min_scale_factor;
                elseif scale_factor > max_scale_factor
                    scale_factor = max_scale_factor;
                end
                % use new scale to update bboxes for target, filter, bg and
                % fg models%使用新尺度更新一下target_sz和bg,fg
                target_sz = round(base_target_sz * scale_factor);
                avg_dim = sum(target_sz)/2;
                bg_area = round(target_sz + avg_dim);
                if(bg_area(2)>size(im,2)),  bg_area(2)=size(im,2)-1;    end
                if(bg_area(1)>size(im,1)),  bg_area(1)=size(im,1)-1;    end

                bg_area = bg_area - mod(bg_area - target_sz, 2);
                fg_area = round(target_sz - avg_dim * p.inner_padding);
                fg_area = fg_area + mod(bg_area - fg_area, 2);
                % Compute the rectangle with (or close to) params.fixed_area and
                % same aspect ratio as the target bboxgetScaleSubwindow
                area_resize_factor = sqrt(p.fixed_area/prod(bg_area));
            end

            if p.visualization_dbg==1 %输出各个提取的特征，比较直观
                mySubplot(2,1,5,1,im_patch_cf,'FG+BG','gray');
                mySubplot(2,1,5,2,likelihood_map,'obj.likelihood','parula');
                mySubplot(2,1,5,3,response_cf,'CF response','parula');
                mySubplot(2,1,5,4,response_pwp,'center likelihood','parula');
                mySubplot(2,1,5,5,response,'merged response','parula');
                drawnow
            end
        end

        %% TRAINING
        % extract patch of size bg_area and resize to norm_bg_area
        im_patch_bg = getSubwindow(im, pos, p.norm_bg_area, bg_area);
        % compute feature map, of cf_response_size
        xt = getFeatureMap(im_patch_bg, p.feature_type, p.cf_response_size, p.hog_cell_size);
        % apply Hann window
        xt = bsxfun(@times, hann_window, xt);%对经过HOG处理后的图像进行加hann窗
        % compute FFT
        xtf = fft2(xt);
        %% FILTER UPDATE
        % Compute expectations over circular shifts,
        % therefore divide by number of pixels.
		new_hf_num = bsxfun(@times, conj(yf), xtf) / prod(p.cf_response_size);
		new_hf_den = (conj(xtf) .* xtf) / prod(p.cf_response_size);

        if frame == 1
            % first frame, train with a single image
		    hf_den = new_hf_den;
		    hf_num = new_hf_num;
		else
		    % subsequent frames, update the model by linear interpolation
        	hf_den = (1 - p.learning_rate_cf) * hf_den + p.learning_rate_cf * new_hf_den;%params.learning_rate_cf = 0.01
	   	 	hf_num = (1 - p.learning_rate_cf) * hf_num + p.learning_rate_cf * new_hf_num;

            %% BG/FG MODEL UPDATE
            % patch of the target + padding
            [bg_hist, fg_hist] = updateHistModel(new_pwp_model, im_patch_bg, bg_area, fg_area, target_sz, p.norm_bg_area, p.n_bins, p.grayscale_sequence, bg_hist, fg_hist, p.learning_rate_pwp);
        end

        %% SCALE UPDATE
        if p.scale_adaptation
            im_patch_scale = getScaleSubwindow(im, pos, base_target_sz, scale_factor*scale_factors, scale_window, scale_model_sz, p.hog_scale_cell_size);%输出的是33个尺度上的HOG值
            xsf = fft(im_patch_scale,[],2);
            new_sf_num = bsxfun(@times, ysf, conj(xsf));
            new_sf_den = sum(xsf .* conj(xsf), 1);
            if frame == 1
                sf_den = new_sf_den;
                sf_num = new_sf_num;
            else
                sf_den = (1 - p.learning_rate_scale) * sf_den + p.learning_rate_scale * new_sf_den;
                sf_num = (1 - p.learning_rate_scale) * sf_num + p.learning_rate_scale * new_sf_num;
            end
        end

        % update bbox position
        if frame==1, rect_position = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])]; end

        rect_position_padded = [pos([2,1]) - bg_area([2,1])/2, bg_area([2,1])];%背景框距离image的边界区域大小，这里可以理解为背景框的坐标及大小

        OTB_rect_positions(frame,:) = rect_position;

        if p.fout > 0,  fprintf(p.fout,'%.2f,%.2f,%.2f,%.2f\n', rect_position(1),rect_position(2),rect_position(3),rect_position(4));   end

        time = time + toc();
        %% VISUALIZATION
%         if p.visualization == 1
%             if isToolboxAvailable('Computer Vision System Toolbox')
%                 im = insertShape(im, 'Rectangle', rect_position, 'LineWidth', 4, 'Color', 'black');%画目标框
%                 im = insertShape(im, 'Rectangle', rect_position_padded, 'LineWidth', 4, 'Color', 'yellow');%画背景框
%                 % Display the annotated video frame using the video player object.
%                 step(p.videoPlayer, im);
%             else
%                 figure(1)
%                 imshow(im)
%                 rectangle('Position',rect_position, 'LineWidth',2, 'EdgeColor','g');
%                 rectangle('Position',rect_position_padded, 'LineWidth',2, 'LineStyle','--', 'EdgeColor','b');
%                 drawnow
%             end
%         end
          if p.visualization == 1
              if frame ==1
                  figure('Name',['Tracker - ' p.img_path]);
                  im_handle = imshow(uint8(im), 'Border','tight', 'InitialMag', 100 + 100 * (length(im) < 500));
                  rect_handle = rectangle('Position',rect_position, 'EdgeColor','green');
                  rect_padded = rectangle('Position',rect_position_padded, 'EdgeColor','yellow');
                  text_handle = text(10, 10, int2str(frame));
                  set(text_handle, 'color', [0 1 1]);
              else
                  try  %subsequent frames, update GUI
                      set(im_handle, 'CData', im)
                      set(rect_handle, 'Position', rect_position)
                      set(rect_padded, 'Position', rect_position_padded)
                      set(text_handle, 'string', int2str(frame));
                  catch
                      return
                  end
              end
        
              drawnow         
          end
    end
%     elapsed_time = toc;
    % save data for OTB-13 benchmark
    results.type = 'rect';
    results.res = OTB_rect_positions;
%     results.fps = num_frames/(elapsed_time - t_imread);
    results.fps = num_frames/time;
end

% Reimplementation of Hann window (in case signal processing toolbox is
% missing)如果hann缺失，则使用自己实现的hann
function H = myHann(X)
    H = .5*(1 - cos(2*pi*(0:X-1)'/(X-1)));
end

% We want odd regions so that the central pixel can be exact%我们想要奇数区域，以便中心像素可以是精确的
function y = floor_odd(x)
    y = 2*floor((x-1) / 2) + 1;
end

function y = ensure_real(x)
    assert(norm(imag(x(:))) <= 1e-5 * norm(real(x(:))));
    y = real(x);
end
