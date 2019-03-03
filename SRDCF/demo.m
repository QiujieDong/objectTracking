
% 下载的源码运行时显示mtimesx.mexw64缺少必要的dll动态链接库,因此从ECO中复制mtimesx.mexw64过来替换原来的

%% This demo script runs the SRDCF tracker on the included "Couple" video.

% % Load video information
% video_path = 'sequences/Couple';
% [seq, ~] = load_video_info(video_path);
% 
setup_paths();

base_path = 'D:\\objectTracking\\configSeqs\\OTB-100\\';
video_name = choose_video(base_path);
[seq, ground_truth] = load_video_info(base_path,video_name);
% % Run SRDCF
results = run_SRDCF(seq);

%% copy from fDSST
positions = results.res;
fps = results.fps;

% calculate precisions
[distance_precision, PASCAL_precision, average_center_location_error] = ...
    compute_performance_measures(positions, ground_truth);

fprintf('video_name : %s\nCenter Location Error: %.3g pixels\nDistance Precision: %.3g %%\nOverlap Precision: %.3g %%\nSpeed: %.3g fps\n', ...
    video_name,average_center_location_error, 100*distance_precision, 100*PASCAL_precision, fps);
%%
