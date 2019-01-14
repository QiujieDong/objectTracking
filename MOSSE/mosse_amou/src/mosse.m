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
    img_files = num2str((1:seq_len)', [img_path '%04i.jpg']);%numstr±È½ÏÌØÊâ£¬»á'\×ÖÄ¸'ÈÏÎªÌØÊâ×Ö·û£¬ËùÒÔÒªÊäÈë'\\×ÖÄ¸'£¬Õâ¾ÍÊÇÎªÊ²Ã´datadirÎª'\\'
>>>>>>> NOSSE
else
    error('No image files found in the directory.');
end

% select target from first frame
im = imread(img_files(1,:));
<<<<<<< HEAD
f = figure('Name', 'Select object to track'); %figureçš„nameå¯¹è±¡ä¸º'Select object to track'
imshow(im);
rect = getrect; %getrectä½¿ç”¨é¼ æ ‡åœ¨å½“å‰è½´ä¸­é€‰æ‹©ä¸€ä¸ªçŸ©å½¢,rectè¿”å›žçš„æ˜¯çŸ©å½¢å·¦ä¸Šè§’åæ ‡,çŸ©å½¢æ¡†çš„å®½åº¦å’Œé«˜åº¦(x,y,width,height)
                %è‹¥å°†çŸ©å½¢çº¦æŸä¸ºæ–¹å½¢,ä½¿ç”¨shiftæˆ–å³é”®å•å‡»å¼€å§‹æ‹–åŠ¨.
close(f); clear f; %åœ¨ç¬¬ä¸€å¸§ä¸Šç”»å‡ºçŸ©å½¢åŽ,å–å¾—çŸ©å½¢æ¡†ä¿¡æ¯,ç„¶åŽå…³é—­ç¬¬ä¸€å¸§å›¾åƒ
center = [rect(1)+rect(3)/2 rect(2)+rect(4)/2];%è®¡ç®—èŽ·å¾—çŸ©å½¢ç‚¹ä¸­å¿ƒåœ¨æ•´ä¸ªå›¾åƒä¸Šçš„width,height
=======
f = figure('Name', 'Select object to track'); %figureµÄname¶ÔÏóÎª'Select object to track'
imshow(im);
rect = getrect; %getrectÊ¹ÓÃÊó±êÔÚµ±Ç°ÖáÖÐÑ¡ÔñÒ»¸ö¾ØÐÎ,rect·µ»ØµÄÊÇ¾ØÐÎ×óÉÏ½Ç×ø±ê,¾ØÐÎ¿òµÄ¿í¶ÈºÍ¸ß¶È(x,y,width,height)
                %Èô½«¾ØÐÎÔ¼ÊøÎª·½ÐÎ,Ê¹ÓÃshift»òÓÒ¼üµ¥»÷¿ªÊ¼ÍÏ¶¯.
close(f); clear f; %ÔÚµÚÒ»Ö¡ÉÏ»­³ö¾ØÐÎºó,È¡µÃ¾ØÐÎ¿òÐÅÏ¢,È»ºó¹Ø±ÕµÚÒ»Ö¡Í¼Ïñ
center = [rect(1)+rect(3)/2 rect(2)+rect(4)/2];%¼ÆËã»ñµÃ¾ØÐÎµãÖÐÐÄÔÚÕû¸öÍ¼ÏñÉÏµÄwidth,height
>>>>>>> NOSSE

% plot gaussian
sigma = 10;
a = 10;
<<<<<<< HEAD
gsize = size(im);%èŽ·å¾—imageåƒç´ çš„(row*column*channel)
[R,C] = ndgrid(1:gsize(1), 1:gsize(2));%Rä¸ŽCå‡ä¸ºgsize(1)è¡Œ,gsize(2)åˆ—,å…¶ä¸­Rä¸ºä»¥1ä¸ºæ­¥é•¿,ä»Ž1åˆ°gsize(1)è¿›è¡Œåˆ—æŽ’åˆ—,Cä¸ºä»Ž1åˆ°gsize(2)è¿›è¡Œè¡ŒæŽ’åˆ—
g = gaussC(C,R, sigma, a, center);
g = mat2gray(g);%å°†å›¾åƒçŸ©é˜µgå½’ä¸€åŒ–ä¸ºå›¾åƒçŸ©é˜µgï¼Œå½’ä¸€åŒ–åŽçŸ©é˜µä¸­æ¯ä¸ªå…ƒç´ çš„å€¼éƒ½åœ¨0åˆ°1èŒƒå›´å†…ï¼ˆåŒ…æ‹¬0å’Œ1),å…¶ä¸­0è¡¨ç¤ºé»‘è‰²,255è¡¨ç¤ºç™½è‰².

