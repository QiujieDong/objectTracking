function histogram = computeHistogram(patch, mask, n_bins, grayscale_sequence)
%COMPUTEHISTOGRAM creates a colour (or grayscale) histogram of an image patch
% MASK has the same size as the image patch and selects what should
% be used when computing the histogram (i.e. out-of-frame regions are ignored)

	[h, w, d] = size(patch);

	assert(all([h w]==size(mask)) == 1, 'mask and image are not the same size');%从getSubwindow函数可以得知all([h w]==size(mask)）是成立的

	bin_width = 256/n_bins;%params中参数取n_bins=2^5,那么这里bin_width = 8，也就是直方图的宽度为8，一共2^5个直方图

	% convert image to 1d array with same n channels of img patch
	patch_array = reshape(double(patch), w*h, d);%将三维变成二维，也就是每一行是一个像素点的RGB
	% compute to which bin each pixel (for all 3 channels) belongs to%计算每个像素（对于所有3个通道）属于哪个bin
	bin_indices = floor(patch_array/bin_width) + 1;%每8个像素为一个直方图，看patch中每个像素属于32个直方图中的哪一个直方图

	if grayscale_sequence
		histogram = accumarray(bin_indices, mask(:), [n_bins 1])/sum(mask(:));%accumarray-使用累加构造数组
	else
		% the histogram is a cube of side n_bins
		histogram = accumarray(bin_indices, mask(:), [n_bins n_bins n_bins])/sum(mask(:));%若mask为bg_mask，则统计背景的颜色直方图，除以sum(msk(:))为归一化
                                                                                          %同时指定输出的矩阵格式为32*32*32维，没有值的位置用0补齐
                                                                                          %bin_indices维三列，也就是每一个像素点的RGB
                                                                                          %例：bin_indices的一行为[2,5,7]，则将mask(:)中对应的值累加到
                                                                                          %第2行5列7层位置。
	end

end
