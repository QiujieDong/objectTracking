function setup_paths()

% Add the neccesary paths

[pathstr, name, ext] = fileparts(mfilename('fullpath'));


addpath([pathstr '/color/']);
addpath([pathstr '/hog/']);
addpath([pathstr '/implementation/']);
addpath([pathstr '/utils/']);
addpath([pathstr '/srdcf_run/']);
addpath([pathstr '/opencv2/']);