% randomly warp original image to create training set
if (size(im,3) == 3) %image channel
    img = rgb2gray(im); %å°†å›¾ç‰‡ç”±rgbå˜ä¸ºgray
end
img = imcrop(img, rect);%cropåŽŸå§‹å›¾åƒ,imcropå›¾åƒå‰ªè£å‘½ä»¤,RECTä¸ºå¯é€‰å‚æ•°ï¼Œæ ¼å¼ä¸º[XMIN YMIN WIGTH HEIGHT].
g = imcrop(g, rect);%crop gauss image
G = fft2(g);%äºŒç»´å¿«é€Ÿå‚…é‡Œå¶å˜æ¢,å°†æ—¶åŸŸé—®é¢˜è½¬ä¸ºé¢‘åŸŸé—®é¢˜,å¾—åˆ°æ•°å­—ä¿¡å·çš„åˆ†æžé¢‘è°±.
            %ä¸€ç»´ä¿¡å·(å¦‚è¯­éŸ³ä¿¡å·)ç”¨fft,äºŒç»´ä¿¡å·(å¦‚å›¾åƒä¿¡å·)ç”¨fft2
            %å‚…é‡Œå¶å˜æ¢çš„åŸºæœ¬æ€æƒ³æ˜¯:ä»»ä½•è¿žç»­æµ‹é‡çš„æ—¶åºæˆ–ä¿¡å·ï¼Œéƒ½å¯ä»¥è¡¨ç¤ºä¸ºä¸åŒé¢‘çŽ‡çš„æ­£å¼¦æ³¢ä¿¡å·çš„æ— é™å åŠ (å¸¦æ£±è§’çš„ä¿¡å·å¯ä»¥è¢«æ— é™æŽ¥è¿‘).
height = size(g,1);%å–å‡ºå‰ªåˆ‡å›¾åƒgçš„height
width = size(g,2);%å–å‡ºå‰ªåˆ‡å›¾åƒgçš„width
fi = preprocess(imresize(img, [height width]));%imresizeç¼©æ”¾å›¾åƒå‡½æ•°ã€‚imresize(A, [numrows numcols]),numrowså’Œnumcolsåˆ†åˆ«æŒ‡å®šç›®æ ‡å›¾åƒçš„é«˜åº¦å’Œå®½åº¦ã€‚
                                               %imresize ä½¿ç”¨åŒä¸‰æ¬¡æ–¹æ’å€¼æ–¹æ³•å®žçŽ°çš„å›¾ç‰‡ç¼©æ”¾ã€‚
                                               %æ˜¾è€Œæ˜“è§,ç”±äºŽè¿™ç§æ ¼å¼å…è®¸å›¾åƒç¼©æ”¾åŽé•¿å®½æ¯”ä¾‹å’Œæºå›¾åƒé•¿å®½æ¯”ä¾‹ä¸ç›¸åŒ,å› æ­¤æ‰€äº§ç”Ÿçš„å›¾åƒæœ‰å¯èƒ½å‘ç”Ÿç•¸å˜ã€‚
