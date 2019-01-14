% This function creates a 2 dimentional window for a sample image, it takes
% the dimension of the window and applies the 1D window function
% This is does NOT using a rotational symmetric method to generate a 2 window
%
% Disi A ---- May,16, 2013
%     [N,M]=size(imgage);
% ---------------------------------------------------------------------
%     w_type is defined by the following 
%     @bartlett       - Bartlett window.
%     @barthannwin    - Modified Bartlett-Hanning window. 
%     @blackman       - Blackman window.
%     @blackmanharris - Minimum 4-term Blackman-Harris window.
%     @bohmanwin      - Bohman window.
%     @chebwin        - Chebyshev window.
%     @flattopwin     - Flat Top window.
%     @gausswin       - Gaussian window.
%     @hamming        - Hamming window.
%     @hann           - Hann window.
%     @kaiser         - Kaiser window.
%     @nuttallwin     - Nuttall defined minimum 4-term Blackman-Harris window.
%     @parzenwin      - Parzen (de la Valle-Poussin) window.
%     @rectwin        - Rectangular window.
%     @taylorwin      - Taylor window.
%     @tukeywin       - Tukey window.
%     @triang         - Triangular window.
%
%   Example: 
%   To compute windowed 2D fFT
%   [r,c]=size(img);
%   w=window2(r,c,@hamming);
% 	fft2(img.*w);
<<<<<<< HEAD
%åŠ çª—ä¸»è¦æ˜¯åœ¨æ—¶åŸŸå†…è¿›è¡Œ(åœ¨æ—¶åŸŸå†…æ˜¯ç›¸ä¹˜,åœ¨é¢‘åŸŸå†…æ˜¯å·ç§¯è¿ç®—),å…¶ä¸»è¦ä½œç”¨æ˜¯å‡å°ç”±äºŽä¿¡å·è£å‰ªå¸¦æ¥çš„é¢‘è°±æ³„éœ².
%é¢‘è°±æ³„éœ²ä½¿èƒ½é‡è¾ƒä½Žçš„è°±çº¿å¾ˆå®¹æ˜“è¢«ä¸´è¿‘çš„èƒ½é‡è¾ƒé«˜çš„è°±çº¿çš„æ³„éœ²ç»™æ·¹æ²¡ä½

function w=window2(N,M,w_func)

wr=window(w_func,N);%wrä¸ºä¸€ç»´åˆ—å‘é‡,ç»´åº¦ä¸ºheight x 1
wc=window(w_func,M);%wcä¸ºä¸€ç»´åˆ—å‘é‡,ç»´åº¦ä¸ºwidth x 1
=======
%¼Ó´°Ö÷ÒªÊÇÔÚÊ±ÓòÄÚ½øÐÐ(ÔÚÊ±ÓòÄÚÊÇÏà³Ë,ÔÚÆµÓòÄÚÊÇ¾í»ýÔËËã),ÆäÖ÷Òª×÷ÓÃÊÇ¼õÐ¡ÓÉÓÚÐÅºÅ²Ã¼ô´øÀ´µÄÆµÆ×Ð¹Â¶.
%ÆµÆ×Ð¹Â¶Ê¹ÄÜÁ¿½ÏµÍµÄÆ×ÏßºÜÈÝÒ×±»ÁÙ½üµÄÄÜÁ¿½Ï¸ßµÄÆ×ÏßµÄÐ¹Â¶¸øÑÍÃ»×¡

function w=window2(N,M,w_func)

wr=window(w_func,N);%wrÎªÒ»Î¬ÁÐÏòÁ¿,Î¬¶ÈÎªheight x 1
wc=window(w_func,M);%wcÎªÒ»Î¬ÁÐÏòÁ¿,Î¬¶ÈÎªwidth x 1
>>>>>>> NOSSE
% disp("wr")
% size(wr)
% disp("wc")
% size(wc)
<<<<<<< HEAD
[maskr,maskc]=meshgrid(wc,wr);%meshgridå‡½æ•°ç»˜åˆ¶äºŒç»´æˆ–ä¸‰ç»´ç½‘ç»œ.maskrä¸Žmaskcçš„ç»´åº¦ä¸€æ ·,å‡ä¸ºheight x width
%[X,Y]=meshgrid(x,y)åŸºäºŽå‘é‡xå’Œyä¸­åŒ…å«çš„åæ ‡è¿”å›žäºŒç»´ç½‘æ ¼åæ ‡ã€‚X æ˜¯ä¸€ä¸ªçŸ©é˜µ,æ¯ä¸€è¡Œæ˜¯xçš„ä¸€ä¸ªå‰¯æœ¬;Yä¹Ÿæ˜¯ä¸€ä¸ªçŸ©é˜µ,æ¯ä¸€åˆ—æ˜¯yçš„ä¸€ä¸ªå‰¯æœ¬.åæ ‡Xå’ŒYè¡¨ç¤ºçš„ç½‘æ ¼æœ‰length(y)ä¸ªè¡Œå’Œlength(x)ä¸ªåˆ—ã€‚
=======
[maskr,maskc]=meshgrid(wc,wr);%meshgridº¯Êý»æÖÆ¶þÎ¬»òÈýÎ¬ÍøÂç.maskrÓëmaskcµÄÎ¬¶ÈÒ»Ñù,¾ùÎªheight x width
%[X,Y]=meshgrid(x,y)»ùÓÚÏòÁ¿xºÍyÖÐ°üº¬µÄ×ø±ê·µ»Ø¶þÎ¬Íø¸ñ×ø±ê¡£X ÊÇÒ»¸ö¾ØÕó,Ã¿Ò»ÐÐÊÇxµÄÒ»¸ö¸±±¾;YÒ²ÊÇÒ»¸ö¾ØÕó,Ã¿Ò»ÁÐÊÇyµÄÒ»¸ö¸±±¾.×ø±êXºÍY±íÊ¾µÄÍø¸ñÓÐlength(y)¸öÐÐºÍlength(x)¸öÁÐ¡£
>>>>>>> NOSSE
%maskc=repmat(wc,1,M); Old version
%maskr=repmat(wr',N,1);

% disp("maskr")
% size(maskr)
% disp("maskc")
% size(maskc)

<<<<<<< HEAD
w=maskr.*maskc;%ç”Ÿæˆä¸Žcrop imageç›¸åŒç»´åº¦çš„çª— 
=======
w=maskr.*maskc;%Éú³ÉÓëcrop imageÏàÍ¬Î¬¶ÈµÄ´° 
>>>>>>> NOSSE
% disp("w")
% size(w)
end