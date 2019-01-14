function kf = gaussian_correlation(xf, yf, sigma)
%GAUSSIAN_CORRELATION Gaussian Kernel at all shifts, i.e. kernel correlation.
%   Evaluates a Gaussian kernel with bandwidth SIGMA for all relative
%   shifts between input images X and Y, which must both be MxN. They must 
%   also be periodic (ie., pre-processed with a cosine window). The result
%   is an MxN map of responses.
%
%   Inputs and output are all in the Fourier domain.
%
%   Joao F. Henriques, 2014
%   http://www.isr.uc.pt/~henriques/
%高斯核的计算，在CSK已经提到过了	
	N = size(xf,1) * size(xf,2);
	xx = xf(:)' * xf(:) / N;  %squared norm of x,复数一平方就变成了实数
	yy = yf(:)' * yf(:) / N;  %squared norm of y
	
	%cross-correlation term in Fourier domain
	xyf = xf .* conj(yf);%conj - 复共轭。这里实际上已经完成了循环矩阵，在CSK代码里有解释
	xy = sum(real(ifft2(xyf)), 3);  %to spatial domain,在第三维上对数据进行求和，得二维矩阵。这就是多通道的实现
	
	%calculate gaussian response for all positions, then go back to the
	%Fourier domain
	kf = fft2(exp(-1 / sigma^2 * max(0, (xx + yy - 2 * xy) / numel(xf))));%这里进行了傅里叶变换，所以能量谱到了四角

end