Ai = (G.*conj(fft2(fi)));%conjå‡½æ•°ï¼šç”¨äºŽè®¡ç®—å¤æ•°çš„å…±è½­å€¼
Bi = (fft2(fi).*conj(fft2(fi)));
% N = 128;
% %è¿›è¡Œè¿™ä¸ªforå¾ªçŽ¯çš„æ„æ€åº”è¯¥æ˜¯é€šè¿‡å åŠ ,å¢žåŠ ç³»ç»Ÿé²æ£’æ€§,ä½†æ˜¯åªåœ¨ç¬¬ä¸€å¸§å¢žåŠ ,åŽç»­è¿è¡Œä¼šå…ˆå‰æ•°æ®è¿›è¡Œå‰Šå¼±,å› æ­¤è¿™é‡ŒåŠ ä¸Šæ„ä¹‰ä¸å¤§.ä¸‹é¢æˆ‘å°†æ¯ä¸€å¸§éƒ½åŠ ä¸Šè¿™ç§æ“ä½œ,
  % æ—¶é—´ä¸Šå˜å¾—éžå¸¸æ…¢,è€Œä¸”ç”±äºŽrand_warpå‡½æ•°åªå¤„ç†æ—‹è½¬å˜å½¢,å¯¹äºŽå…¶ä»–å˜å½¢å¹¶æœªè¿›è¡Œå¤„ç†,å› æ­¤åœ¨Surferæ•°æ®é›†ä¸­å½“å†²æµªè€…èœ·æ›²èº«å­ä¼¸ç›´æ—¶,å®¹æ˜“å‡ºçŽ°è·Ÿè¸ªå¤±è´¥.
=======
gsize = size(im);%»ñµÃimageÏñËØµÄ(row*column*channel)
[R,C] = ndgrid(1:gsize(1), 1:gsize(2));%RÓëC¾ùÎªgsize(1)ÐÐ,gsize(2)ÁÐ,ÆäÖÐRÎªÒÔ1Îª²½³¤,´Ó1µ½gsize(1)½øÐÐÁÐÅÅÁÐ,CÎª´Ó1µ½gsize(2)½øÐÐÐÐÅÅÁÐ
g = gaussC(C,R, sigma, a, center);
g = mat2gray(g);%½«Í¼Ïñ¾ØÕóg¹éÒ»»¯ÎªÍ¼Ïñ¾ØÕóg£¬¹éÒ»»¯ºó¾ØÕóÖÐÃ¿¸öÔªËØµÄÖµ¶¼ÔÚ0µ½1·¶Î§ÄÚ£¨°üÀ¨0ºÍ1),ÆäÖÐ0±íÊ¾ºÚÉ«,255±íÊ¾°×É«.

% randomly warp original image to create training set
if (size(im,3) == 3) %image channel
    img = rgb2gray(im); %½«Í¼Æ¬ÓÉrgb±äÎªgray
end
img = imcrop(img, rect);%cropÔ­Ê¼Í¼Ïñ,imcropÍ¼Ïñ¼ô²ÃÃüÁî,RECTÎª¿ÉÑ¡²ÎÊý£¬¸ñÊ½Îª[XMIN YMIN WIGTH HEIGHT].
g = imcrop(g, rect);%crop gauss image
G = fft2(g);%¶þÎ¬¿ìËÙ¸µÀïÒ¶±ä»»,½«Ê±ÓòÎÊÌâ×ªÎªÆµÓòÎÊÌâ,µÃµ½Êý×ÖÐÅºÅµÄ·ÖÎöÆµÆ×.
            %Ò»Î¬ÐÅºÅ(ÈçÓïÒôÐÅºÅ)ÓÃfft,¶þÎ¬ÐÅºÅ(ÈçÍ¼ÏñÐÅºÅ)ÓÃfft2
            %¸µÀïÒ¶±ä»»µÄ»ù±¾Ë¼ÏëÊÇ:ÈÎºÎÁ¬Ðø²âÁ¿µÄÊ±Ðò»òÐÅºÅ£¬¶¼¿ÉÒÔ±íÊ¾Îª²»Í¬ÆµÂÊµÄÕýÏÒ²¨ÐÅºÅµÄÎÞÏÞµþ¼Ó(´øÀâ½ÇµÄÐÅºÅ¿ÉÒÔ±»ÎÞÏÞ½Ó½ü).
