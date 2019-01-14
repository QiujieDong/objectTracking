function target_box = getsubbox(pos,target_sz,im)
	%get and process the context region
<<<<<<< HEAD
	xs = floor(pos(2) + (1:target_sz(2)) - (target_sz(2)/2));%ä»¥posä¸ºä¸­å¿ƒï¼Œä»¥heightä¸widthä¸ºé«˜å®½ï¼Œç•Œå®šæ¡†çš„èŒƒå›´(åæ ‡å€¼)
=======
	xs = floor(pos(2) + (1:target_sz(2)) - (target_sz(2)/2));%ÒÔposÎªÖĞĞÄ£¬ÒÔheightÓëwidthÎª¸ß¿í£¬½ç¶¨¿òµÄ·¶Î§(×ø±êÖµ)
>>>>>>> NOSSE
	ys = floor(pos(1) + (1:target_sz(1)) - (target_sz(1)/2));
	
	%check for out-of-bounds coordinates, and set them to the values at
	%the borders
<<<<<<< HEAD
	xs(xs < 1) = 1;%é˜²æ­¢å‡ºå›¾åƒè¾¹ç•Œ(å›¾åƒä¸­æ²¡æœ‰å°äº0çš„ä½ç½®)
	ys(ys < 1) = 1;
	xs(xs > size(im,2)) = size(im,2);%é˜²æ­¢å‡ºå›¾åƒè¾¹ç•Œ
=======
	xs(xs < 1) = 1;%·ÀÖ¹³öÍ¼Ïñ±ß½ç(Í¼ÏñÖĞÃ»ÓĞĞ¡ÓÚ0µÄÎ»ÖÃ)
	ys(ys < 1) = 1;
	xs(xs > size(im,2)) = size(im,2);%·ÀÖ¹³öÍ¼Ïñ±ß½ç
>>>>>>> NOSSE
	ys(ys > size(im,1)) = size(im,1);	
	%extract image in context region
	target_box = im(ys, xs, :);	
	%pre-process window
    target_box = double(target_box);
<<<<<<< HEAD
    target_box = (target_box-mean(target_box(:)));%æˆªå–çš„å›¾åƒï¼Œè¿™æ ·åŒæ—¶å‡å»ä¸€ä¸ªæ•°ä¸ä¼šæ”¹å˜å¤§å°å…³ç³»ï¼Œä½†å‡å°è¿ç®—æ•°å€¼ï¼Œæ–¹ä¾¿è®¡ç®—
=======
    target_box = (target_box-mean(target_box(:)));%½ØÈ¡µÄÍ¼Ïñ£¬ÕâÑùÍ¬Ê±¼õÈ¥Ò»¸öÊı²»»á¸Ä±ä´óĞ¡¹ØÏµ£¬µ«¼õĞ¡ÔËËãÊıÖµ£¬·½±ã¼ÆËã
>>>>>>> NOSSE

end