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
    img_files = num2str((1:seq_len)', [img_path '%04i.jpg']);%numstr比较特殊，会'\字母'认为特殊字符，所以要输入'\\字母'，这就是为什么datadir为'\\'
>>>>>>> NOSSE
else
    error('No image files found in the directory.');
end

% select target from first frame
im = imread(img_files(1,:));
<<<<<<< HEAD
f = figure('Name', 'Select object to track'); %figure鐨刵ame瀵硅薄涓�'Select object to track'
imshow(im);
rect = getrect; %getrect浣跨敤榧犳爣鍦ㄥ綋鍓嶈酱涓�夋嫨涓�涓煩褰�,rect杩斿洖鐨勬槸鐭╁舰宸︿笂瑙掑潗鏍�,鐭╁舰妗嗙殑瀹藉害鍜岄珮搴�(x,y,width,height)
                %鑻ュ皢鐭╁舰绾︽潫涓烘柟褰�,浣跨敤shift鎴栧彸閿崟鍑诲紑濮嬫嫋鍔�.
close(f); clear f; %鍦ㄧ涓�甯т笂鐢诲嚭鐭╁舰鍚�,鍙栧緱鐭╁舰妗嗕俊鎭�,鐒跺悗鍏抽棴绗竴甯у浘鍍�
center = [rect(1)+rect(3)/2 rect(2)+rect(4)/2];%璁＄畻鑾峰緱鐭╁舰鐐逛腑蹇冨湪鏁翠釜鍥惧儚涓婄殑width,height
=======
f = figure('Name', 'Select object to track'); %figure的name对象为'Select object to track'
imshow(im);
rect = getrect; %getrect使用鼠标在当前轴中选择一个矩形,rect返回的是矩形左上角坐标,矩形框的宽度和高度(x,y,width,height)
                %若将矩形约束为方形,使用shift或右键单击开始拖动.
close(f); clear f; %在第一帧上画出矩形后,取得矩形框信息,然后关闭第一帧图像
center = [rect(1)+rect(3)/2 rect(2)+rect(4)/2];%计算获得矩形点中心在整个图像上的width,height
>>>>>>> NOSSE

% plot gaussian
sigma = 10;
a = 10;
<<<<<<< HEAD
gsize = size(im);%鑾峰緱image鍍忕礌鐨�(row*column*channel)
[R,C] = ndgrid(1:gsize(1), 1:gsize(2));%R涓嶤鍧囦负gsize(1)琛�,gsize(2)鍒�,鍏朵腑R涓轰互1涓烘闀�,浠�1鍒癵size(1)杩涜鍒楁帓鍒�,C涓轰粠1鍒癵size(2)杩涜琛屾帓鍒�
g = gaussC(C,R, sigma, a, center);
g = mat2gray(g);%灏嗗浘鍍忕煩闃礸褰掍竴鍖栦负鍥惧儚鐭╅樀g锛屽綊涓�鍖栧悗鐭╅樀涓瘡涓厓绱犵殑鍊奸兘鍦�0鍒�1鑼冨洿鍐咃紙鍖呮嫭0鍜�1),鍏朵腑0琛ㄧず榛戣壊,255琛ㄧず鐧借壊.

% randomly warp original image to create training set
if (size(im,3) == 3) %image channel
    img = rgb2gray(im); %灏嗗浘鐗囩敱rgb鍙樹负gray
end
img = imcrop(img, rect);%crop鍘熷鍥惧儚,imcrop鍥惧儚鍓鍛戒护,RECT涓哄彲閫夊弬鏁帮紝鏍煎紡涓篬XMIN YMIN WIGTH HEIGHT].
g = imcrop(g, rect);%crop gauss image
G = fft2(g);%浜岀淮蹇�熷倕閲屽彾鍙樻崲,灏嗘椂鍩熼棶棰樿浆涓洪鍩熼棶棰�,寰楀埌鏁板瓧淇″彿鐨勫垎鏋愰璋�.
            %涓�缁翠俊鍙�(濡傝闊充俊鍙�)鐢╢ft,浜岀淮淇″彿(濡傚浘鍍忎俊鍙�)鐢╢ft2
            %鍌呴噷鍙跺彉鎹㈢殑鍩烘湰鎬濇兂鏄�:浠讳綍杩炵画娴嬮噺鐨勬椂搴忔垨淇″彿锛岄兘鍙互琛ㄧず涓轰笉鍚岄鐜囩殑姝ｅ鸡娉俊鍙风殑鏃犻檺鍙犲姞(甯︽１瑙掔殑淇″彿鍙互琚棤闄愭帴杩�).
