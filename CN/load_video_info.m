function [img_files, pos, target_sz, ground_truth, video_path] = load_video_info(base_path, video)
%LOAD_VIDEO_INFO
%   Loads all the relevant information for the video in the given path:
%   the list of image files (cell array of strings), initial position
%   (1x2), target size (1x2), the ground truth information for precision
%   calculations (Nx2, for N frames), and the path where the images are
%   located. The ordering of coordinates and sizes is always [y, x].
%
%   Joao F. Henriques, 2014
%   http://www.isr.uc.pt/~henriques/
%使用KCF的load_video_info.m替换了原来的load_video_info.m函数，KCF的这个好用。
%同时为了适应CN代码，对部分做了修改。

	%see if there's a suffix(后缀), specifying(确定) one of multiple targets, for
	%example the dot and number in 'Jogging.1' or 'Jogging.2'.
    %处理像"Jogging"这种一个文件夹包含两个视频信息的情况，在我使用数据集时，已手动分开
	if numel(video) >= 2 && video(end-1) == '.' && ~isnan(str2double(video(end)))
		suffix = video(end-1:end);  %remember the suffix
		video = video(1:end-2);  %remove it from the video name
	else
		suffix = '';
	end

	%full path to the video's files
	if base_path(end) ~= '/' && base_path(end) ~= '\'
		base_path(end+1) = '/';
	end
	video_path = [base_path video '/'];

	%try to load ground truth from text file (Benchmark's format)
	filename = [video_path 'groundtruth_rect' suffix '.txt'];
	f = fopen(filename);
	assert(f ~= -1, ['No initial position or ground truth to load ("' filename '").'])
    
    %textscan - 将已打开的文本文件中的数据读取到元胞数组 C
    %当 textscan 未能读取或转换数据时的行为，指定为由 'ReturnOnError' 和 true/false 组成的逗号分隔对组。如果是 true，则 textscan 终止，
    %不产生错误，返回所有读取的字段。如果是 false，则 textscan 终止，产生错误，不返回输出元胞数组。
    
    %the format is [x, y, width, height]
	try
		ground_truth = textscan(f, '%f,%f,%f,%f', 'ReturnOnError',false);  
	catch  % try different format (no commas)
		frewind(f);      %frewind - 将文件位置指示符移至所打开文件的开头
		ground_truth = textscan(f, '%f %f %f %f');  
	end
	ground_truth = cat(2, ground_truth{:});%cat - 沿指定维度串联数组,cat(dim,A,B),dim=1是[A;B],dim=2是[A,B]
	fclose(f);
	
	%set initial position and size
	target_sz = [ground_truth(1,4), ground_truth(1,3)];
%     pos = [ground_truth(1,2), ground_truth(1,1)] +floor(target_sz/2);  %KCF中是这个
	pos = [ground_truth(1,2), ground_truth(1,1)] ;%这里CN用的pos不是中心坐标，而是左上角坐标
	
	if size(ground_truth,1) == 1%返回ground_truth在第一个维度的长度，即返回ground_truth的行数
		%we have ground truth for the first frame only (initial position)
		ground_truth = [];
	else
		%store positions instead of boxes
%         ground_truth = ground_truth(:,[2,1]) + ground_truth(:,[4,3]) /2; %KCF中是这个
		ground_truth = [ground_truth(:,[2,1]) + (ground_truth(:,[4,3]) - 1) / 2 , ground_truth(:,[4,3])];%这里减去1操作，对评价指标影响都不大。
	end
	
	
	%from now on, work in the subfolder where all the images are
	video_path = [video_path 'img/'];
	
	%for these sequences, we must limit ourselves to a range of frames.
	%for all others, we just load all png/jpg files in the folder.
    %对于几个特殊的视频集，只取其数据集中的一部分帧。其他的视频集取所有帧
	frames = {'David', 300, 770;
			  'Football1', 1, 74;
			  'Freeman3', 1, 460;
			  'Freeman4', 1, 283};
	
	idx = find(strcmpi(video, frames(:,1))); %strcmpi - 比较字符串（不区分大小写）,如果二者相同，函数将返回 1 (true)，否则返回空向量
	
	if isempty(idx) 
		%general case, just list all images
		img_files = dir([video_path '*.png']);%dir输出格式为struct结构体数组
		if isempty(img_files)
			img_files = dir([video_path '*.jpg']);
			assert(~isempty(img_files), 'No image files to load.')
		end
		img_files = sort({img_files.name});%sort - 按升序对数组元素进行排序，输出的格式为cell元胞数组
	else
		%list specified frames. try png first, then jpg.
		if exist(sprintf('%s%04i.png', video_path, frames{idx,2}), 'file')
			img_files = num2str((frames{idx,2} : frames{idx,3})', '%04i.png');%输出格式为char字符串
			
		elseif exist(sprintf('%s%04i.jpg', video_path, frames{idx,2}), 'file')
			img_files = num2str((frames{idx,2} : frames{idx,3})', '%04i.jpg');
			
		else
			error('No image files to load.')
		end
		
		img_files = cellstr(img_files);%将char类型转换成cell元胞数组
	end
	
end
