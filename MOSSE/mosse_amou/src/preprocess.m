<<<<<<< HEAD
%论文中提到,FFT卷积算法的一个问题是图像和滤波器被映射到环面的拓扑结构,人为的连接图像的边界引入影响相关输出的伪像.
%为了解决上述问题,进行数据预处理.
%注:要进行加窗操作一般在时域中进行,因为在时域中是点乘操作,在频域中是卷积操作.因此加窗操作是在傅里叶变换之前
function img = preprocess(img)
[r,c] = size(img);%r=height(row),c=width(column)
win = window2(r,c,@hann);%生成即将加到数字信号上的汉宁窗
% eps = 1e-5;%加入噪声,增强模型鲁棒性
% img = double(img) / 255;
% 		
% img = img - mean(img(:));
img = log(double(img)+1);%论文中提出,使用对数函数改变像素值,有助于低对比度的照明情况
img = (img-mean(img(:)))/(std(img(:))+eps);%将像素归一化为平均值为0的值.(论文中提到将数据处理为平均值为0,方差为1的值)
%img(img<0)=0;%将矩阵中负值替换为0,后续不加窗,会出现跟踪失败情况.
img = img.*win;%数据加框.论文中提到过图像乘以余弦窗口(汉宁窗就是余弦窗)
                %奇怪的是此代码加窗后跟踪效果反而更差,通过输出加窗前后特征图对比可以看到,加窗操作造成了许多特征信息丢失.
                %解释:其实并不是加窗后跟踪效果变差,加窗操作就是突出裁剪图的中心位置,减弱边缘位置,因此加窗后跟踪器就将关注点放在了裁剪图的中心,而不是整个
                % 裁剪图,但是当我们裁剪整个物体时就会发现,跟踪器只跟踪物体中心位置,这就造成了误以为跟踪效果差的原因   
=======
%�������ᵽ,FFT�����㷨��һ��������ͼ����˲�����ӳ�䵽��������˽ṹ,��Ϊ������ͼ��ı߽�����Ӱ����������α��.
%Ϊ�˽����������,��������Ԥ����.
%ע:Ҫ���мӴ�����һ����ʱ���н���,��Ϊ��ʱ�����ǵ�˲���,��Ƶ�����Ǿ�������.��˼Ӵ��������ڸ���Ҷ�任֮ǰ
function img = preprocess(img)
[r,c] = size(img);%r=height(row),c=width(column)
win = window2(r,c,@hann);%���ɼ����ӵ������ź��ϵĺ�����
% eps = 1e-5;%��������,��ǿģ��³����
% img = double(img) / 255;
% 		
% img = img - mean(img(:));
img = log(double(img)+1);%���������,ʹ�ö��������ı�����ֵ,�����ڵͶԱȶȵ��������
img = (img-mean(img(:)))/(std(img(:))+eps);%�����ع�һ��Ϊƽ��ֵΪ0��ֵ.(�������ᵽ�����ݴ���Ϊƽ��ֵΪ0,����Ϊ1��ֵ)
%img(img<0)=0;%�������и�ֵ�滻Ϊ0,�������Ӵ�,����ָ���ʧ�����.
img = img.*win;%���ݼӿ�.�������ᵽ��ͼ��������Ҵ���(�������������Ҵ�)
                %��ֵ��Ǵ˴���Ӵ������Ч����������,ͨ������Ӵ�ǰ������ͼ�Աȿ��Կ���,�Ӵ��������������������Ϣ��ʧ.
                %����:��ʵ�����ǼӴ������Ч�����,�Ӵ���������ͻ���ü�ͼ������λ��,������Եλ��,��˼Ӵ���������ͽ���ע������˲ü�ͼ������,����������
                % �ü�ͼ,���ǵ����ǲü���������ʱ�ͻᷢ��,������ֻ������������λ��,������������Ϊ����Ч�����ԭ��   
>>>>>>> NOSSE
end