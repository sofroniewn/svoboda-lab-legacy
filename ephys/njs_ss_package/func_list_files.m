function file_list = func_list_files(base_dir,f_name_flag,file_nums)
%%
disp(['--------------------------------------------']);
disp(['LIST FILES']);

% list files
ephys_file_dir = fullfile(base_dir,'ephys','raw',f_name_flag);
raw_file_list = dir(ephys_file_dir);
[pathstr, f_name_base, ext] = fileparts(raw_file_list(1).name);


full_file_list = cell(numel(raw_file_list),1);
for ij = 1:numel(raw_file_list)
    if ij == 1
    full_file_list{ij} = [f_name_base '.bin'];
    else
    full_file_list{ij} = [f_name_base '_' num2str(ij-1) '.bin'];
    end  
end

if isempty(file_nums) == 1
    file_list = full_file_list;
else
	file_nums(file_nums>numel(raw_file_list)) = [];
    file_list = full_file_list(file_nums);
end

disp(['--------------------------------------------']);
