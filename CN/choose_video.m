function video_name = choose_video(base_path)

% video_path = choose_video(base_path)
%按照KCF代码将此文件进行更改
%process path to make sure it's uniform
if ispc(), base_path = strrep(base_path, '\', '/'); end
if base_path(end) ~= '/', base_path(end+1) = '/'; end

%list all sub-folders
contents = dir(base_path);
names = {};
for k = 1:numel(contents)
    name = contents(k).name;
    if isfolder([base_path name]) && ~strcmp(name, '.') && ~strcmp(name, '..')
        names{end+1} = name;  %#ok
    end
end

%no sub-folders found
if isempty(names), video_name = []; return; end

%choice GUI
choice = listdlg('ListString',names, 'Name','Choose video', 'SelectionMode','single');

if isempty(choice) %user cancelled
    video_name = [];
else
    video_name = names{choice};
end

end

