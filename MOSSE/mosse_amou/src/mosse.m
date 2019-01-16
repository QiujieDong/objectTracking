clear ;clc
% get images from source directory
datadir = 'D:\\objectTracking\\configSeqs\\OTB-100';
dataset = 'RedTeam';
path = [datadir '\\' dataset];
img_path = [path '\\img\\'];
D = dir([img_path, '*.jpg']); % return a list of all the files in the current path and the folders
seq_len = length(D(not([D.isdir]))); % if files in the D are folders, isdir=1, otherwise isdir=0. 
if exist([img_path num2str(1, '%04i.jpg')], 'file') % Is there  a file named img_path/0001.jpg?
    img_files = num2str((1:seq_len)', [img_path '%04i.jpg']);%numstr比较特殊，会'\字母'认为特殊字符，所以要输入'\\字母'，这就是为什么datadir为'\\'
else
    error('No image files found in the directory.');
end

% select target from first frame
im = imread(img_files(1,:));
f = figure('Name', 'Select object to track'); %figure的name对象为'Select object to track'
imshow(im);
rect = getrect; %getrect使用鼠标在当前轴中选择一个矩形,rect返回的是矩形左上角坐标,矩形框的宽度和高度(x,y,width,height)
                %若将矩形约束为方形,使用shift或右键单击开始拖动.
close(f); clear f; %在第一帧上画出矩形后,取得矩形框信息,然后关闭第一帧图像
center = [rect(1)+rect(3)/2 rect(2)+rect(4)/2];%计算获得矩形点中心在整个图像上的width,height

% plot gaussian
sigma = 10;
a = 10;
gsize = size(im);%获得image像素的(row*column*channel)
[R,C] = ndgrid(1:gsize(1), 1:gsize(2));%R与C均为gsize(1)行,gsize(2)列,其中R为以1为步长,从1到gsize(1)进行列排列,C为从1到gsize(2)进行行排列
g = gaussC(C,R, sigma, a, center);
g = mat2gray(g);%将图像矩阵g归一化为图像矩阵g，归一化后矩阵中每个元素的值都在0到1范围内（包括0和1),其中0表示黑色,255表示白色.

% randomly warp original image to create training set
if (size(im,3) == 3) %image channel
    img = rgb2gray(im); %将图片由rgb变为gray
end
img = imcrop(img, rect);%crop原始图像,imcrop图像剪裁命令,RECT为可选参数，格式为[XMIN YMIN WIGTH HEIGHT].
g = imcrop(g, rect);%crop gauss image
G = fft2(g);%二维快速傅里叶变换,将时域问题转为频域问题,得到数字信号的分析频谱.
            %一维信号(如语音信号)用fft,二维信号(如图像信号)用fft2
            %傅里叶变换的基本思想是:任何连续测量的时序或信号，都可以表示为不同频率的正弦波信号的无限叠加(带棱角的信号可以被无限接近).
height = size(g,1);%取出剪切图像g的height
width = size(g,2);%取出剪切图像g的width
fi = preprocess(imresize(img, [height width]));%imresize缩放图像函数。imresize(A, [numrows numcols]),numrows和numcols分别指定目标图像的高度和宽度。
                                               %imresize 使用双三次方插值方法实现的图片缩放。
                                               %显而易见,由于这种格式允许图像缩放后长宽比例和源图像长宽比例不相同,因此所产生的图像有可能发生畸变。
Ai = (G.*conj(fft2(fi)));%conj函数：用于计算复数的共轭值
Bi = (fft2(fi).*conj(fft2(fi)));
% N = 128;
% %进行这个for循环的意思应该是通过叠加,增加系统鲁棒性,但是只在第一帧增加,后续运行会先前数据进行削弱,因此这里加上意义不大.下面我将每一帧都加上这种操作,
  % 时间上变得非常慢,而且由于rand_warp函数只处理旋转变形,对于其他变形并未进行处理,因此在Surfer数据集中当冲浪者蜷曲身子伸直时,容易出现跟踪失败.
% for i = 1:N
%     fi = preprocess(rand_warp(img));
%     Ai = Ai + (G.*conj(fft2(fi)));
%     Bi = Bi + (fft2(fi).*conj(fft2(fi)));
% end
% Ai = Ai / N;
% Bi = Bi / N; 
% MOSSE online training regimen
eta = 0.125;
fig = figure('Name', 'MOSSE');%画图框name为MOSSE
% mkdir(['results_' dataset]);%创建文件夹用来保存生成的带跟踪框的图像
time = clock;
for i = 1:size(img_files, 1) %依次取出所有图片
    img = imread(img_files(i,:));
    im = img;
    if (size(img,3) == 3) %变为灰度图像
        img = rgb2gray(img);
    end
    if (i == 1)
        Ai = eta.*Ai;
        Bi = eta.*Bi;
    else
        try
            Hi = Ai ./ Bi;%对应相除
            fi = imcrop(img, rect); 
            fi = preprocess(imresize(fi, [height width]));%这里截图之后直接对新帧的图像进行加窗，虽说解决了频谱泄露问题，但是也将新帧关于上一帧的中心位置
                                                          %突出了，但可能这并不是当前帧的中心位置，因此会出现漂移。
            gi = uint8(255*mat2gray(real(ifft2(Hi.*fft2(fi)))));%mat2gray将矩阵归一化.real取复数实部,imag取复数虚部.ifft2快速傅里叶反变换
                                                                %这里归一化然后乘以255再转换成8位操作,是因为8位图像数值为0-255.
            maxval = max(gi(:)); %取得gi矩阵中最大值
            [P, Q] = find(gi == maxval);%取得gi矩阵中最大值所在的位置,P=row,Q=column
            dx = mean(Q)-width/2;%得到第N帧图像与第N-1帧图像对比增加的dx与dy
            dy = mean(P)-height/2;

            rect = [rect(1)+dx rect(2)+dy width height];%调整矩形框位置,以得到的新的最大值位置作为矩形框中心,
            fi = imcrop(img, rect); %重新截图
            fi = preprocess(imresize(fi, [height width]));%对新截图加窗
    %         Ci = G.*conj(fft2(fi));
    %         Di = fft2(fi).*conj(fft2(fi));
    %         for j = 1:N
    %             fi = preprocess(rand_warp(fi));
    %             Ci = Ci+ (G.*conj(fft2(fi)));
    %             Di = Di + (fft2(fi).*conj(fft2(fi)));
    %         end
    %         Ai = eta.*(Ci) + (1-eta).*Ai;
    %         Bi = eta.*(Di) + (1-eta).*Bi;

            Ai = eta.*(G.*conj(fft2(fi))) + (1-eta).*Ai;%按论文更新Ai与Bi
            Bi = eta.*(fft2(fi).*conj(fft2(fi))) + (1-eta).*Bi;
        catch
            return
        end
    end
    
    % visualization
    text_str = ['Frame: ' num2str(i)];%在显示的图中需要显示的文字内容
    box_color = 'green';%显示文字的背景框颜色
    position=[1 1];%显示文字背景框左上角坐标,其大小跟随显示的内容改变
    result = insertText(im, position,text_str,'FontSize',15,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');
    %insertText:insert tex in image or video,return the processed image or video-BoxOpacity:文本框不透明度
    %insertShape:Insert shapes in image or video
    result = insertShape(result, 'Rectangle', rect, 'LineWidth', 3);
%     imwrite(result, ['results_' dataset num2str(i, '/%04i.jpg')]);%保存图像
    imshow(result);
end
disp(['Frames-per-second: ' num2str(seq_len / etime(clock,time))])
