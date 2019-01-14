function video_path = choose_video(base_path)
%CHOOSE_VIDEO
%   Allows the user to choose a video (sub-folder in the given path).
%   Returns the full path to the selected sub-folder.
%
%   Jo?o F. Henriques, 2012
%   http://www.isr.uc.pt/~henriques/

	%process path to make sure it's uniform
	
    if ispc() %ispc用来判断当前的电脑系统是否是windows系统，是返回1，不是返回0 
        base_path = strrep(base_path, '\', '/');%strrep查找并替换子字符串,将str中出现的所有old都替换为new.newStr=strrep(str,old,new)
    end
    
    if base_path(end) ~= '/' %完善base_path
        base_path(end+1) = '/'; 
    end
	
	%list all sub-folders
	contents = dir(base_path);%返回当前路径中的所有文件以及文件夹所组成的列表(这里面包含'.'和'..')
	names = {};%用来存储所有文件夹的name
	for k = 1:numel(contents)%numel返回数组中元素个数
		name = contents(k).name;
		if isfolder([base_path name]) && ~strcmp(name, '.') && ~strcmp(name, '..')%MATLAB建议将isdir改为isfolder; strcmp为字符串比较函数
			names{end+1} = name;  %#ok
		end
	end
	
	%no sub-folders found
	
    if isempty(names)%如果当前路径中没有文件夹 
        video_path = []; 
        return; 
    end
	
	%choice GUI
	choice = listdlg('ListString',names, 'Name','Choose video', 'SelectionMode','single');%列表选择对话框 Listdlg
	
	if isempty(choice)  %user cancelled
		video_path = [];
	else
		video_path = [base_path names{choice} '/'];
	end
	
end