height = size(g,1);%鍙栧嚭鍓垏鍥惧儚g鐨刪eight
width = size(g,2);%鍙栧嚭鍓垏鍥惧儚g鐨剋idth
fi = preprocess(imresize(img, [height width]));%imresize缂╂斁鍥惧儚鍑芥暟銆俰mresize(A, [numrows numcols]),numrows鍜宯umcols鍒嗗埆鎸囧畾鐩爣鍥惧儚鐨勯珮搴﹀拰瀹藉害銆�
                                               %imresize 浣跨敤鍙屼笁娆℃柟鎻掑�兼柟娉曞疄鐜扮殑鍥剧墖缂╂斁銆�
                                               %鏄捐�屾槗瑙�,鐢变簬杩欑鏍煎紡鍏佽鍥惧儚缂╂斁鍚庨暱瀹芥瘮渚嬪拰婧愬浘鍍忛暱瀹芥瘮渚嬩笉鐩稿悓,鍥犳鎵�浜х敓鐨勫浘鍍忔湁鍙兘鍙戠敓鐣稿彉銆�
Ai = (G.*conj(fft2(fi)));%conj鍑芥暟锛氱敤浜庤绠楀鏁扮殑鍏辫江鍊�
Bi = (fft2(fi).*conj(fft2(fi)));
% N = 128;
% %杩涜杩欎釜for寰幆鐨勬剰鎬濆簲璇ユ槸閫氳繃鍙犲姞,澧炲姞绯荤粺椴佹鎬�,浣嗘槸鍙湪绗竴甯у鍔�,鍚庣画杩愯浼氬厛鍓嶆暟鎹繘琛屽墛寮�,鍥犳杩欓噷鍔犱笂鎰忎箟涓嶅ぇ.涓嬮潰鎴戝皢姣忎竴甯ч兘鍔犱笂杩欑鎿嶄綔,
  % 鏃堕棿涓婂彉寰楅潪甯告參,鑰屼笖鐢变簬rand_warp鍑芥暟鍙鐞嗘棆杞彉褰�,瀵逛簬鍏朵粬鍙樺舰骞舵湭杩涜澶勭悊,鍥犳鍦⊿urfer鏁版嵁闆嗕腑褰撳啿娴�呰湻鏇茶韩瀛愪几鐩存椂,瀹规槗鍑虹幇璺熻釜澶辫触.
=======
gsize = size(im);%获得image像素的(row*column*channel)
[R,C] = ndgrid(1:gsize(1), 1:gsize(2));%R与C均为gsize(1)行,gsize(2)列,其中R为以1为步长,从1到gsize(1)进行列排列,C为从1到gsize(2)进行行排列
g = gaussC(C,R, sigma, a, center);
g = mat2gray(g);%将图像矩阵g归一化为图像矩阵g，归一化后矩阵中每个元素的值都在0到1范围内（包括0和1),其中0表示黑色,255表示白色.

% randomly warp original image to create training set
if (size(im,3) == 3) %image channel
    img = rgb2gray(im); %将图片由rgb变为gray
end
img = imcrop(img, rect);%crop原始图像,imcrop图像剪裁命令,RECT为可选参数，格式为[XMIN YMIN WIGTH HEIGHT].
g = imcrop(g, rect);%crop gauss image
G = fft2(g);%二维快速傅里叶变换,将时域问题转为频域问题,得到数字信号的分析频谱.
            %一维信号(如语音信号)用fft,二维信号(如图像信号)用fft2
            %傅里叶变换的基本思想是:任何连续测量的时序或信号，都可以表示为不同频率的正弦波信号的无限叠加(带棱角的信号可以被无限接近).
