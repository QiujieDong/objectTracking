function labels = gaussian_shaped_labels(sigma, sz)
%GAUSSIAN_SHAPED_LABELS
%   Gaussian-shaped labels for all shifts of a sample.
%
%   LABELS = GAUSSIAN_SHAPED_LABELS(SIGMA, SZ)
%   Creates an array of labels (regression targets) for all shifts of a
%   sample of dimensions SZ. The output will have size SZ, representing
%   one label for each possible shift. The labels will be Gaussian-shaped,
%   with the peak at 0-shift (top-left element of the array), decaying
%   as the distance increases, and wrapping around at the borders.
%   The Gaussian function has spatial bandwidth SIGMA.
%
%   Joao F. Henriques, 2014
%   http://www.isr.uc.pt/~henriques/


% 	%as a simple example, the limit sigma = 0 would be a Dirac delta,
% 	%instead of a Gaussian:
% 	labels = zeros(sz(1:2));  %labels for all shifted samples
% 	labels(1,1) = magnitude;  %label for 0-shift (original sample)

%连续性标签，使用回归问题解决分类问题。在带宽sigma之内大于零(positive)，带宽之外为零(negative)	

	%evaluate a Gaussian with the peak at the center element
	[rs, cs] = ndgrid((1:sz(1)) - floor(sz(1)/2), (1:sz(2)) - floor(sz(2)/2));%目标中心位置坐标为(0,0)
	labels = exp(-0.5 / sigma^2 * (rs.^2 + cs.^2));

	%move the peak to the top-left, with wrap-around
	labels = circshift(labels, -floor(sz(1:2) / 2) + 1);%将最高值由中心位置移到四角，因为MATLAB的fft2之后，图像的能量由中心移到了四角。而最大值将会移到左上角
                                                        %这里做好平移是为了后面将样本与这里的标签一一对应

	%sanity(合理的) check: make sure it's really at top-left
	assert(labels(1,1) == 1)

end

