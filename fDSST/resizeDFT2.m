function resizeddft  = resizeDFT2(inputdft, desiredSize)

imsz = size(inputdft);
minsz = min(imsz, desiredSize);

scaling = prod(desiredSize)/prod(imsz);

resizeddft = complex(zeros(desiredSize, 'single'));%complex - 创建复数数组.此 MATLAB 函数 通过两个实数输入创建一个复数输出 z，这样 z = a + bi。

mids = ceil(minsz/2);
mide = floor((minsz-1)/2) - 1;

%下面进行子网格插值，其功能和imresize一样。论文中也提到了，子网格插值后其余位置是zero-padding。
%因为所有的值都是同比例扩大，所以数据本质上没有改变，但是这样进一步"细化"了图像矩阵，中间值彻底变为0
%输出mesh(inputdft)和mesh(real(desiredSize))后可以观察到，inputdft高值也在四角，但是其平滑的过渡到中心，所以接近中心位置有些并不是0.
%但是我们进行imresize一般是在时域内，而这里直接在傅氏空间进行子网格插值，会造成生成的resizeddft不对称，这样进行ifft后生成的矩阵仍然是复数矩阵
%所以在fDSST.m的第134行，进行ifft时使用'symmetric'参数。
resizeddft(1:mids(1), 1:mids(2)) = scaling * inputdft(1:mids(1), 1:mids(2));%值都到了resizeddft的四角，中间是zero-padding
resizeddft(1:mids(1), end - mide(2):end) = scaling * inputdft(1:mids(1), end - mide(2):end);
resizeddft(end - mide(1):end, 1:mids(2)) = scaling * inputdft(end - mide(1):end, 1:mids(2));
resizeddft(end - mide(1):end, end - mide(2):end) = scaling * inputdft(end - mide(1):end, end - mide(2):end);
end