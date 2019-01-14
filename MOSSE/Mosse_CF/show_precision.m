function show_precision(positions, ground_truth, title)
%SHOW_PRECISION
%   Calculates precision for a series of distance thresholds (percentage of
%   frames where the distance to the ground truth is within the threshold).
%   The results are shown in a new figure.
%
%   Accepts positions and ground truth as Nx2 matrices (for N frames), and
%   a title string.
%
<<<<<<< HEAD
%   Joï¿½o F. Henriques, 2012
=======
%   Jo?o F. Henriques, 2012
>>>>>>> NOSSE
%   http://www.isr.uc.pt/~henriques/

	
	max_threshold = 50;  %used for graphs in the paper
	
	
<<<<<<< HEAD
	if size(positions,1) ~= size(ground_truth,1) %~= æ˜¯ä¸ç­‰äºŽå·
=======
	if size(positions,1) ~= size(ground_truth,1) %~= ÊÇ²»µÈÓÚºÅ
>>>>>>> NOSSE
		disp('Could not plot precisions, because the number of ground')
		disp('truth frames does not match the number of tracked frames.')
		return
	end
	%%
    target_sz = [ground_truth(:,4), ground_truth(:,3)];
<<<<<<< HEAD
	pos = [ground_truth(:,2), ground_truth(:,1)] + floor(target_sz/2);%ç¬¬ä¸€å¸§ä½ç½®çš„åƒç´ å€¼
	%% calculate distances to ground truth over all frames
	distances = sqrt((positions(:,1) - pos(:,1)).^2 + ...
				 	 (positions(:,2) - pos(:,2)).^2);
	distances(isnan(distances)) = []; %æ— ç©·å¤§çš„è·ç¦»ä¸º[]
=======
	pos = [ground_truth(:,2), ground_truth(:,1)] + floor(target_sz/2);%µÚÒ»Ö¡Î»ÖÃµÄÏñËØÖµ
	%% calculate distances to ground truth over all frames
	distances = sqrt((positions(:,1) - pos(:,1)).^2 + ...
				 	 (positions(:,2) - pos(:,2)).^2);
	distances(isnan(distances)) = []; %ÎÞÇî´óµÄ¾àÀëÎª[]
>>>>>>> NOSSE

	%compute precisions
	precisions = zeros(max_threshold, 1);
	for p = 1:max_threshold
<<<<<<< HEAD
		precisions(p) = nnz(distances < p) / numel(distances);%nnz(x):è¿”å›žçŸ©é˜µXä¸­çš„éžé›¶å…ƒç´ çš„æ•°ç›®;nnz(X)/prod(size(X)):ç¨€ç–çŸ©é˜µçš„å¯†åº¦æ˜¯
=======
		precisions(p) = nnz(distances < p) / numel(distances);%nnz(x):·µ»Ø¾ØÕóXÖÐµÄ·ÇÁãÔªËØµÄÊýÄ¿;nnz(X)/prod(size(X)):Ï¡Êè¾ØÕóµÄÃÜ¶ÈÊÇ
>>>>>>> NOSSE
	end
	
	%plot the precisions
	figure( 'Name',['Precisions - ' title])
	plot(precisions, 'k-', 'LineWidth',2)
    grid on
	xlabel('Threshold'), ylabel('Precision')

end

