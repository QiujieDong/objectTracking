function target_box = getsubbox(pos,target_sz,im)
	%get and process the context region
	xs = floor(pos(2) + (1:target_sz(2)) - (target_sz(2)/2));%以pos为中心，以height与width为高宽，界定框的范围(坐标值)
	ys = floor(pos(1) + (1:target_sz(1)) - (target_sz(1)/2));
	
	%check for out-of-bounds coordinates, and set them to the values at
	%the borders
	xs(xs < 1) = 1;%防止出图像边界(图像中没有小于0的位置)
	ys(ys < 1) = 1;
	xs(xs > size(im,2)) = size(im,2);%防止出图像边界
	ys(ys > size(im,1)) = size(im,1);	
	%extract image in context region
	target_box = im(ys, xs, :);	
	%pre-process window
    target_box = double(target_box);
    target_box = (target_box-mean(target_box(:)));%截取的图像，这样同时减去一个数不会改变大小关系，但减小运算数值，方便计算

end