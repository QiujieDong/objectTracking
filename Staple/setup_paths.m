function setup_paths()

    % Add the neccesary paths

    [pathstr, ~, ~] = fileparts(mfilename('fullpath'));

    % video infomation
    addpath(genpath([pathstr '/videoInfo/']));

    % initialization
    addpath(genpath([pathstr '/initialization/']));

    % mexResize
    addpath(genpath([pathstr '/mexResize/']));

    % colorHist 
    addpath(genpath([pathstr '/colorHist/']));

    %hog feature
    addpath(genpath([pathstr '/hogFeature/']));

    % scale_eval
    addpath(genpath([pathstr '/scaleAdaptation/']));

    % implemetion
    addpath(genpath([pathstr '/implemetion/']));

    % VOT
    addpath(genpath([pathstr '/runVOT/']));
    
    % resopnse
    addpath(genpath([pathstr '/response/']));
end