height = size(g,1);%È¡³ö¼ôÇÐÍ¼ÏñgµÄheight
width = size(g,2);%È¡³ö¼ôÇÐÍ¼ÏñgµÄwidth
fi = preprocess(imresize(img, [height width]));%imresizeËõ·ÅÍ¼Ïñº¯Êý¡£imresize(A, [numrows numcols]),numrowsºÍnumcols·Ö±ðÖ¸¶¨Ä¿±êÍ¼ÏñµÄ¸ß¶ÈºÍ¿í¶È¡£
                                               %imresize Ê¹ÓÃË«Èý´Î·½²åÖµ·½·¨ÊµÏÖµÄÍ¼Æ¬Ëõ·Å¡£
                                               %ÏÔ¶øÒ×¼û,ÓÉÓÚÕâÖÖ¸ñÊ½ÔÊÐíÍ¼ÏñËõ·Åºó³¤¿í±ÈÀýºÍÔ´Í¼Ïñ³¤¿í±ÈÀý²»ÏàÍ¬,Òò´ËËù²úÉúµÄÍ¼ÏñÓÐ¿ÉÄÜ·¢Éú»û±ä¡£
Ai = (G.*conj(fft2(fi)));%conjº¯Êý£ºÓÃÓÚ¼ÆËã¸´ÊýµÄ¹²éîÖµ
Bi = (fft2(fi).*conj(fft2(fi)));
% N = 128;
% %½øÐÐÕâ¸öforÑ­»·µÄÒâË¼Ó¦¸ÃÊÇÍ¨¹ýµþ¼Ó,Ôö¼ÓÏµÍ³Â³°ôÐÔ,µ«ÊÇÖ»ÔÚµÚÒ»Ö¡Ôö¼Ó,ºóÐøÔËÐÐ»áÏÈÇ°Êý¾Ý½øÐÐÏ÷Èõ,Òò´ËÕâÀï¼ÓÉÏÒâÒå²»´ó.ÏÂÃæÎÒ½«Ã¿Ò»Ö¡¶¼¼ÓÉÏÕâÖÖ²Ù×÷,
  % Ê±¼äÉÏ±äµÃ·Ç³£Âý,¶øÇÒÓÉÓÚrand_warpº¯ÊýÖ»´¦ÀíÐý×ª±äÐÎ,¶ÔÓÚÆäËû±äÐÎ²¢Î´½øÐÐ´¦Àí,Òò´ËÔÚSurferÊý¾Ý¼¯ÖÐµ±³åÀËÕßòéÇúÉí×ÓÉìÖ±Ê±,ÈÝÒ×³öÏÖ¸ú×ÙÊ§°Ü.
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
fig = figure('Name', 'MOSSE');%ç”»å›¾æ¡†nameä¸ºMOSSE
% mkdir(['results_' dataset]);%åˆ›å»ºæ–‡ä»¶å¤¹ç”¨æ¥ä¿å­˜ç”Ÿæˆçš„å¸¦è·Ÿè¸ªæ¡†çš„å›¾åƒ
time = clock;
for i = 1:size(img_files, 1) %ä¾æ¬¡å–å‡ºæ‰€æœ‰å›¾ç‰‡
    img = imread(img_files(i,:));
    im = img;
    if (size(img,3) == 3) %å˜ä¸ºç°åº¦å›¾åƒ
=======
fig = figure('Name', 'MOSSE');%»­Í¼¿ònameÎªMOSSE
% mkdir(['results_' dataset]);%´´½¨ÎÄ¼þ¼ÐÓÃÀ´±£´æÉú³ÉµÄ´ø¸ú×Ù¿òµÄÍ¼Ïñ
time = clock;
for i = 1:size(img_files, 1) %ÒÀ´ÎÈ¡³öËùÓÐÍ¼Æ¬
    img = imread(img_files(i,:));
    im = img;
    if (size(img,3) == 3) %±äÎª»Ò¶ÈÍ¼Ïñ
>>>>>>> NOSSE
        img = rgb2gray(img);
    end
    if (i == 1)
        Ai = eta.*Ai;
        Bi = eta.*Bi;
    else
        try
