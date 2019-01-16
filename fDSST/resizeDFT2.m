function resizeddft  = resizeDFT2(inputdft, desiredSize)

imsz = size(inputdft);
minsz = min(imsz, desiredSize);

scaling = prod(desiredSize)/prod(imsz);

resizeddft = complex(zeros(desiredSize, 'single'));%complex - 创建复数数组.此 MATLAB 函数 通过两个实数输入创建一个复数输出 z，这样 z = a + bi。

mids = ceil(minsz/2);
mide = floor((minsz-1)/2) - 1;

resizeddft(1:mids(1), 1:mids(2)) = scaling * inputdft(1:mids(1), 1:mids(2));%值都到了resizeddft的四角，中间是zero-padding
resizeddft(1:mids(1), end - mide(2):end) = scaling * inputdft(1:mids(1), end - mide(2):end);
resizeddft(end - mide(1):end, 1:mids(2)) = scaling * inputdft(end - mide(1):end, 1:mids(2));
resizeddft(end - mide(1):end, end - mide(2):end) = scaling * inputdft(end - mide(1):end, end - mide(2):end);
end