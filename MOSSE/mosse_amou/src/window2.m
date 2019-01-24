% This function creates a 2 dimentional window for a sample image, it takes
% the dimension of the window and applies the 1D window function
% This is does NOT using a rotational symmetric method to generate a 2 window
%
% Disi A ---- May,16, 2013
%     [N,M]=size(imgage);
% ---------------------------------------------------------------------
%     w_type is defined by the following 
%     @bartlett       - Bartlett window.
%     @barthannwin    - Modified Bartlett-Hanning window. 
%     @blackman       - Blackman window.
%     @blackmanharris - Minimum 4-term Blackman-Harris window.
%     @bohmanwin      - Bohman window.
%     @chebwin        - Chebyshev window.
%     @flattopwin     - Flat Top window.
%     @gausswin       - Gaussian window.
%     @hamming        - Hamming window.
%     @hann           - Hann window.
%     @kaiser         - Kaiser window.
%     @nuttallwin     - Nuttall defined minimum 4-term Blackman-Harris window.
%     @parzenwin      - Parzen (de la Valle-Poussin) window.
%     @rectwin        - Rectangular window.
%     @taylorwin      - Taylor window.
%     @tukeywin       - Tukey window.
%     @triang         - Triangular window.
%
%   Example: 
%   To compute windowed 2D fFT
%   [r,c]=size(img);
%   w=window2(r,c,@hamming);
% 	fft2(img.*w);

%加窗主要是在时域内进行(在时域内是相乘,在频域内是卷积运算),其主要作用是减小由于信号裁剪带来的频谱泄露.
%频谱泄露使能量较低的谱线很容易被临近的能量较高的谱线的泄露给淹没住

function w=window2(N,M,w_func)

wr=window(w_func,N);%wr为一维列向量,维度为height x 1
wc=window(w_func,M);%wc为一维列向量,维度为width x 1
% disp("wr")
% size(wr)
% disp("wc")
% size(wc)
[maskr,maskc]=meshgrid(wc,wr);%meshgrid函数绘制二维或三维网络.maskr与maskc的维度一样,均为height x width
%[X,Y]=meshgrid(x,y)基于向量x和y中包含的坐标返回二维网格坐标。X 是一个矩阵,每一行是x的一个副本;Y也是一个矩阵,每一列是y的一个副本.坐标X和Y表示的网格有length(y)个行和length(x)个列。
%maskc=repmat(wc,1,M); Old version
%maskr=repmat(wr',N,1);

% disp("maskr")
% size(maskr)
% disp("maskc")
% size(maskc)

w=maskr.*maskc;%生成与crop image相同维度的窗 
% disp("w")
% size(w)
end