<<<<<<< HEAD
            Hi = Ai ./ Bi;%å¯¹åº”ç›¸é™¤
            fi = imcrop(img, rect); 
            fi = preprocess(imresize(fi, [height width]));%è¿™é‡Œæˆªå›¾ä¹‹åŽç›´æŽ¥å¯¹æ–°å¸§çš„å›¾åƒè¿›è¡ŒåŠ çª—ï¼Œè™½è¯´è§£å†³äº†é¢‘è°±æ³„éœ²é—®é¢˜ï¼Œä½†æ˜¯ä¹Ÿå°†æ–°å¸§å…³äºŽä¸Šä¸€å¸§çš„ä¸­å¿ƒä½ç½®
                                                          %çªå‡ºäº†ï¼Œä½†å¯èƒ½è¿™å¹¶ä¸æ˜¯å½“å‰å¸§çš„ä¸­å¿ƒä½ç½®ï¼Œå› æ­¤ä¼šå‡ºçŽ°æ¼‚ç§»ã€‚
            gi = uint8(255*mat2gray(real(ifft2(Hi.*fft2(fi)))));%mat2grayå°†çŸ©é˜µå½’ä¸€åŒ–.realå–å¤æ•°å®žéƒ¨,imagå–å¤æ•°è™šéƒ¨.ifft2å¿«é€Ÿå‚…é‡Œå¶åå˜æ¢
                                                                %è¿™é‡Œå½’ä¸€åŒ–ç„¶åŽä¹˜ä»¥255å†è½¬æ¢æˆ8ä½æ“ä½œ,æ˜¯å› ä¸º8ä½å›¾åƒæ•°å€¼ä¸º0-255.
            maxval = max(gi(:)); %å–å¾—giçŸ©é˜µä¸­æœ€å¤§å€¼
            [P, Q] = find(gi == maxval);%å–å¾—giçŸ©é˜µä¸­æœ€å¤§å€¼æ‰€åœ¨çš„ä½ç½®,P=row,Q=column
            dx = mean(Q)-width/2;%å¾—åˆ°ç¬¬Nå¸§å›¾åƒä¸Žç¬¬N-1å¸§å›¾åƒå¯¹æ¯”å¢žåŠ çš„dxä¸Ždy
            dy = mean(P)-height/2;

            rect = [rect(1)+dx rect(2)+dy width height];%è°ƒæ•´çŸ©å½¢æ¡†ä½ç½®,ä»¥å¾—åˆ°çš„æ–°çš„æœ€å¤§å€¼ä½ç½®ä½œä¸ºçŸ©å½¢æ¡†ä¸­å¿ƒ,
            fi = imcrop(img, rect); %é‡æ–°æˆªå›¾
            fi = preprocess(imresize(fi, [height width]));%å¯¹æ–°æˆªå›¾åŠ çª—
=======
            Hi = Ai ./ Bi;%¶ÔÓ¦Ïà³ý
            fi = imcrop(img, rect); 
            fi = preprocess(imresize(fi, [height width]));%ÕâÀï½ØÍ¼Ö®ºóÖ±½Ó¶ÔÐÂÖ¡µÄÍ¼Ïñ½øÐÐ¼Ó´°£¬ËäËµ½â¾öÁËÆµÆ×Ð¹Â¶ÎÊÌâ£¬µ«ÊÇÒ²½«ÐÂÖ¡¹ØÓÚÉÏÒ»Ö¡µÄÖÐÐÄÎ»ÖÃ
                                                          %Í»³öÁË£¬µ«¿ÉÄÜÕâ²¢²»ÊÇµ±Ç°Ö¡µÄÖÐÐÄÎ»ÖÃ£¬Òò´Ë»á³öÏÖÆ¯ÒÆ¡£
            gi = uint8(255*mat2gray(real(ifft2(Hi.*fft2(fi)))));%mat2gray½«¾ØÕó¹éÒ»»¯.realÈ¡¸´ÊýÊµ²¿,imagÈ¡¸´ÊýÐé²¿.ifft2¿ìËÙ¸µÀïÒ¶·´±ä»»
                                                                %ÕâÀï¹éÒ»»¯È»ºó³ËÒÔ255ÔÙ×ª»»³É8Î»²Ù×÷,ÊÇÒòÎª8Î»Í¼ÏñÊýÖµÎª0-255.
            maxval = max(gi(:)); %È¡µÃgi¾ØÕóÖÐ×î´óÖµ
            [P, Q] = find(gi == maxval);%È¡µÃgi¾ØÕóÖÐ×î´óÖµËùÔÚµÄÎ»ÖÃ,P=row,Q=column
            dx = mean(Q)-width/2;%µÃµ½µÚNÖ¡Í¼ÏñÓëµÚN-1Ö¡Í¼Ïñ¶Ô±ÈÔö¼ÓµÄdxÓëdy
            dy = mean(P)-height/2;

            rect = [rect(1)+dx rect(2)+dy width height];%µ÷Õû¾ØÐÎ¿òÎ»ÖÃ,ÒÔµÃµ½µÄÐÂµÄ×î´óÖµÎ»ÖÃ×÷Îª¾ØÐÎ¿òÖÐÐÄ,
            fi = imcrop(img, rect); %ÖØÐÂ½ØÍ¼
            fi = preprocess(imresize(fi, [height width]));%¶ÔÐÂ½ØÍ¼¼Ó´°
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
            Ai = eta.*(G.*conj(fft2(fi))) + (1-eta).*Ai;%æŒ‰è®ºæ–‡æ›´æ–°Aiä¸ŽBi
