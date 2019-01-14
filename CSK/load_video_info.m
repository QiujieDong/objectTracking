function [img_files, pos, target_sz, resize_image, ground_truth, video_path] = load_video_info(video_path)
%LOAD_VIDEO_INFO
%   Loads all the relevant information for the video in the given path:
%   the list of image files (cell array of strings), initial position
%   (1x2), target size (1x2), whether to resize the video to half
%   (boolean), and the ground truth information for precision calculations
%   (Nx2, for N frames). The ordering of coordinates is always [y, x].
%
%   The path to the video is returned, since it may change if the images
%   are located in a sub-folder (as is the default for MILTrack's videos).
%
%   Jo?o F. Henriques, 2012
%   http://www.isr.uc.pt/~henriques/

	%load ground truth from text file (MILTrack's format)
	text_files = dir([video_path '*_rect.txt']); %ground_truth_rect.txt中包含每一帧中目标真实所在位置
	assert(~isempty(text_files), 'No initial position and groundtruth_rect.txt to load.')%断言函数，若不满足条件，则跳出错误信息
                                        %如：assert(a>=0,'你的a小于0')：若a值大于等于0，则程序继续向下运行；若a值小于0，则打印错误提示信息"你的a小于0"

                                            %textscan函数，其实基本和textread差不多，但是其加入了更多的参数，有了很多优势。
                                            %textscan更适合读入大文件；可以从文件的任何位置开始读入，而textread 只能从文件开头开始读入；
                                            %只返回一个细胞矩阵，而textread要返回多个数组；提供更多转换读入数据的选择；提供给用户更多的配置参数。
	f = fopen([video_path text_files(1).name]);
	ground_truth = textscan(f, '%f,%f,%f,%f');  %[x, y, width, height]
    ground_truth = cat(2, ground_truth{:});%cat用来连接矩阵，2表示新连接的矩阵为二维，即行数和列数为所要连接矩阵的行数和列数
	fclose(f);                              
                                            
	%set initial position and size
	target_sz = [ground_truth(1,4), ground_truth(1,3)];%目标区域的[height, width]
	pos = [ground_truth(1,2), ground_truth(1,1)] + floor(target_sz/2);%pos为第一帧中目标区域中心点位置[y,x]，floor向负无穷大方向取整,
                                                                      %y与x是对整张图片来说的坐标值
	
	%interpolate missing annotations, and store positions instead of boxes
    %插入缺少的注释，同时保存位置而不是盒子。
	try
		ground_truth = interp1(1 : 5 : size(ground_truth,1), ground_truth(1:5:end,:), 1:size(ground_truth,1));
                                     %插值yi=interp1(x,y,xi,'method'),其中x，y为插值点，yi为在被插值点xi处的插值结果；x,y为向量，method缺省为线性插值
                                     %size(A,1)取A的行数，size(A,2)取A的列数，size(A)取A的行列数
		ground_truth = ground_truth(:,[2,1]) + ground_truth(:,[4,3]) / 2; %ground_truth为所有帧上目标区域中心点位置坐标[y, x]
	catch  %, wrong format or we just don't have ground truth data.
		ground_truth = [];
	end
	
	%list all frames. first, try MILTrack's format, where the initial and
	%final frame numbers are stored in a text file. if it doesn't work,
	%try to load all jpg/jpg files in the folder.
%% 官方源代码的 list all frames	
	text_files = dir([video_path '*_frames.txt']);%*_frame.txt是第一帧图像的名字序号与最后一帧图像名字序号。
	if ~isempty(text_files)
		f = fopen([video_path text_files(1).name]);
		frames = textscan(f, '%f,%f');
		fclose(f);
		
		%see if they are in the 'imgs' subfolder or not
		if exist([video_path num2str(frames{1}, 'img/%04i.jpg')], 'file')
			video_path = [video_path 'img/'];
		elseif ~exist([video_path num2str(frames{1}, 'img/%04i.jpg')], 'file')
			error('No image files to load.')
		end
		
		%list the files
		img_files = num2str((frames{1} : frames{2})', '%04i.jpg');
		img_files = cellstr(img_files);
	else
		%no text file, just list all images
		img_files = dir([video_path '*.jpg']); %在当前folder中寻找jpg图片
		if isempty(img_files)
            video_path = [video_path 'img/']; %若在当前folder中没有jpg图片，进入当前folder的subfolder的img中寻找jpg图片
			img_files = dir([video_path '*.jpg']);
			assert(~isempty(img_files), 'No image files to load.') %若在img这个subfolder中也没有jpg文件，弹出报错信息
		end
		img_files = sort({img_files.name});%sort(A)若A是向量不管是列还是行向量，默认都是对A进行升序排列。sort(A,'descend')是降序排序。
	end
%% 自己写过的的list all frames，通用性不如官方代码
%     startFrame = 1; %当图像序号不是从0001开始(BlurCar1数据集就是这样，从0247.jpg开始)，只需将startFrame改为起始帧就行(如BlurCar为startFrame = 247)
%     endFrame = length(ground_truth) + startFrame - 1;
%
%     if exist([video_path num2str(startFrame, 'img/%04i.jpg')], 'file')
%         video_path = [video_path 'img/'];
%     elseif ~exist([video_path num2str(startFrame, 'img/%04i.jpg')], 'file')
%         error('No image files to load.')
%     end	
% 
%     %list the files
%     img_files = num2str((startFrame : endFrame)', '%04i.jpg');
%     img_files = cellstr(img_files);
%%
    %if the target is too large, use a lower resolution - no need for so
    %如果图片太大，使用较低分辨率 - 不需要这样(在我们运行的数据集上图像都很小)
	%much detail
	if sqrt(prod(target_sz)) >= 100 %prod(target_sz)返回target_sz向量的各元素的乘积。。target_sz为第一帧图像中目标区域的的[height, width]
		pos = floor(pos / 2);
		target_sz = floor(target_sz / 2);
		resize_image = true;
	else
		resize_image = false;
	end
end

