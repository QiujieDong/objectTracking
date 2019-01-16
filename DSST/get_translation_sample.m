function out = get_translation_sample(im, pos, model_sz, currentScaleFactor, cos_window)

% out = get_subwindow(im, pos, model_sz, currentScaleFactor, cos_window)
% 
% Extracts the a sample for the translation filter at the current
% location and scale.

if isscalar(model_sz)  %square sub-window
    model_sz = [model_sz, model_sz];
end

patch_sz = floor(model_sz * currentScaleFactor);%提取样本的size根据scaleFactor来设定

%make sure the size is not to small
if patch_sz(1) < 1
    patch_sz(1) = 2;
end
if patch_sz(2) < 1
    patch_sz(2) = 2;
end

xs = floor(pos(2)) + (1:patch_sz(2)) - floor(patch_sz(2)/2);%将pos作为坐标中心点
ys = floor(pos(1)) + (1:patch_sz(1)) - floor(patch_sz(1)/2);

% check for out-of-bounds coordinates, and set them to the values at
% the borders
xs(xs < 1) = 1;
ys(ys < 1) = 1;
xs(xs > size(im,2)) = size(im,2);
ys(ys > size(im,1)) = size(im,1);

% extract image
im_patch = im(ys, xs, :);

% resize image to model size
im_patch = imresize(im_patch, model_sz);%将im_patch进行imresize，与model_sz的维度一致

% compute feature map
out = get_feature_map(im_patch);

% apply cosine window
out = bsxfun(@times, cos_window, out);
end

