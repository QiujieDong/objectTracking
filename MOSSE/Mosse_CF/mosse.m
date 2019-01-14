%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function is correlation filter
%Visual Object Tracking using Adaptive Correlation Filters
%MOSSE
%date:2016-11-10
%author:WeiQin
%E-mail:285980893@qq.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;clc;
<<<<<<< HEAD
%% è½½å…¥è§†é¢‘æ–‡ä»¶
% videoDir = 'D:\ImageData\David';
% [videoData,ground_truth] = Load_video(videoDir);%è°ƒç”¨å‡½æ•°è¯»å–è§†é¢‘ï¼Œè¯»å–groundtruthæ•°æ®
% img = read(videoData,1);% è¯»å–ç¬¬ä¸€å¸§
%% è½½å…¥å›¾ç‰‡æ–‡ä»¶
imgDir='/home/qiujiedong/project/MatLAB_workspace/configSeqs/OTB-100/Basketball';%å›¾ç‰‡æ–‡ä»¶å¤¹è·¯å¾„å
[ground_truth,img_path,img_files]=Load_image(imgDir);%è°ƒç”¨å‡½æ•°è¯»å–å›¾ç‰‡å¸§ï¼Œè¯»å–groundtruthæ•°æ®
img = imread([img_path img_files{1}]);%è¯»å–ç›®æ ‡å¸§
%% èµ·å§‹å¸§ï¼Œç»ˆæ­¢å¸§
startFrame=1;%èµ·å§‹å¸§
endFrame=length(img_files);%è½½å…¥å›¾ç‰‡æ–‡ä»¶Load_imageæ—¶çš„ç»ˆæ­¢å¸§
% endFrame=videoData.NumberOfFrames;%è½½å…¥è§†é¢‘æ–‡ä»¶Load_vedioæ—¶çš„ç»ˆæ­¢å¸§
%% è½¬æ¢ä¸ºç°åº¦å›¾åƒ
if(size(img,3)==1) %ç°åº¦å›¾åƒ
    im=img;
else
    im = rgb2gray(img);%è½¬æ¢ä¸ºç°åº¦å›¾
end
%% èŽ·å–ç›®æ ‡ä½ç½®å’Œæ¡†å¤§å°
%% set initial position and size
target_sz = [ground_truth(1,4), ground_truth(1,3)];%ç›®æ ‡heightå’Œwidth
pos = [ground_truth(1,2), ground_truth(1,1)] + floor(target_sz/2);%ç›®æ ‡ä¸­å¿ƒç‚¹ä½ç½®ã€‚floor-å‘è´Ÿæ— ç©·å¤§æ–¹å‘å–æ•´æ“ä½œ
positions = zeros(numel(img_files), 2);  %to calculate precisionï¼›numelè¿”å›žæ•°ç»„ä¸­å…ƒç´ ä¸ªæ•°,è‹¥æ˜¯ä¸€å¹…å›¾åƒï¼Œnumelå°†ç»™å‡ºå®ƒçš„åƒç´ æ•°
%äº§ç”Ÿé«˜æ–¯ç†æƒ³æ¨¡æ¿
F_response=templateGauss(target_sz,im);%é«˜æ–¯ç†æƒ³æ¨¡æ¿
%% ä¸»å¾ªçŽ¯è¯»å–å…¨éƒ¨å›¾åƒå¸§
time = clock;  %to calculate FPS
eta = 0.125;
for frame=startFrame:endFrame
       %% trainingè®­ç»ƒèŽ·å¾—æ¨¡æ¿
        img = imread([img_path img_files{frame}]);%è¯»å–ç›®æ ‡å¸§(è½½å…¥å›¾ç‰‡æ–‡ä»¶Load_imageæ—¶)
%         img = read(videoData,frame);% è¯»å–ç›®æ ‡å¸§(è½½å…¥è§†é¢‘æ–‡ä»¶Load_vedioæ—¶)
       %% è½¬æ¢ä¸ºç°åº¦å›¾åƒ
        if(size(img,3)==1) %ç°åº¦å›¾åƒ
            im=img;
        else
            im = rgb2gray(img);%è½¬æ¢ä¸ºç°åº¦å›¾
        end
        target_box=getsubbox(pos,target_sz,im);%èŽ·å–ç›®æ ‡æ¡†
        tic()
       %% è®­ç»ƒç»“æŸå¼€å§‹è·Ÿè¸ªå¹¶æ›´æ–°æ¨¡æ¿
    if frame>startFrame
        newPoint=real(ifft2(F_Template.*fft2(target_box)));%è¿›è¡Œåå˜æ¢
