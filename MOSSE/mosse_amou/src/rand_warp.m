
%通过将所截图像围绕在一定角度内旋转获得不同图像,通过对不同图像进行采样,从而获得跟踪物体不同姿态的截图,增加系统鲁棒性.
%注意:考虑的时候要用矩阵的思想去考虑图像,而不是单纯的图像形式.旋转操作之后,虽然中心是不变,但是周围数值发生改变,而截取框大小位置不变,这时就会将背景截取进来
function img = rand_warp(img)
a = -180/16;
b = 180/16;
r = a + (b-a).*rand;%rand返回一个在区间 (0,1) 内均匀分布的随机数。
sz = size(img);
scale = 1-0.1 + 0.2.*rand;
% trans_scale = randi([-4,4], 1, 1);
img = imresize(imresize(imrotate(img, r), scale), [sz(1) sz(2)]);
   %将图像img（图像的数据矩阵）绕图像的中心点旋转r度,正数表示逆时针旋转,负数表示顺时针旋转.返回旋转后的图像矩阵.
   %imresize(img,scale),返回图像的长宽是img长宽的scale倍,若scale>1则放大图像,若scale<1则缩小图像.
