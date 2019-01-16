function k = dense_gauss_kernel(sigma, x, y)
%DENSE_GAUSS_KERNEL Gaussian Kernel with dense sampling.
%   Evaluates a gaussian kernel with bandwidth SIGMA for all displacements
%   between input images X and Y, which must both be MxN. They must also
%   be periodic (ie., pre-processed with a cosine window). The result is
%   an MxN map of responses.
%
%   If X and Y are the same, ommit the third parameter to re-use some
%   values, which is faster.
%
%   Jo?o F. Henriques, 2012
%   http://www.isr.uc.pt/~henriques/

%为什么说循环矩阵就可以实现在一张图片上对在搜索区域内的所有子窗口进行密集采样呢？
%我的理解是：循环位移相当于目标框(上一帧得出的以目标中心范围，也可以理解为框的范围)不动，而在当前帧截取的图片(也就是搜索区域)动，每移动一次就可以求出
%目标框与搜索区域重叠部分的互相关值即C(x)y，这样互相关值越大，就说明越有可能是目标所在位置，这样就可以得出目标框与搜索区域每一部分的互相关值。

	xf = fft2(x);  %x in Fourier domain
                   %通过输出mesh(x)与mesh(xf)可以看到x的能量集中在中心位置(其已经进行过加余弦窗处理)，而xf的信号能量将集中在系数矩阵的四个角上。
                   %这是由二维傅里叶本身性质决定的：若变换矩阵原点设在中心，其频谱能量集中分布在变换系数短阵的
                   %中心附近(图中阴影区)。若所用的二维傅里叶变换矩阵的原点设在左上角，那么图像信号能量将集中在系数矩阵
                   %的四个角上。表明了图像能量集中低频区域。
                   %而MATLAB的fft函数进行傅里叶变换时，其变换矩阵原点就在左上角，因此造成了形成的傅里叶域内的图像能量集中在四角
                   %这就导致了傅里叶变换后频谱图上的各点与图像上各点并不存在一一对应的关系，因此要将其对应回来(MATLAB官方说法是零频分量移到频谱中心)，
                   %MATLAB官方给出的是使用fftshift函数，而本文作者在下面使用了circshift(ifft2(xyf),floor(size(x)/2))操作，实质上也是将零频分量移到频谱中心。
	xx = x(:)' * x(:);  %squared norm of x :其中x(:)为将x按列进行组合成一整列
		
	if nargin >= 3  %general case, x and y are different ：nargin是用来判断输入变量个数的函数
		yf = fft2(y);
		yy = y(:)' * y(:);
	else
		%auto-correlation of x, avoid repeating a few operations
		yf = xf;
		yy = xx;
	end

	%cross-correlation term in Fourier domain
	xyf = xf .* conj(yf); %论文中Eq.4
% 	xy = real(circshift(ifft2(xyf), floor(size(x)/2)));  %to spatial domain
                               %circshift循环移位的函数,同时对矩阵进行行和列的移位则令circshift(A,[col, row])，其中col表示列位移，row表示行位移
                              
			       %由论文Eq.4可知C(u)v=$F^{-1}$($F^*(u)$$\bigodot$F(v)),也就是说C(y)x=ifft(F(xy))=ifft(F(x) .* F*(y)),
			       %可以看到只要执行ifft(F(x) .* F*(y))，就是对y进行了循环矩阵操作，同时求得y进行循环后其与x的互相关性，
			       %因为C(y)x是将y进行循环后求其与x的互相关性。
    xy = real(fftshift(ifft2(xyf)));%MATLAB官方文档给出的将零频分量移到频谱中心的函数是fftshift,上面的的circshift(ifft2(xyf), floor(size(x)/2))实现的
                                    %功能也是将零频分量移到频谱中心，只是fftshift更像是执行块操作（如果 X 是矩阵，则 fftshift 会将 X 的第一象限与
                                    %第三象限交换，将第二象限与第四象限交换.)，而circshift更像是一位一位的移动，直到移动到满足需要移动的位移数为止。
                                    
	%calculate gaussian response for all positions
	k = exp(-1 / sigma^2 * max(0, (xx + yy - 2 * xy) / numel(x)));%高斯核，论文中Eq.16
                                       
end
                    %max函数在这里确保值不可能是负数，因为正常情况下(x-y)^2不可能为负数，但为了防止出现系统问题，加上max使系统更稳定
                    %论文中没有解释为什么要除以numel(x),首先要看到的一点是numel(x)=numel(y).
                    %再就是解释这里为什么除以numel(x):通过将除numel(x)和不除两种情况下的mesh(k)输出和查看k的值分析，如若不除以numel(x),那么除了中心点外
                    %在其他位置的k_i都无限趋近于0，k的输出值直接取了0，这就导致了核k会认为除了正好截取到目标，其他情况都认为目标出图找不到了，通俗解释
                    %就是跟踪中心点偏一点都不可以，鲁棒性太差。而除以numel(x)后，会将所有的值都在一个很小的范围内，k值输出更平滑，鲁棒性更好。
                    %使用dog1数据集进行测试验证了分析，可以看到，当dog1中dog移动不大时，都可以跟踪到，稍微有点偏移就跟踪丢失了。
                    