%         newPoint=uint8(newPoint);
%         subplot(1,2,1)
%         imshow(256.*newPoint);
        [row, col,~] = find(newPoint == max(newPoint(:)), 1);%ä»¥æœ€å¤§å€¼ä½ç½®ä½œä¸ºæ–°çš„ç›®æ ‡ä½ç½®
=======
%% ÔØÈëÊÓÆµÎÄ¼þ
% videoDir = 'D:\ImageData\David';
% [videoData,ground_truth] = Load_video(videoDir);%µ÷ÓÃº¯Êý¶ÁÈ¡ÊÓÆµ£¬¶ÁÈ¡groundtruthÊý¾Ý
% img = read(videoData,1);% ¶ÁÈ¡µÚÒ»Ö¡
%% ÔØÈëÍ¼Æ¬ÎÄ¼þ
imgDir= 'D:\objectTracking\configSeqs\OTB-100\Basketball';%Í¼Æ¬ÎÄ¼þ¼ÐÂ·¾¶Ãû
[ground_truth,img_path,img_files]=Load_image(imgDir);%µ÷ÓÃº¯Êý¶ÁÈ¡Í¼Æ¬Ö¡£¬¶ÁÈ¡groundtruthÊý¾Ý
img = imread([img_path img_files{1}]);%¶ÁÈ¡Ä¿±êÖ¡
%% ÆðÊ¼Ö¡£¬ÖÕÖ¹Ö¡
startFrame=1;%ÆðÊ¼Ö¡
endFrame=length(img_files);%ÔØÈëÍ¼Æ¬ÎÄ¼þLoad_imageÊ±µÄÖÕÖ¹Ö¡
% endFrame=videoData.NumberOfFrames;%ÔØÈëÊÓÆµÎÄ¼þLoad_vedioÊ±µÄÖÕÖ¹Ö¡
%% ×ª»»Îª»Ò¶ÈÍ¼Ïñ
if(size(img,3)==1) %»Ò¶ÈÍ¼Ïñ
    im=img;
else
    im = rgb2gray(img);%×ª»»Îª»Ò¶ÈÍ¼
end
%% »ñÈ¡Ä¿±êÎ»ÖÃºÍ¿ò´óÐ¡
%% set initial position and size
target_sz = [ground_truth(1,4), ground_truth(1,3)];%Ä¿±êheightºÍwidth
pos = [ground_truth(1,2), ground_truth(1,1)] + floor(target_sz/2);%Ä¿±êÖÐÐÄµãÎ»ÖÃ¡£floor-Ïò¸ºÎÞÇî´ó·½ÏòÈ¡Õû²Ù×÷
positions = zeros(numel(img_files), 2);  %to calculate precision£»numel·µ»ØÊý×éÖÐÔªËØ¸öÊý,ÈôÊÇÒ»·ùÍ¼Ïñ£¬numel½«¸ø³öËüµÄÏñËØÊý
%²úÉú¸ßË¹ÀíÏëÄ£°å
F_response=templateGauss(target_sz,im);%¸ßË¹ÀíÏëÄ£°å
%% Ö÷Ñ­»·¶ÁÈ¡È«²¿Í¼ÏñÖ¡
time = clock;  %to calculate FPS
eta = 0.125;
for frame=startFrame:endFrame
       %% trainingÑµÁ·»ñµÃÄ£°å
        img = imread([img_path img_files{frame}]);%¶ÁÈ¡Ä¿±êÖ¡(ÔØÈëÍ¼Æ¬ÎÄ¼þLoad_imageÊ±)
