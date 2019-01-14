<<<<<<< HEAD
%%%%%%%%%%%%%%%%%%%%äº§ç”Ÿé«˜æ–¯ç†æƒ³å“åº”%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function F_response=templateGauss(sz,im)
    [rs, cs] = ndgrid((1:sz(1)) - floor(sz(1)/2), (1:sz(2)) - floor(sz(2)/2));%ä¸­å¿ƒç‚¹çš„æ•°å€¼ä¸º(0 0)
    dist = rs.^2 + cs.^2;%æ‰€æœ‰æ•°å€¼éžè´Ÿ
    conf = exp(-0.5 / (2.25) * sqrt(dist));%ç”ŸæˆäºŒç»´é«˜æ–¯åˆ†å¸ƒ
    conf = conf/sum(sum(conf));% normalization
%ç”±å‰é¢ä»£ç å¯çŸ¥ï¼Œimå·²ç»è½¬æˆç°åº¦å›¾åƒï¼Œå› æ­¤è¿™é‡Œçš„è¿™ä¸ªåˆ¤æ–­æ²¡æ„ä¹‰
%     if(size(im,3)==1)%ç°åº¦å›¾åƒ 
=======
%%%%%%%%%%%%%%%%%%%%²úÉú¸ßË¹ÀíÏëÏìÓ¦%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function F_response=templateGauss(sz,im)
    [rs, cs] = ndgrid((1:sz(1)) - floor(sz(1)/2), (1:sz(2)) - floor(sz(2)/2));%ÖÐÐÄµãµÄÊýÖµÎª(0 0)
    dist = rs.^2 + cs.^2;%ËùÓÐÊýÖµ·Ç¸º
    conf = exp(-0.5 / (2.25) * sqrt(dist));%Éú³É¶þÎ¬¸ßË¹·Ö²¼
    conf = conf/sum(sum(conf));% normalization
%ÓÉÇ°Ãæ´úÂë¿ÉÖª£¬imÒÑ¾­×ª³É»Ò¶ÈÍ¼Ïñ£¬Òò´ËÕâÀïµÄÕâ¸öÅÐ¶ÏÃ»ÒâÒå
%     if(size(im,3)==1)%»Ò¶ÈÍ¼Ïñ 
>>>>>>> NOSSE
%         response=conf;
%     else
%         response(:,:,1)=conf;
%         response(:,:,2)=conf;
%         response(:,:,3)=conf;    
%     end       
% %         figure
% %         imshow(256.*response);
% %         mesh(response);
<<<<<<< HEAD
        F_response=fft2(conf);%å‚…é‡Œå¶å˜æ¢
=======
        F_response=fft2(conf);%¸µÀïÒ¶±ä»»
>>>>>>> NOSSE
end