% This function runs the SRDCF tracker on the video specified in "seq".
% It can be integrated directly in the Online Tracking Benchmark (OTB).
% The parameters are set as in the ICCV 2015 paper.

function results=run_SRDCF(seq, res_path, bSaveImage, parameters)

% Default parameters used in the ICCV 2015 paper

% HOG feature parameters
hog_params.nDim = 31;%HOG的特征维度

% Grayscale feature parameters；grayscale
grayscale_params.colorspace='gray';
grayscale_params.nDim = 1;

% Global feature parameters 
params.t_features = {
    struct('getFeature',@get_colorspace, 'fparams',grayscale_params),...  % Grayscale is not used as default
    struct('getFeature',@get_fhog,'fparams',hog_params),...
};
params.t_global.cell_size = 4;                  % Feature cell size,Hog的cell size
params.t_global.cell_selection_thresh = 0.75^2; % Threshold for reducing the cell size in low-resolution cases，在低分辨率时降低cell size

% Filter parameters
params.search_area_shape = 'square';    % the shape of the training/detection window: 'proportional', 'square' or 'fix_padding'
params.search_area_scale = 4;           % the size of the training/detection area proportional to the target size%搜索区域,尝试过小点范围，可最终效果不理想，搜索区域太大导致速度变慢。
params.filter_max_area = 50^2;          % the size of the training/detection area in feature grid cells %滤波器的最大区域

% Learning parameters
params.learning_rate = 0.025;			% learning rate
params.output_sigma_factor = 1/16;		% standard deviation of the desired correlation output (proportional to target)
params.init_strategy = 'indep';         % strategy for initializing the filter: 'const_reg' or 'indep'%换成const_reg会报错
params.num_GS_iter = 4;                 % number of Gauss-Seidel iterations in the learning %高斯-塞德尔迭代，用来求近似

% Detection parameters
params.refinement_iterations = 1;       % number of iterations used to refine the resulting position in a frame
params.interpolate_response = 4;        % correlation score interpolation strategy: 0 - off, 1 - feature grid, 2 - pixel grid, 4 - Newton's method
params.newton_iterations = 5;           % number of Newton's iteration to maximize the detection scores

% Regularization window parameters
params.use_reg_window = 1;              % whether to use windowed regularization or not
params.reg_window_min = 0.1;			% the minimum value of the regularization window
params.reg_window_edge = 3.0;           % the impact of the spatial regularization (value at the target border), depends on the detection size and the feature dimensionality
params.reg_window_power = 2;            % the degree of the polynomial to use (e.g. 2 is a quadratic window)使用2次多项式
params.reg_sparsity_threshold = 0.05;   % a relative threshold of which DFT coefficients that should be set to zero%正则化稀疏精度，设置为0，可以降低运算消耗
params.lambda = 1e-2;					% the weight of the standard (uniform) regularization, only used when params.use_reg_window == 0

% Scale parameters
params.number_of_scales = 7;%使用尺度金字塔的方法
params.scale_step = 1.01;%尺度金字塔步幅

% Debug and visualization
params.visualization = 1;
params.debug = 0;


params.wsize = [seq.init_rect(1,4), seq.init_rect(1,3)];%目标的height与width
params.init_pos = [seq.init_rect(1,2), seq.init_rect(1,1)] + floor(params.wsize/2);%目标中心点（y,x）
params.s_frames = seq.s_frames;

results = SRDCF_tracker(params);
