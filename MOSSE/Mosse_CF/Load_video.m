<<<<<<< HEAD
%ç”¨å‡½æ•°è¯»å–è§†é¢‘ï¼Œè¯»å–groundtruthæ•°æ®
function [videoData,ground_truth] = Load_video(videoDir)
    sequence_path = [videoDir,'\'];%æ–‡ä»¶è·¯å¾„
    videoFile = [sequence_path 'david.mpg']; %æ–‡ä»¶è·¯å¾„
    videoData = VideoReader(videoFile);%è¯»å–è§†é¢‘
% % for i = 1 : 50
% %         videoframe = read(videoData,i);% è¯»å–æ¯ä¸€å¸§
% %         videoframe= rgb2gray(videoframe);%è½¬æ¢ä¸ºç°åº¦å›¾
% %         imshow(videoframe);%æ˜¾ç¤ºæ¯ä¸€å¸§
% %         % imwrite(frame,strcat(num2str(i),'.jpg'),'jpg');% ä¿å­˜æ¯ä¸€å¸§
% % end
    %% Read files 
    ground_rect = csvread([sequence_path 'groundtruth_rect.txt']);%åºåˆ—ä¸­çœŸå®žç›®æ ‡ä½ç½®
    %% get position and boxsize è¯»å–groundtruthæ•°æ® 
    if(size(ground_rect,2)==1)%ä¸€åˆ—
        error('please add "," in groundtruth');%x,y,w,hç›®æ ‡æ¡†å¤§å°
    else if(size(ground_rect,2)==4)%4åˆ—
        ground_truth=ground_rect;%x,y,w,hç›®æ ‡æ¡†å¤§å°
=======
%ÓÃº¯Êý¶ÁÈ¡ÊÓÆµ£¬¶ÁÈ¡groundtruthÊý¾Ý
function [videoData,ground_truth] = Load_video(videoDir)
    sequence_path = [videoDir,'\'];%ÎÄ¼þÂ·¾¶
    videoFile = [sequence_path 'david.mpg']; %ÎÄ¼þÂ·¾¶
    videoData = VideoReader(videoFile);%¶ÁÈ¡ÊÓÆµ
% % for i = 1 : 50
% %         videoframe = read(videoData,i);% ¶ÁÈ¡Ã¿Ò»Ö¡
% %         videoframe= rgb2gray(videoframe);%×ª»»Îª»Ò¶ÈÍ¼
% %         imshow(videoframe);%ÏÔÊ¾Ã¿Ò»Ö¡
% %         % imwrite(frame,strcat(num2str(i),'.jpg'),'jpg');% ±£´æÃ¿Ò»Ö¡
% % end
    %% Read files 
    ground_rect = csvread([sequence_path 'groundtruth_rect.txt']);%ÐòÁÐÖÐÕæÊµÄ¿±êÎ»ÖÃ
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
end