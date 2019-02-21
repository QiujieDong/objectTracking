function [P_O] = getColourMap(patch, bg_hist, fg_hist, n_bins, grayscale_sequence)
%% GETCOLOURMAP computes pixel-wise probabilities (PwP) given PATCH and models BG_HIST and FG_HIST
    % check whether the patch has 3 channels
    [h, w, d] = size(patch);
    % figure out which bin each pixel falls into
    bin_width = 256/n_bins;
    % convert image to d channels array
    patch_array = reshape(double(patch), w*h, d);%这个地方，d是就是图像通道数，也就是后面求论文中的beta时，每一个点都有一个beta，而如果图像是RGB图像，则beta是一个三维向量。
    % to which bin each pixel (for all d channels) belongs to
    bin_indices = floor(patch_array/bin_width) + 1;
    % Get pixel-wise posteriors (PwP)
    P_bg = getP(bg_hist, h, w, bin_indices, grayscale_sequence);%将当前帧在上一帧的bg_hist与fg_hist中取得颜色直方图取得的分数
    P_fg = getP(fg_hist, h, w, bin_indices, grayscale_sequence);
    
    P_O = P_fg ./ (P_fg + P_bg);%前景所占比例。这个P_O就是论文中的beta,对于图像每一个像素点的每一个通道为目标的概率
end
