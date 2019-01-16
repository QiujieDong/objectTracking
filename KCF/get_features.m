function x = get_features(im, features, cell_size, cos_window)
%GET_FEATURES
%   Extracts dense features from image.
%
%   X = GET_FEATURES(IM, FEATURES, CELL_SIZE)
%   Extracts features specified in struct FEATURES, from image IM. The
%   features should be densely sampled, in cells or intervals of CELL_SIZE.
%   The output has size [height in cells, width in cells, features].
%
%   To specify HOG features, set field 'hog' to true, and
%   'hog_orientations' to the number of bins.
%
%   To experiment with other features simply add them to this function
%   and include any needed parameters in the FEATURES struct. To allow
%   combinations of features, stack them with x = cat(3, x, new_feat).
%
%   Joao F. Henriques, 2014
%   http://www.isr.uc.pt/~henriques/


	if features.hog
		%HOG features, from Piotr's Toolbox
		x = double(fhog(single(im) / 255, cell_size, features.hog_orientations));%single - 单精度数组,x为求得的HOG特征的一个三维矩阵;除以255归一化后，能对光照变化和阴影获得更好的效果。
		x(:,:,end) = [];  %remove all-zeros channel ("truncation feature"截断特征)%因为截断特征都是零，因此将截断特征去除
	end
	
	if features.gray
		%gray-level (scalar feature)
		x = double(im) / 255; %将像素值归一化到0-1之间
		
		x = x - mean(x(:));%将x归一化到(-0.5,0.5),这在CSK中提出的
	end
	
	%process with cosine window if needed
	if ~isempty(cos_window)
		x = bsxfun(@times, x, cos_window);%bsxfun - 对两个数组应用按元素运算（启用隐式扩展）,@times-数组乘法
	end
	
end
