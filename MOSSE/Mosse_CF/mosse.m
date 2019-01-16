%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function is correlation filter
%Visual Object Tracking using Adaptive Correlation Filters
%MOSSE
%date:2016-11-10
%author:WeiQin
%E-mail:285980893@qq.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;clc;
%% 载入视频文件
% videoDir = 'D:\ImageData\David';
% [videoData,ground_truth] = Load_video(videoDir);%调用函数读取视频，读取groundtruth数据
% img = read(videoData,1);% 读取第一帧
%% 载入图片文件
imgDir= 'D:\objectTracking\configSeqs\OTB-100\Basketball';%图片文件夹路径名
[ground_truth,img_path,img_files]=Load_image(imgDir);%调用函数读取图片帧，读取groundtruth数据
img = imread([img_path img_files{1}]);%读取目标帧
%% 起始帧，终止帧
startFrame=1;%起始帧
endFrame=length(img_files);%载入图片文件Load_image时的终止帧
% endFrame=videoData.NumberOfFrames;%载入视频文件Load_vedio时的终止帧
%% 转换为灰度图像
if(size(img,3)==1) %灰度图像
    im=img;
else
    im = rgb2gray(img);%转换为灰度图
end
%% 获取目标位置和框大小
%% set initial position and size
target_sz = [ground_truth(1,4), ground_truth(1,3)];%目标height和width
pos = [ground_truth(1,2), ground_truth(1,1)] + floor(target_sz/2);%目标中心点位置。floor-向负无穷大方向取整操作
positions = zeros(numel(img_files), 2);  %to calculate precision；numel返回数组中元素个数,若是一幅图像，numel将给出它的像素数
%产生高斯理想模板
F_response=templateGauss(target_sz,im);%高斯理想模板
%% 主循环读取全部图像帧
time = clock;  %to calculate FPS
eta = 0.125;
for frame=startFrame:endFrame
       %% training训练获得模板
        img = imread([img_path img_files{frame}]);%读取目标帧(载入图片文件Load_image时)
%         img = read(videoData,frame);% 读取目标帧(载入视频文件Load_vedio时)
       %% 转换为灰度图像
        if(size(img,3)==1) %灰度图像
            im=img;
        else
            im = rgb2gray(img);%转换为灰度图
        end
        target_box=getsubbox(pos,target_sz,im);%获取目标框
        tic()
       %% 训练结束开始跟踪并更新模板
    if frame>startFrame
        newPoint=real(ifft2(F_Template.*fft2(target_box)));%进行反变换
%         newPoint=uint8(newPoint);
%         subplot(1,2,1)
%         imshow(256.*newPoint);
        [row, col,~] = find(newPoint == max(newPoint(:)), 1);%以最大值位置作为新的目标位置
        pos = pos - target_sz/2 + [row, col]; 
    end
    %%
    %save position and calculate FPS
	positions(frame,:) = pos;
    F_im= fft2(getsubbox(pos,target_sz,im));%对剪切出的目标图像进行傅里叶变换,但经FFT后，F_im内有了负值
%     F_im=templateGauss(target_sz,F_im);%这是我自己加的在这里对傅里叶变换后的图像进行高斯处理。通过运行各个数据集发现一个问题，
                       %当原代码在运行时，会输出相关性大的位置作为响应最大值输出，但注意一点是，相关性大有时候会漂移不是目标中心点。
                       %由于并未对新一帧图像做任何处理，当背景连续两帧出现在跟踪区域内，那在相关性上来说，这两帧在背景区域的相关性值也会很高，如果这个
                       %值超过目标中心点的值，那么就会造成漂移，这样就会造成以背景为主了，慢慢的会丢失目标。还有一种情况是如果背景中出现与目标上像素值
                       %一样的(如RedTeam数据集车上面有白色，而经过白色电线杆时就会误认为电线杆为目标)，认为电线杆正好也是白色，当与跟踪器相乘时，其相关性值
                       %也会很大，就会被误认为目标，这似乎是目标跟踪中另一个问题，就是目标与背景颜色相近的研究。
                       %但是加上高斯处理后，产生的新问题是，目标产生形变或旋转时，由于会造成目标中心移动，因此跟踪效果会不好。
    F_Template=(conj(F_im.*conj(F_response))./(F_im.*conj(F_im)+eps));%相关滤波器$H^*$更新
    %% 画跟踪框
%         subplot(1,2,2)
    rect_position = [pos([2,1]) - (target_sz([2,1])/2), (target_sz([2,1]))]; %新跟踪框位置y,x,height,width,
    if frame == 1  %first frame, create GUI
            figure
            im_handle = imagesc(uint8(img));%将矩阵中的元素数值按大小转化为不同颜色，并在坐标轴对应位置处以这种颜色染色。
            rect_handle = rectangle('Position',rect_position,'LineWidth',2,'EdgeColor','r');
            tex_handle = text(5, 18, strcat('#',num2str(frame)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
            drawnow;
    else
        try  %subsequent frames, update GUI
			set(im_handle, 'CData', img)%CData 是MATLAB里存放图像数据的一个矩阵 你可以使用get语句去得到他的句柄，然后做相应的图像处理。
			set(rect_handle, 'Position', rect_position)
            set(tex_handle, 'string', strcat('#',num2str(frame)))
%             pause(0.001);
            drawnow;
		catch  % #ok, user has closed the window
			return
        end
    end
%         imagesc(uint8(img))
%         colormap(gray)
%         rect_position = [pos([2,1]) - (target_sz([2,1])/2), (target_sz([2,1]))]; 
%         rectangle('Position',rect_position,'LineWidth',4,'EdgeColor','r');
%         hold on;
%         text(5, 18, strcat('#',num2str(frame)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
% %         set(gca,'position',[0 0 1 1]); 
%         pause(0.001); 
%         hold off;
%         drawnow;
end
disp(['Frames-per-second: ' num2str(numel(img_files) / etime(clock,time))])

%show the precisions plot
show_precision(positions, ground_truth, imgDir)