=======
            Ai = eta.*(G.*conj(fft2(fi))) + (1-eta).*Ai;%°´ÂÛÎÄ¸üÐÂAiÓëBi
>>>>>>> NOSSE
            Bi = eta.*(fft2(fi).*conj(fft2(fi))) + (1-eta).*Bi;
        catch
            return
        end
    end
    
    % visualization
<<<<<<< HEAD
    text_str = ['Frame: ' num2str(i)];%åœ¨æ˜¾ç¤ºçš„å›¾ä¸­éœ€è¦æ˜¾ç¤ºçš„æ–‡å­—å†…å®¹
    box_color = 'green';%æ˜¾ç¤ºæ–‡å­—çš„èƒŒæ™¯æ¡†é¢œè‰²
    position=[1 1];%æ˜¾ç¤ºæ–‡å­—èƒŒæ™¯æ¡†å·¦ä¸Šè§’åæ ‡,å…¶å¤§å°è·Ÿéšæ˜¾ç¤ºçš„å†…å®¹æ”¹å˜
    result = insertText(im, position,text_str,'FontSize',15,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');
    %insertText:insert tex in image or video,return the processed image or video-BoxOpacity:æ–‡æœ¬æ¡†ä¸é€æ˜Žåº¦
    %insertShape:Insert shapes in image or video
    result = insertShape(result, 'Rectangle', rect, 'LineWidth', 3);
%     imwrite(result, ['results_' dataset num2str(i, '/%04i.jpg')]);%ä¿å­˜å›¾åƒ
=======
    text_str = ['Frame: ' num2str(i)];%ÔÚÏÔÊ¾µÄÍ¼ÖÐÐèÒªÏÔÊ¾µÄÎÄ×ÖÄÚÈÝ
    box_color = 'green';%ÏÔÊ¾ÎÄ×ÖµÄ±³¾°¿òÑÕÉ«
    position=[1 1];%ÏÔÊ¾ÎÄ×Ö±³¾°¿ò×óÉÏ½Ç×ø±ê,Æä´óÐ¡¸úËæÏÔÊ¾µÄÄÚÈÝ¸Ä±ä
    result = insertText(im, position,text_str,'FontSize',15,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');
    %insertText:insert tex in image or video,return the processed image or video-BoxOpacity:ÎÄ±¾¿ò²»Í¸Ã÷¶È
    %insertShape:Insert shapes in image or video
    result = insertShape(result, 'Rectangle', rect, 'LineWidth', 3);
%     imwrite(result, ['results_' dataset num2str(i, '/%04i.jpg')]);%±£´æÍ¼Ïñ
>>>>>>> NOSSE
    imshow(result);
end
disp(['Frames-per-second: ' num2str(seq_len / etime(clock,time))])
