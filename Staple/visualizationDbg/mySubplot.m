function mySubplot(figureHandle, subplotWidth, subplotHeight, subplotPos, img, imgTitle, newMap)
% MYSUBPLOT creates a matrix of subplots, each with a custom colormap    
    changeMap = sprintf('colormap %s', newMap);%sprintf - 将数据格式化为字符串
    figure(figureHandle)%在figureHandle个figure上画图	
    subplot(subplotWidth, subplotHeight, subplotPos)%长宽比例
	imagesc(img) %imagesc - 显示使用经过标度映射的颜色的图像
    eval(changeMap);%eval - 执行文本中的 MATLAB 表达式,这里是给图像上色
    freezeColors %冻结颜色色标，防止在同一figure上画多图时，颜色色标改变造成其他的都改变了。
	pbaspect([size(img,2),size(img,1),1]);%pbaspect - 控制每个轴的相对长度,设置当前坐标区的图框纵横比
	title(imgTitle)
    axis off;
end