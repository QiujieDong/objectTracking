% Demo for paper "Fast Tracking via Spatio-Temporal Context Learning,"Kaihua Zhang, Lei Zhang,Ming-Hsuan Yang and David Zhang
% Paper can be available from http://arxiv.org/pdf/1311.1939v1.pdf 
% Implemented by Kaihua Zhang, Dept.of Computing, HK PolyU.
% Email: zhkhua@gmail.com
% Date: 11/24/2013
%%
clc;close all;
%%
fftw('planner','patient');
%% set path
base_path = 'D:\objectTracking\configSeqs\OTB-100';
video = choose_video(base_path);
[img_files, pos, target_sz, ground_truth, video_path] = load_video_info(base_path, video);
% addpath('./data');
% img_dir = dir('./data/*.jpg');
%% initialization
% initstate = [161,65,75,95];%initial rectangle [x,y,width, height]
% initstate = ground_truth(1,:);
% pos = [initstate(2)+initstate(4)/2 initstate(1)+initstate(3)/2];%center of the target
% target_sz = [initstate(4) initstate(3)];%initial size of the target
%% parameters according to the paper
padding = 1;					%extra area surrounding the target
rho = 0.075;			        %the learning parameter \rho in Eq.(12)
sz = floor(target_sz * (1 + padding));% size of context region
%% parameters of scale update. See Eq.(15)
scale = 1;%initial scale ratio
lambda = 0.25;% \lambda in Eq.(15)
num = 5; % number of average frames
%% store pre-computed confidence map
alapha = 2.25;                    %parmeter \alpha in Eq.(6)
[rs, cs] = ndgrid((1:sz(1)) - floor(sz(1)/2), (1:sz(2)) - floor(sz(2)/2));
dist = rs.^2 + cs.^2;
conf = exp(-0.5 / (alapha) * sqrt(dist));%confidence map function Eq.(6)
conf = conf/sum(sum(conf));% normalization
conff = fft2(conf); %transform conf to frequencey domain
%% store pre-computed weight window
hamming_window = hamming(sz(1)) * hann(sz(2))';
sigma = mean(target_sz);% initial \sigma_1 for the weight function w_{\sigma} in Eq.(11)
window = hamming_window.*exp(-0.5 / (sigma^2) *(dist));% use Hamming window to reduce frequency effect of image boundary
window = window/sum(sum(window));%normalization
%%
for frame = 1:numel(img_files)
    sigma = sigma*scale;% update scale in Eq.(15)
    window = hamming_window.*exp(-0.5 / (sigma^2) *(dist));%update weight function w_{sigma} in Eq.(11)
    window = window/sum(sum(window));%normalization
 	%load image
    img = imread([video_path img_files{frame}]);	    
	if size(img,3) > 1
		im = rgb2gray(img);
	end
   	contextprior = get_context(im, pos, sz, window);% the context prior model Eq.(4)
    %%
    if frame > 1
		%calculate response of the confidence map at all locations
	    confmap = real(ifft2(Hstcf.*fft2(contextprior))); %Eq.(11) 
       	%target location is at the maximum response
		[row, col] = find(confmap == max(confmap(:)), 1);
        pos = pos - sz/2 + [row, col]; 
        contextprior = get_context(im, pos, sz, window);
        conftmp = real(ifft2(Hstcf.*fft2(contextprior))); 
        maxconf(frame-1)=max(conftmp(:));
        %% update scale by Eq.(15)
        if (mod(frame,num+2)==0)
            scale_curr = 0;
            for kk=1:num
               scale_curr = scale_curr + sqrt(maxconf(frame-kk)/maxconf(frame-kk-1));
            end            
            scale = (1-lambda)*scale+lambda*(scale_curr/num);%update scale
        end  
        %%
    end	
	%% update the spatial context model h^{sc} in Eq.(9)
   	contextprior = get_context(im, pos, sz, window); 
    hscf = conff./(fft2(contextprior)+eps);% Note the hscf is the FFT of hsc in Eq.(9)
    %% update the spatio-temporal context model by Eq.(12)
    if frame == 1  %first frame, initialize the spatio-temporal context model as the spatial context model
		Hstcf = hscf;
	else
		%update the spatio-temporal context model H^{stc} by Eq.(12)
		Hstcf = (1 - rho) * Hstcf + rho * hscf;% Hstcf is the FFT of Hstc in Eq.(12)
    end
    %% visualization
    target_sz([2,1]) = target_sz([2,1])*scale;% update object size
	rect_position = [pos([2,1]) - (target_sz([2,1])/2), (target_sz([2,1]))];  
    imagesc(uint8(img))
    colormap(gray)
    rectangle('Position',rect_position,'LineWidth',4,'EdgeColor','r');
    hold on;
    text(5, 18, strcat('#',num2str(frame)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
    set(gca,'position',[0 0 1 1]); 
    pause(0.001); 
    hold off;
    drawnow;    
end