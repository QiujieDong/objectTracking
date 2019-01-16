function z = feature_projection(x_npca, x_pca, projection_matrix, cos_window)

% z = feature_projection(x_npca, x_pca, projection_matrix, cos_window)
%
% Calculates the compressed feature map by mapping the PCA features with
% the projection matrix and concatinates this with the non-PCA features.
% The feature map is then windowed.

if isempty(x_pca)
    % if no PCA-features exist, only use non-PCA
    z = x_npca;
else
    % get dimensions
    [height, width] = size(cos_window);
    [num_pca_in, num_pca_out] = size(projection_matrix);
    
    % project the PCA-features using the projection matrix and reshape
    % to a window
    x_proj_pca = reshape(x_pca * projection_matrix, [height, width, num_pca_out]);
    
    % concatinate(串联) the feature windows
    if isempty(x_npca)
        z = x_proj_pca;
    else
        z = cat(3, x_npca, x_proj_pca);%在第三个维度上对矩阵进行串联。输出z为height*wigth*3维度，PCA特征为二维，no_PCA特征一维，串联后组成三维
    end
end

% do the windowing of the output
z = bsxfun(@times, cos_window, z);%@times-数组乘法
end