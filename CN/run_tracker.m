
% run_tracker.m

close all;
% clear all;

%choose the path to the videos (you'll be able to choose one with the GUI)
base_path = '/home/qiujiedong/project/MatLAB_workspace/configSeqs/OTB-100/';

%parameters according to the paper
params.padding = 1.0;         			   % extra area surrounding the target
params.output_sigma_factor = 1/16;		   % spatial bandwidth (proportional(对称的) to target)
params.sigma = 0.2;         			   % gaussian kernel bandwidth
params.lambda = 1e-2;					   % regularization (denoted "lambda" in the paper)
params.learning_rate = 0.075;			   % learning rate for appearance model update scheme (denoted "gamma" in the paper)
params.compression_learning_rate = 0.15;   % learning rate for the adaptive dimensionality reduction (denoted "mu" in the paper)
params.non_compressed_features = {'gray'}; % features that are not compressed(压缩), a cell with strings (possible choices: 'gray', 'cn')
params.compressed_features = {'cn'};       % features that are compressed, a cell with strings (possible choices: 'gray', 'cn')
params.num_compressed_dim = 2;             % the dimensionality of the compressed features

params.visualization = 1;

%ask the user for the video
video_name = choose_video(base_path);
if isempty(video_name), return, end  %user cancelled
[img_files, pos, target_sz, ground_truth, video_path] = ...
	load_video_info(base_path,video_name);

params.init_pos = floor(pos) + floor(target_sz/2);%这里将pos换到中心位置
params.wsize = floor(target_sz);%目标区域大小
params.img_files = img_files;
params.video_path = video_path;
params.video_name = video_name;

[positions, fps] = color_tracker(params);

% calculate precisions
%Center Location Error-预测目标中心与ground-truth中心的平均欧几里得距离(越小越好)
%Distance Precision-中心距离小于阈值(这里设定是20pix)的帧数比率(越大越好)
%Overlap Precision-预测bounding-box与ground-truth的bounding-box的重叠率大于阈值(这里设定的是0.5)的比率(越大越好)
[distance_precision, PASCAL_precision, average_center_location_error] = ...
    compute_performance_measures(positions, ground_truth);

fprintf('Video name: %s\nCenter Location Error: %.3g pixels\nDistance Precision: %.3g %%\nOverlap Precision: %.3g %%\nSpeed: %.3g fps\n', ...
    video_name,average_center_location_error, 100*distance_precision, 100*PASCAL_precision, fps);