%         img = read(videoData,frame);% ¶ÁÈ¡Ä¿±êÖ¡(ÔØÈëÊÓÆµÎÄ¼þLoad_vedioÊ±)
       %% ×ª»»Îª»Ò¶ÈÍ¼Ïñ
        if(size(img,3)==1) %»Ò¶ÈÍ¼Ïñ
            im=img;
        else
            im = rgb2gray(img);%×ª»»Îª»Ò¶ÈÍ¼
        end
        target_box=getsubbox(pos,target_sz,im);%»ñÈ¡Ä¿±ê¿ò
        tic()
       %% ÑµÁ·½áÊø¿ªÊ¼¸ú×Ù²¢¸üÐÂÄ£°å
    if frame>startFrame
        newPoint=real(ifft2(F_Template.*fft2(target_box)));%½øÐÐ·´±ä»»
%         newPoint=uint8(newPoint);
%         subplot(1,2,1)
%         imshow(256.*newPoint);
        [row, col,~] = find(newPoint == max(newPoint(:)), 1);%ÒÔ×î´óÖµÎ»ÖÃ×÷ÎªÐÂµÄÄ¿±êÎ»ÖÃ
>>>>>>> NOSSE
        pos = pos - target_sz/2 + [row, col]; 
    end
    %%
    %save position and calculate FPS
	positions(frame,:) = pos;
<<<<<<< HEAD
    F_im= fft2(getsubbox(pos,target_sz,im));%å¯¹å‰ªåˆ‡å‡ºçš„ç›®æ ‡å›¾åƒè¿›è¡Œå‚…é‡Œå¶å˜æ¢,ä½†ç»FFTåŽï¼ŒF_imå†…æœ‰äº†è´Ÿå€¼
%     F_im=templateGauss(target_sz,F_im);%è¿™æ˜¯æˆ‘è‡ªå·±åŠ çš„åœ¨è¿™é‡Œå¯¹å‚…é‡Œå¶å˜æ¢åŽçš„å›¾åƒè¿›è¡Œé«˜æ–¯å¤„ç†ã€‚é€šè¿‡è¿è¡Œå„ä¸ªæ•°æ®é›†å‘çŽ°ä¸€ä¸ªé—®é¢˜ï¼Œ
                       %å½“åŽŸä»£ç åœ¨è¿è¡Œæ—¶ï¼Œä¼šè¾“å‡ºç›¸å…³æ€§å¤§çš„ä½ç½®ä½œä¸ºå“åº”æœ€å¤§å€¼è¾“å‡ºï¼Œä½†æ³¨æ„ä¸€ç‚¹æ˜¯ï¼Œç›¸å…³æ€§å¤§æœ‰æ—¶å€™ä¼šæ¼‚ç§»ä¸æ˜¯ç›®æ ‡ä¸­å¿ƒç‚¹ã€‚
                       %ç”±äºŽå¹¶æœªå¯¹æ–°ä¸€å¸§å›¾åƒåšä»»ä½•å¤„ç†ï¼Œå½“èƒŒæ™¯è¿žç»­ä¸¤å¸§å‡ºçŽ°åœ¨è·Ÿè¸ªåŒºåŸŸå†…ï¼Œé‚£åœ¨ç›¸å…³æ€§ä¸Šæ¥è¯´ï¼Œè¿™ä¸¤å¸§åœ¨èƒŒæ™¯åŒºåŸŸçš„ç›¸å…³æ€§å€¼ä¹Ÿä¼šå¾ˆé«˜ï¼Œå¦‚æžœè¿™ä¸ª
                       %å€¼è¶…è¿‡ç›®æ ‡ä¸­å¿ƒç‚¹çš„å€¼ï¼Œé‚£ä¹ˆå°±ä¼šé€ æˆæ¼‚ç§»ï¼Œè¿™æ ·å°±ä¼šé€ æˆä»¥èƒŒæ™¯ä¸ºä¸»äº†ï¼Œæ…¢æ…¢çš„ä¼šä¸¢å¤±ç›®æ ‡ã€‚è¿˜æœ‰ä¸€ç§æƒ…å†µæ˜¯å¦‚æžœèƒŒæ™¯ä¸­å‡ºçŽ°ä¸Žç›®æ ‡ä¸Šåƒç´ å€¼
                       %ä¸€æ ·çš„(å¦‚RedTeamæ•°æ®é›†è½¦ä¸Šé¢æœ‰ç™½è‰²ï¼Œè€Œç»è¿‡ç™½è‰²ç”µçº¿æ†æ—¶å°±ä¼šè¯¯è®¤ä¸ºç”µçº¿æ†ä¸ºç›®æ ‡)ï¼Œè®¤ä¸ºç”µçº¿æ†æ­£å¥½ä¹Ÿæ˜¯ç™½è‰²ï¼Œå½“ä¸Žè·Ÿè¸ªå™¨ç›¸ä¹˜æ—¶ï¼Œå…¶ç›¸å…³æ€§å€¼
                       %ä¹Ÿä¼šå¾ˆå¤§ï¼Œå°±ä¼šè¢«è¯¯è®¤ä¸ºç›®æ ‡ï¼Œè¿™ä¼¼ä¹Žæ˜¯ç›®æ ‡è·Ÿè¸ªä¸­å¦ä¸€ä¸ªé—®é¢˜ï¼Œå°±æ˜¯ç›®æ ‡ä¸ŽèƒŒæ™¯é¢œè‰²ç›¸è¿‘çš„ç ”ç©¶ã€‚
                       %ä½†æ˜¯åŠ ä¸Šé«˜æ–¯å¤„ç†åŽï¼Œäº§ç”Ÿçš„æ–°é—®é¢˜æ˜¯ï¼Œç›®æ ‡äº§ç”Ÿå½¢å˜æˆ–æ—‹è½¬æ—¶ï¼Œç”±äºŽä¼šé€ æˆç›®æ ‡ä¸­å¿ƒç§»åŠ¨ï¼Œå› æ­¤è·Ÿè¸ªæ•ˆæžœä¼šä¸å¥½ã€‚
    F_Template=(conj(F_im.*conj(F_response))./(F_im.*conj(F_im)+eps));%ç›¸å…³æ»¤æ³¢å™¨$H^*$æ›´æ–°
    %% ç”»è·Ÿè¸ªæ¡†
