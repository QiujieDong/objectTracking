function out = get_feature_map(im_patch)

% allocate space
out = zeros(size(im_patch, 1), size(im_patch, 2), 28, 'single');

% if grayscale image
if size(im_patch, 3) == 1
    out(:,:,1) = single(im_patch)/255 - 0.5;
    temp = fhog(single(im_patch), 1);%这里1是HOG的cell_size的大小，KCF里对于灰度图像用的是1，就是1个像素是1个cell
    out(:,:,2:28) = temp(:,:,1:27);
else
    out(:,:,1) = single(rgb2gray(im_patch))/255 - 0.5;
    temp = fhog(single(im_patch), 1);%这里1是HOG的cell_size的大小，KCF里对于RGB图像用的是4，就是4个像素是1个cell,这里是1就会造成计算量增大，速度慢。
    out(:,:,2:28) = temp(:,:,1:27);%temp输出为32维，这里只取前27维。
end
