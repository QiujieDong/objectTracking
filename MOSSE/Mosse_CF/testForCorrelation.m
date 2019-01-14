<<<<<<< HEAD
%ç›¸å…³æ»¤æ³¢æ•ˆæžœæµ‹è¯•

close all;clear all;clc;
%è½½å…¥å›¾ç‰‡æ–‡ä»¶
imgDir='../mosse_amou/data/Surfer';%å›¾ç‰‡æ–‡ä»¶å¤¹è·¯å¾„å
[guroundtruth,img_path,img_files]=Load_image(imgDir);%è°ƒç”¨å‡½æ•°è¯»å–å›¾ç‰‡å¸§
% for frame=1:1%length(img_files)-1
    im1 = imread([img_path img_files{5}]);%è¯»å–ç›®æ ‡å¸§
    im1 = rgb2gray(im1);%è½¬æ¢ä¸ºç°åº¦å›¾
    im2 = imread([img_path img_files{6}]);%è¯»å–ç›®æ ‡å¸§
    im2 = rgb2gray(im2);%è½¬æ¢ä¸ºç°åº¦å›¾
    d_im1=double(im1);d_im2=double(im2);
    res=imfilter(d_im1, d_im2, 'corr');  %å¯¹ä»»æ„ç±»åž‹æ•°ç»„æˆ–å¤šç»´å›¾åƒè¿›è¡Œæ»¤æ³¢ ,corrä½¿ç”¨ç›¸å…³æ»¤æ³¢ï¼Œconvä½¿ç”¨å·ç§¯æ»¤æ³¢
=======
%Ïà¹ØÂË²¨Ð§¹û²âÊÔ

close all;clear all;clc;
%ÔØÈëÍ¼Æ¬ÎÄ¼þ
imgDir='../mosse_amou/data/Surfer';%Í¼Æ¬ÎÄ¼þ¼ÐÂ·¾¶Ãû
[guroundtruth,img_path,img_files]=Load_image(imgDir);%µ÷ÓÃº¯Êý¶ÁÈ¡Í¼Æ¬Ö¡
% for frame=1:1%length(img_files)-1
    im1 = imread([img_path img_files{5}]);%¶ÁÈ¡Ä¿±êÖ¡
    im1 = rgb2gray(im1);%×ª»»Îª»Ò¶ÈÍ¼
    im2 = imread([img_path img_files{6}]);%¶ÁÈ¡Ä¿±êÖ¡
    im2 = rgb2gray(im2);%×ª»»Îª»Ò¶ÈÍ¼
    d_im1=double(im1);d_im2=double(im2);
    res=imfilter(d_im1, d_im2, 'corr');  %¶ÔÈÎÒâÀàÐÍÊý×é»ò¶àÎ¬Í¼Ïñ½øÐÐÂË²¨ ,corrÊ¹ÓÃÏà¹ØÂË²¨£¬convÊ¹ÓÃ¾í»ýÂË²¨
>>>>>>> NOSSE
    % res=fftshift(res); 
    max1=max(res); 
    max2=max(max1); 
    scale=1.0/max2; 
<<<<<<< HEAD
    res=res.*scale; %å½’ä¸€åŒ–å¤„ç†
%     res=255.*uint8(res);
    %ç”»å›¾
=======
    res=res.*scale; %¹éÒ»»¯´¦Àí
%     res=255.*uint8(res);
    %»­Í¼
>>>>>>> NOSSE
    subplot(1,3,1)
    imshow(im1);title('imag1');
    subplot(1,3,2)
    imshow(im2);title('imag2');
    subplot(1,3,3)
    imshow(res);title('filter');
%     drawnow
% end
[maxrow,maxcol]=find(res==max(max(res)));
