function out = get_context(im, pos, sz, window)
	%get and process the context region
	xs = floor(pos(2) + (1:sz(2)) - (sz(2)/2));
	ys = floor(pos(1) + (1:sz(1)) - (sz(1)/2));
	
	%check for out-of-bounds coordinates, and set them to the values at
	%the borders
	xs(xs < 1) = 1;
	ys(ys < 1) = 1;
	xs(xs > size(im,2)) = size(im,2);
	ys(ys > size(im,1)) = size(im,1);	
	%extract image in context region
	out = im(ys, xs, :);	
	%pre-process window
    out = double(out);
    out = (out-mean(out(:)));%normalization
	out = window .* out;  % weight the intensity as the context prior model in Eq.(4)
end

