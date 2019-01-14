<<<<<<< HEAD
%è°ƒç”¨å‡½æ•°è¯»å–å›¾ç‰‡å¸§ï¼Œè¯»å–groundtruthæ•°æ®
=======
%µ÷ÓÃº¯Êý¶ÁÈ¡Í¼Æ¬Ö¡£¬¶ÁÈ¡groundtruthÊý¾Ý
>>>>>>> NOSSE
function [ground_truth,img_path,img_files]=Load_image(imgDir)
%     %% Read params.txt
%     params = readParams('params.txt');
	%% load video info
<<<<<<< HEAD
    sequence_path = [imgDir,'/'];%æ–‡ä»¶è·¯å¾„
    img_path = [sequence_path 'img/'];
    %% Read files 
    ground_rect = csvread([sequence_path 'groundtruth_rect.txt']);%åºåˆ—ä¸­çœŸå®žç›®æ ‡ä½ç½®
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % read all the frames in the 'imgs' subfolder
    dir_content = dir([sequence_path 'img/']);
    % skip '.' and '..' from the count
    n_imgs = length(dir_content)- 2 ;
    img_files = cell(n_imgs, 1);% å¾—åˆ°n_imgsè¡Œï¼Œ1åˆ—çš„ç©ºå…ƒèƒžæ•°ç»„ã€‚MATLABå…ƒèƒžæ•°ç»„ï¼ˆcellï¼‰å¯ä»¥å°†æµ®ç‚¹åž‹ã€å­—ç¬¦åž‹ã€ç»“æž„æ•°ç»„ç­‰ä¸åŒç±»åž‹çš„æ•°æ®æ”¾åœ¨åŒä¸€ä¸ªå­˜å‚¨å•å…ƒä¸­ã€‚
    for ii = 1:n_imgs
        img_files{ii} = dir_content(ii+2).name;
    end
    %% get position and boxsize è¯»å–groundtruthæ•°æ® 
    if(size(ground_rect,2)==1)%ä¸€åˆ—
        error('please add "," in groundtruth');%x,y,w,hç›®æ ‡æ¡†å¤§å°
    else if(size(ground_rect,2)==4)%4åˆ—
        ground_truth=ground_rect;%x,y,w,hç›®æ ‡æ¡†å¤§å°
=======
    sequence_path = [imgDir,'\'];%ÎÄ¼þÂ·¾¶
    img_path = [sequence_path 'img\'];
    %% Read files 
    ground_rect = csvread([sequence_path 'groundtruth_rect.txt']);%ÐòÁÐÖÐÕæÊµÄ¿±êÎ»ÖÃ
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % read all the frames in the 'imgs' subfolder
    dir_content = dir([sequence_path 'img\']);
    % skip '.' and '..' from the count
    n_imgs = length(dir_content)- 2 ;
    img_files = cell(n_imgs, 1);% µÃµ½n_imgsÐÐ£¬1ÁÐµÄ¿ÕÔª°ûÊý×é¡£MATLABÔª°ûÊý×é£¨cell£©¿ÉÒÔ½«¸¡µãÐÍ¡¢×Ö·ûÐÍ¡¢½á¹¹Êý×éµÈ²»Í¬ÀàÐÍµÄÊý¾Ý·ÅÔÚÍ¬Ò»¸ö´æ´¢µ¥ÔªÖÐ¡£
    for ii = 1:n_imgs
        img_files{ii} = dir_content(ii+2).name;
    end
    %% get position and boxsize ¶ÁÈ¡groundtruthÊý¾Ý 
    if(size(ground_rect,2)==1)%Ò»ÁÐ
        error('please add "," in groundtruth');%x,y,w,hÄ¿±ê¿ò´óÐ¡
    else if(size(ground_rect,2)==4)%4ÁÐ
        ground_truth=ground_rect;%x,y,w,hÄ¿±ê¿ò´óÐ¡
>>>>>>> NOSSE
    else
        error('something wrong in groundtruth');
        end
    end
<<<<<<< HEAD
%     im = imread([img_path img_files{1}]);%è¯»å–ç›®æ ‡å¸§
%     im= rgb2gray(im);%è½¬æ¢ä¸ºç°åº¦å›¾
=======
%     im = imread([img_path img_files{1}]);%¶ÁÈ¡Ä¿±êÖ¡
%     im= rgb2gray(im);%×ª»»Îª»Ò¶ÈÍ¼
>>>>>>> NOSSE
%     imshow(im);
end