height = size(g,1);%取出剪切图像g的height
width = size(g,2);%取出剪切图像g的width
fi = preprocess(imresize(img, [height width]));%imresize缩放图像函数。imresize(A, [numrows numcols]),numrows和numcols分别指定目标图像的高度和宽度。
                                               %imresize 使用双三次方插值方法实现的图片缩放。
                                               %显而易见,由于这种格式允许图像缩放后长宽比例和源图像长宽比例不相同,因此所产生的图像有可能发生畸变。
Ai = (G.*conj(fft2(fi)));%conj函数：用于计算复数的共轭值
Bi = (fft2(fi).*conj(fft2(fi)));
% N = 128;
% %进行这个for循环的意思应该是通过叠加,增加系统鲁棒性,但是只在第一帧增加,后续运行会先前数据进行削弱,因此这里加上意义不大.下面我将每一帧都加上这种操作,
  % 时间上变得非常慢,而且由于rand_warp函数只处理旋转变形,对于其他变形并未进行处理,因此在Surfer数据集中当冲浪者蜷曲身子伸直时,容易出现跟踪失败.
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
fig = figure('Name', 'MOSSE');%鐢诲浘妗唍ame涓篗OSSE
% mkdir(['results_' dataset]);%鍒涘缓鏂囦欢澶圭敤鏉ヤ繚瀛樼敓鎴愮殑甯﹁窡韪鐨勫浘鍍�
time = clock;
for i = 1:size(img_files, 1) %渚濇鍙栧嚭鎵�鏈夊浘鐗�
    img = imread(img_files(i,:));
    im = img;
    if (size(img,3) == 3) %鍙樹负鐏板害鍥惧儚
=======
fig = figure('Name', 'MOSSE');%画图框name为MOSSE
% mkdir(['results_' dataset]);%创建文件夹用来保存生成的带跟踪框的图像
time = clock;
for i = 1:size(img_files, 1) %依次取出所有图片
    img = imread(img_files(i,:));
    im = img;
    if (size(img,3) == 3) %变为灰度图像
>>>>>>> NOSSE
        img = rgb2gray(img);
    end
    if (i == 1)
        Ai = eta.*Ai;
        Bi = eta.*Bi;
    else
        try
<<<<<<< HEAD
            Hi = Ai ./ Bi;%瀵瑰簲鐩搁櫎
            fi = imcrop(img, rect); 
            fi = preprocess(imresize(fi, [height width]));%杩欓噷鎴浘涔嬪悗鐩存帴瀵规柊甯х殑鍥惧儚杩涜鍔犵獥锛岃櫧璇磋В鍐充簡棰戣氨娉勯湶闂锛屼絾鏄篃灏嗘柊甯у叧浜庝笂涓�甯х殑涓績浣嶇疆
                                                          %绐佸嚭浜嗭紝浣嗗彲鑳借繖骞朵笉鏄綋鍓嶅抚鐨勪腑蹇冧綅缃紝鍥犳浼氬嚭鐜版紓绉汇��
            gi = uint8(255*mat2gray(real(ifft2(Hi.*fft2(fi)))));%mat2gray灏嗙煩闃靛綊涓�鍖�.real鍙栧鏁板疄閮�,imag鍙栧鏁拌櫄閮�.ifft2蹇�熷倕閲屽彾鍙嶅彉鎹�
                                                                %杩欓噷褰掍竴鍖栫劧鍚庝箻浠�255鍐嶈浆鎹㈡垚8浣嶆搷浣�,鏄洜涓�8浣嶅浘鍍忔暟鍊间负0-255.
            maxval = max(gi(:)); %鍙栧緱gi鐭╅樀涓渶澶у��
            [P, Q] = find(gi == maxval);%鍙栧緱gi鐭╅樀涓渶澶у�兼墍鍦ㄧ殑浣嶇疆,P=row,Q=column
            dx = mean(Q)-width/2;%寰楀埌绗琋甯у浘鍍忎笌绗琋-1甯у浘鍍忓姣斿鍔犵殑dx涓巇y
            dy = mean(P)-height/2;

            rect = [rect(1)+dx rect(2)+dy width height];%璋冩暣鐭╁舰妗嗕綅缃�,浠ュ緱鍒扮殑鏂扮殑鏈�澶у�间綅缃綔涓虹煩褰㈡涓績,
            fi = imcrop(img, rect); %閲嶆柊鎴浘
            fi = preprocess(imresize(fi, [height width]));%瀵规柊鎴浘鍔犵獥
