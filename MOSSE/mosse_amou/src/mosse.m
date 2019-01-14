clear ;clc
% get images from source directory
<<<<<<< HEAD
datadir = '/home/qiujiedong/project/MatLAB_workspace/configSeqs/OTB-100/';
dataset = 'RedTeam';
path = [datadir dataset];
img_path = [path '/img/'];
D = dir([img_path, '*.jpg']); % return a list of all the files in the current path and the folders
seq_len = length(D(not([D.isdir]))); % if files in the D are folders, isdir=1, otherwise isdir=0. 
if exist([img_path num2str(1, '%04i.jpg')], 'file') % Is there  a file named img_path/0001.jpg?
    img_files = num2str((1:seq_len)', [img_path '%04i.jpg']);
=======
datadir = 'D:\\objectTracking\\configSeqs\\OTB-100';
dataset = 'RedTeam';
path = [datadir '\\' dataset];
img_path = [path '\\img\\'];
D = dir([img_path, '*.jpg']); % return a list of all the files in the current path and the folders
seq_len = length(D(not([D.isdir]))); % if files in the D are folders, isdir=1, otherwise isdir=0. 
if exist([img_path num2str(1, '%04i.jpg')], 'file') % Is there  a file named img_path/0001.jpg?
    img_files = num2str((1:seq_len)', [img_path '%04i.jpg']);%numstr�Ƚ����⣬��'\��ĸ'��Ϊ�����ַ�������Ҫ����'\\��ĸ'�������ΪʲôdatadirΪ'\\'
>>>>>>> NOSSE
else
    error('No image files found in the directory.');
end

% select target from first frame
im = imread(img_files(1,:));
<<<<<<< HEAD
f = figure('Name', 'Select object to track'); %figure的name对象为'Select object to track'
imshow(im);
rect = getrect; %getrect使用鼠标在当前轴中选择一个矩形,rect返回的是矩形左上角坐标,矩形框的宽度和高度(x,y,width,height)
                %若将矩形约束为方形,使用shift或右键单击开始拖动.
close(f); clear f; %在第一帧上画出矩形后,取得矩形框信息,然后关闭第一帧图像
center = [rect(1)+rect(3)/2 rect(2)+rect(4)/2];%计算获得矩形点中心在整个图像上的width,height
=======
f = figure('Name', 'Select object to track'); %figure��name����Ϊ'Select object to track'
imshow(im);
rect = getrect; %getrectʹ������ڵ�ǰ����ѡ��һ������,rect���ص��Ǿ������Ͻ�����,���ο�Ŀ��Ⱥ͸߶�(x,y,width,height)
                %��������Լ��Ϊ����,ʹ��shift���Ҽ�������ʼ�϶�.
close(f); clear f; %�ڵ�һ֡�ϻ������κ�,ȡ�þ��ο���Ϣ,Ȼ��رյ�һ֡ͼ��
center = [rect(1)+rect(3)/2 rect(2)+rect(4)/2];%�����þ��ε�����������ͼ���ϵ�width,height
>>>>>>> NOSSE

% plot gaussian
sigma = 10;
a = 10;
<<<<<<< HEAD
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
=======
gsize = size(im);%���image���ص�(row*column*channel)
[R,C] = ndgrid(1:gsize(1), 1:gsize(2));%R��C��Ϊgsize(1)��,gsize(2)��,����RΪ��1Ϊ����,��1��gsize(1)����������,CΪ��1��gsize(2)����������
g = gaussC(C,R, sigma, a, center);
g = mat2gray(g);%��ͼ�����g��һ��Ϊͼ�����g����һ���������ÿ��Ԫ�ص�ֵ����0��1��Χ�ڣ�����0��1),����0��ʾ��ɫ,255��ʾ��ɫ.

% randomly warp original image to create training set
if (size(im,3) == 3) %image channel
    img = rgb2gray(im); %��ͼƬ��rgb��Ϊgray
end
img = imcrop(img, rect);%cropԭʼͼ��,imcropͼ���������,RECTΪ��ѡ��������ʽΪ[XMIN YMIN WIGTH HEIGHT].
g = imcrop(g, rect);%crop gauss image
G = fft2(g);%��ά���ٸ���Ҷ�任,��ʱ������תΪƵ������,�õ������źŵķ���Ƶ��.
            %һά�ź�(�������ź�)��fft,��ά�ź�(��ͼ���ź�)��fft2
            %����Ҷ�任�Ļ���˼����:�κ�����������ʱ����źţ������Ա�ʾΪ��ͬƵ�ʵ����Ҳ��źŵ����޵���(����ǵ��źſ��Ա����޽ӽ�).
height = size(g,1);%ȡ������ͼ��g��height
width = size(g,2);%ȡ������ͼ��g��width
fi = preprocess(imresize(img, [height width]));%imresize����ͼ������imresize(A, [numrows numcols]),numrows��numcols�ֱ�ָ��Ŀ��ͼ��ĸ߶ȺͿ��ȡ�
                                               %imresize ʹ��˫���η���ֵ����ʵ�ֵ�ͼƬ���š�
                                               %�Զ��׼�,�������ָ�ʽ����ͼ�����ź󳤿�������Դͼ�񳤿���������ͬ,�����������ͼ���п��ܷ������䡣
Ai = (G.*conj(fft2(fi)));%conj���������ڼ��㸴���Ĺ���ֵ
Bi = (fft2(fi).*conj(fft2(fi)));
% N = 128;
% %�������forѭ������˼Ӧ����ͨ������,����ϵͳ³����,����ֻ�ڵ�һ֡����,�������л���ǰ���ݽ�������,�������������岻��.�����ҽ�ÿһ֡���������ֲ���,
  % ʱ���ϱ�÷ǳ���,��������rand_warp����ֻ������ת����,�����������β�δ���д���,�����Surfer���ݼ��е�����������������ֱʱ,���׳��ָ���ʧ��.
>>>>>>> NOSSE
% for i = 1:N
%     fi = preprocess(rand_warp(img));
%     Ai = Ai + (G.*conj(fft2(fi)));
%     Bi = Bi + (fft2(fi).*conj(fft2(fi)));
% end
% Ai = Ai / N;
% Bi = Bi / N; 
% MOSSE online training regimen
eta = 0.125;
<<<<<<< HEAD
fig = figure('Name', 'MOSSE');%画图框name为MOSSE
% mkdir(['results_' dataset]);%创建文件夹用来保存生成的带跟踪框的图像
time = clock;
for i = 1:size(img_files, 1) %依次取出所有图片
    img = imread(img_files(i,:));
    im = img;
    if (size(img,3) == 3) %变为灰度图像
=======
fig = figure('Name', 'MOSSE');%��ͼ��nameΪMOSSE
% mkdir(['results_' dataset]);%�����ļ��������������ɵĴ����ٿ��ͼ��
time = clock;
for i = 1:size(img_files, 1) %����ȡ������ͼƬ
    img = imread(img_files(i,:));
    im = img;
    if (size(img,3) == 3) %��Ϊ�Ҷ�ͼ��
>>>>>>> NOSSE
        img = rgb2gray(img);
    end
    if (i == 1)
        Ai = eta.*Ai;
        Bi = eta.*Bi;
    else
        try
<<<<<<< HEAD
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
=======
            Hi = Ai ./ Bi;%��Ӧ���
            fi = imcrop(img, rect); 
            fi = preprocess(imresize(fi, [height width]));%�����ͼ֮��ֱ�Ӷ���֡��ͼ����мӴ�����˵�����Ƶ��й¶���⣬����Ҳ����֡������һ֡������λ��
                                                          %ͻ���ˣ��������Ⲣ���ǵ�ǰ֡������λ�ã���˻����Ư�ơ�
            gi = uint8(255*mat2gray(real(ifft2(Hi.*fft2(fi)))));%mat2gray�������һ��.realȡ����ʵ��,imagȡ�����鲿.ifft2���ٸ���Ҷ���任
                                                                %�����һ��Ȼ�����255��ת����8λ����,����Ϊ8λͼ����ֵΪ0-255.
            maxval = max(gi(:)); %ȡ��gi���������ֵ
            [P, Q] = find(gi == maxval);%ȡ��gi���������ֵ���ڵ�λ��,P=row,Q=column
            dx = mean(Q)-width/2;%�õ���N֡ͼ�����N-1֡ͼ��Ա����ӵ�dx��dy
            dy = mean(P)-height/2;

            rect = [rect(1)+dx rect(2)+dy width height];%�������ο�λ��,�Եõ����µ����ֵλ����Ϊ���ο�����,
            fi = imcrop(img, rect); %���½�ͼ
            fi = preprocess(imresize(fi, [height width]));%���½�ͼ�Ӵ�
>>>>>>> NOSSE
    %         Ci = G.*conj(fft2(fi));
    %         Di = fft2(fi).*conj(fft2(fi));
    %         for j = 1:N
    %             fi = preprocess(rand_warp(fi));
    %             Ci = Ci+ (G.*conj(fft2(fi)));
    %             Di = Di + (fft2(fi).*conj(fft2(fi)));
    %         end
    %         Ai = eta.*(Ci) + (1-eta).*Ai;
    %         Bi = eta.*(Di) + (1-eta).*Bi;
<<<<<<< HEAD
            Ai = eta.*(G.*conj(fft2(fi))) + (1-eta).*Ai;%按论文更新Ai与Bi
=======
            Ai = eta.*(G.*conj(fft2(fi))) + (1-eta).*Ai;%�����ĸ���Ai��Bi
>>>>>>> NOSSE
            Bi = eta.*(fft2(fi).*conj(fft2(fi))) + (1-eta).*Bi;
        catch
            return
        end
    end
    
    % visualization
<<<<<<< HEAD
    text_str = ['Frame: ' num2str(i)];%在显示的图中需要显示的文字内容
    box_color = 'green';%显示文字的背景框颜色
    position=[1 1];%显示文字背景框左上角坐标,其大小跟随显示的内容改变
    result = insertText(im, position,text_str,'FontSize',15,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');
    %insertText:insert tex in image or video,return the processed image or video-BoxOpacity:文本框不透明度
    %insertShape:Insert shapes in image or video
    result = insertShape(result, 'Rectangle', rect, 'LineWidth', 3);
%     imwrite(result, ['results_' dataset num2str(i, '/%04i.jpg')]);%保存图像
=======
    text_str = ['Frame: ' num2str(i)];%����ʾ��ͼ����Ҫ��ʾ����������
    box_color = 'green';%��ʾ���ֵı�������ɫ
    position=[1 1];%��ʾ���ֱ��������Ͻ�����,���С������ʾ�����ݸı�
    result = insertText(im, position,text_str,'FontSize',15,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');
    %insertText:insert tex in image or video,return the processed image or video-BoxOpacity:�ı���͸����
    %insertShape:Insert shapes in image or video
    result = insertShape(result, 'Rectangle', rect, 'LineWidth', 3);
%     imwrite(result, ['results_' dataset num2str(i, '/%04i.jpg')]);%����ͼ��
>>>>>>> NOSSE
    imshow(result);
end
disp(['Frames-per-second: ' num2str(seq_len / etime(clock,time))])