%         subplot(1,2,2)
    rect_position = [pos([2,1]) - (target_sz([2,1])/2), (target_sz([2,1]))]; %æ–°è·Ÿè¸ªæ¡†ä½ç½®y,x,height,width,
    if frame == 1  %first frame, create GUI
            figure
            im_handle = imagesc(uint8(img));%å°†çŸ©é˜µä¸­çš„å…ƒç´ æ•°å€¼æŒ‰å¤§å°è½¬åŒ–ä¸ºä¸åŒé¢œè‰²ï¼Œå¹¶åœ¨åæ ‡è½´å¯¹åº”ä½ç½®å¤„ä»¥è¿™ç§é¢œè‰²æŸ“è‰²ã€‚
=======
    F_im= fft2(getsubbox(pos,target_sz,im));%¶Ô¼ôÇÐ³öµÄÄ¿±êÍ¼Ïñ½øÐÐ¸µÀïÒ¶±ä»»,µ«¾­FFTºó£¬F_imÄÚÓÐÁË¸ºÖµ
%     F_im=templateGauss(target_sz,F_im);%ÕâÊÇÎÒ×Ô¼º¼ÓµÄÔÚÕâÀï¶Ô¸µÀïÒ¶±ä»»ºóµÄÍ¼Ïñ½øÐÐ¸ßË¹´¦Àí¡£Í¨¹ýÔËÐÐ¸÷¸öÊý¾Ý¼¯·¢ÏÖÒ»¸öÎÊÌâ£¬
                       %µ±Ô­´úÂëÔÚÔËÐÐÊ±£¬»áÊä³öÏà¹ØÐÔ´óµÄÎ»ÖÃ×÷ÎªÏìÓ¦×î´óÖµÊä³ö£¬µ«×¢ÒâÒ»µãÊÇ£¬Ïà¹ØÐÔ´óÓÐÊ±ºò»áÆ¯ÒÆ²»ÊÇÄ¿±êÖÐÐÄµã¡£
                       %ÓÉÓÚ²¢Î´¶ÔÐÂÒ»Ö¡Í¼Ïñ×öÈÎºÎ´¦Àí£¬µ±±³¾°Á¬ÐøÁ½Ö¡³öÏÖÔÚ¸ú×ÙÇøÓòÄÚ£¬ÄÇÔÚÏà¹ØÐÔÉÏÀ´Ëµ£¬ÕâÁ½Ö¡ÔÚ±³¾°ÇøÓòµÄÏà¹ØÐÔÖµÒ²»áºÜ¸ß£¬Èç¹ûÕâ¸ö
                       %Öµ³¬¹ýÄ¿±êÖÐÐÄµãµÄÖµ£¬ÄÇÃ´¾Í»áÔì³ÉÆ¯ÒÆ£¬ÕâÑù¾Í»áÔì³ÉÒÔ±³¾°ÎªÖ÷ÁË£¬ÂýÂýµÄ»á¶ªÊ§Ä¿±ê¡£»¹ÓÐÒ»ÖÖÇé¿öÊÇÈç¹û±³¾°ÖÐ³öÏÖÓëÄ¿±êÉÏÏñËØÖµ
                       %Ò»ÑùµÄ(ÈçRedTeamÊý¾Ý¼¯³µÉÏÃæÓÐ°×É«£¬¶ø¾­¹ý°×É«µçÏß¸ËÊ±¾Í»áÎóÈÏÎªµçÏß¸ËÎªÄ¿±ê)£¬ÈÏÎªµçÏß¸ËÕýºÃÒ²ÊÇ°×É«£¬µ±Óë¸ú×ÙÆ÷Ïà³ËÊ±£¬ÆäÏà¹ØÐÔÖµ
                       %Ò²»áºÜ´ó£¬¾Í»á±»ÎóÈÏÎªÄ¿±ê£¬ÕâËÆºõÊÇÄ¿±ê¸ú×ÙÖÐÁíÒ»¸öÎÊÌâ£¬¾ÍÊÇÄ¿±êÓë±³¾°ÑÕÉ«Ïà½üµÄÑÐ¾¿¡£
                       %µ«ÊÇ¼ÓÉÏ¸ßË¹´¦Àíºó£¬²úÉúµÄÐÂÎÊÌâÊÇ£¬Ä¿±ê²úÉúÐÎ±ä»òÐý×ªÊ±£¬ÓÉÓÚ»áÔì³ÉÄ¿±êÖÐÐÄÒÆ¶¯£¬Òò´Ë¸ú×ÙÐ§¹û»á²»ºÃ¡£
    F_Template=(conj(F_im.*conj(F_response))./(F_im.*conj(F_im)+eps));%Ïà¹ØÂË²¨Æ÷$H^*$¸üÐÂ
    %% »­¸ú×Ù¿ò
