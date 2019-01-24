% 二维gauss函数,

function val = gaussC(x, y, sigma, a, center)
    xc = center(1);
    yc = center(2);
%     sigma_x = std(xc,0,2).^2;
%     sigma_y = std(yc,0,1).^2;
    exponent = ((x-xc).^2 + (y-yc).^2)./(2*sigma^2);%这里对于sigma我们对于x和y取值一样,这样对于二维高斯模型在平面上投影就是一个圆形,意思是在距离目标中心(xc,yc)一样的情况下
                                                    %所取得的权重是一样的.若取不一样的值,那么投影为一个椭圆形,距离目标中心一样的情况下就会得到不一样的权重.
%     exponent = ((x-xc).^2)./(2*sigma_x^2) + ((y-yc).^2)./(2*sigma_y^2);
    val = a * (exp(-exponent)); 