=======
            Hi = Ai ./ Bi;%对应相除
            fi = imcrop(img, rect); 
            fi = preprocess(imresize(fi, [height width]));%这里截图之后直接对新帧的图像进行加窗，虽说解决了频谱泄露问题，但是也将新帧关于上一帧的中心位置
                                                          %突出了，但可能这并不是当前帧的中心位置，因此会出现漂移。
            gi = uint8(255*mat2gray(real(ifft2(Hi.*fft2(fi)))));%mat2gray将矩阵归一化.real取复数实部,imag取复数虚部.ifft2快速傅里叶反变换
                                                                %这里归一化然后乘以255再转换成8位操作,是因为8位图像数值为0-255.
            maxval = max(gi(:)); %取得gi矩阵中最大值
            [P, Q] = find(gi == maxval);%取得gi矩阵中最大值所在的位置,P=row,Q=column
            dx = mean(Q)-width/2;%得到第N帧图像与第N-1帧图像对比增加的dx与dy
            dy = mean(P)-height/2;

            rect = [rect(1)+dx rect(2)+dy width height];%调整矩形框位置,以得到的新的最大值位置作为矩形框中心,
            fi = imcrop(img, rect); %重新截图
            fi = preprocess(imresize(fi, [height width]));%对新截图加窗
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
            Ai = eta.*(G.*conj(fft2(fi))) + (1-eta).*Ai;%鎸夎鏂囨洿鏂癆i涓嶣i
=======
            Ai = eta.*(G.*conj(fft2(fi))) + (1-eta).*Ai;%按论文更新Ai与Bi
>>>>>>> NOSSE
            Bi = eta.*(fft2(fi).*conj(fft2(fi))) + (1-eta).*Bi;
        catch
            return
        end
    end
    
    % visualization
<<<<<<< HEAD
    text_str = ['Frame: ' num2str(i)];%鍦ㄦ樉绀虹殑鍥句腑闇�瑕佹樉绀虹殑鏂囧瓧鍐呭
    box_color = 'green';%鏄剧ず鏂囧瓧鐨勮儗鏅棰滆壊
    position=[1 1];%鏄剧ず鏂囧瓧鑳屾櫙妗嗗乏涓婅鍧愭爣,鍏跺ぇ灏忚窡闅忔樉绀虹殑鍐呭鏀瑰彉
    result = insertText(im, position,text_str,'FontSize',15,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');
    %insertText:insert tex in image or video,return the processed image or video-BoxOpacity:鏂囨湰妗嗕笉閫忔槑搴�
    %insertShape:Insert shapes in image or video
    result = insertShape(result, 'Rectangle', rect, 'LineWidth', 3);
%     imwrite(result, ['results_' dataset num2str(i, '/%04i.jpg')]);%淇濆瓨鍥惧儚
=======
    text_str = ['Frame: ' num2str(i)];%在显示的图中需要显示的文字内容
    box_color = 'green';%显示文字的背景框颜色
    position=[1 1];%显示文字背景框左上角坐标,其大小跟随显示的内容改变
    result = insertText(im, position,text_str,'FontSize',15,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');
    %insertText:insert tex in image or video,return the processed image or video-BoxOpacity:文本框不透明度
    %insertShape:Insert shapes in image or video
    result = insertShape(result, 'Rectangle', rect, 'LineWidth', 3);
%     imwrite(result, ['results_' dataset num2str(i, '/%04i.jpg')]);%保存图像
>>>>>>> NOSSE
    imshow(result);
end
disp(['Frames-per-second: ' num2str(seq_len / etime(clock,time))])