%         subplot(1,2,2)
    rect_position = [pos([2,1]) - (target_sz([2,1])/2), (target_sz([2,1]))]; %ÐÂ¸ú×Ù¿òÎ»ÖÃy,x,height,width,
    if frame == 1  %first frame, create GUI
            figure
            im_handle = imagesc(uint8(img));%½«¾ØÕóÖÐµÄÔªËØÊýÖµ°´´óÐ¡×ª»¯Îª²»Í¬ÑÕÉ«£¬²¢ÔÚ×ø±êÖá¶ÔÓ¦Î»ÖÃ´¦ÒÔÕâÖÖÑÕÉ«È¾É«¡£
>>>>>>> NOSSE
            rect_handle = rectangle('Position',rect_position,'LineWidth',2,'EdgeColor','r');
            tex_handle = text(5, 18, strcat('#',num2str(frame)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
            drawnow;
    else
        try  %subsequent frames, update GUI
<<<<<<< HEAD
			set(im_handle, 'CData', img)%CData æ˜¯MATLABé‡Œå­˜æ”¾å›¾åƒæ•°æ®çš„ä¸€ä¸ªçŸ©é˜µ ä½ å¯ä»¥ä½¿ç”¨getè¯­å¥åŽ»å¾—åˆ°ä»–çš„å¥æŸ„ï¼Œç„¶åŽåšç›¸åº”çš„å›¾åƒå¤„ç†ã€‚
=======
			set(im_handle, 'CData', img)%CData ÊÇMATLABÀï´æ·ÅÍ¼ÏñÊý¾ÝµÄÒ»¸ö¾ØÕó Äã¿ÉÒÔÊ¹ÓÃgetÓï¾äÈ¥µÃµ½ËûµÄ¾ä±ú£¬È»ºó×öÏàÓ¦µÄÍ¼Ïñ´¦Àí¡£
>>>>>>> NOSSE
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
