
% run_tracker.m

close all;
% clear all;

%choose the path to the videos (you'll be able to choose one with the GUI)
base_path = 'D:\objectTracking\configSeqs\OTB-100';

%parameters according to the paper
params.padding = 1.0;         			% extra area surrounding the target
params.output_sigma_factor = 1/16;		% standard deviation for the desired translation filter output
params.scale_sigma_factor = 1/4;        % standard deviation for the desired scale filter output
params.lambda = 1e-2;					% regularization weight (denoted "lambda" in the paper)
params.learning_rate = 0.025;			% tracking model learning rate (denoted "eta" in the paper)
params.number_of_scales = 33;           % number of scale levels (denoted "S" in the paper)
params.scale_step = 1.02;               % Scale increment factor (denoted "a" in the paper)
params.scale_model_max_area = 512;      % the maximum size of scale examples

params.visualization = 1;

%ask the user for the video
video_name = choose_video(base_path);
if isempty(video_name), return, end  %user cancelled
[img_files, pos, target_sz, ground_truth, video_path] = ...
	load_video_info(base_path, video_name);

params.init_pos = pos;
params.wsize = floor(target_sz);
params.img_files = img_files;
params.video_path = video_path;

[positions, fps] = dsst(params);

% calculate precisions
[distance_precision, PASCAL_precision, average_center_location_error] = ...
    compute_performance_measures(positions, ground_truth);

fprintf('video_name : %s\nCenter Location Error: %.3g pixels\nDistance Precision: %.3g %%\nOverlap Precision: %.3g %%\nSpeed: %.3g fps\n', ...
    video_name,average_center_location_error, 100*distance_precision, 100*PASCAL_precision, fps);