function im_session = load_im_session_data(data_dir)

im_session.basic_info.data_dir = data_dir;
[pathstr, name, ext] = fileparts(data_dir); 
[pathstr, name, ext] = fileparts(pathstr); 
im_session.basic_info.run_str = name;
[pathstr, name, ext] = fileparts(pathstr); 
im_session.basic_info.date_str = name;
[pathstr, name, ext] = fileparts(pathstr); 
im_session.basic_info.anm_str = name;

im_session.basic_info.cur_files = dir(fullfile(im_session.basic_info.data_dir,'*_main_*.tif'));
%im_session.data = cell(numel(cur_files)-1,1);
%
%for ij = 1:numel(cur_files)-1
%    f_name = fullfile(data_dir,cur_files(ij).name);
%    session.data{ij} = load(f_name);
%    session.data{ij}.f_name = f_name;
%end

	% If overwrite is not on go through summary data session and reload 
	% already generated data
	% Initialize registration
	im_session.reg = [];
	im_session.reg.nFrames = [];
	im_session.reg.startFrame = [];
	im_session.reg.raw_mean = [];
	im_session.reg.align_mean = [];
	im_session.reg.behaviour_scim_trial_align = [];


	% Directory for registered images
	type_name = 'registered';
	folder_name = fullfile(im_session.basic_info.data_dir,type_name);
	if exist(folder_name) ~= 7
		mkdir(folder_name);
	end

	% Directory for summary data including mean images and shifts
	type_name = 'summary';
	folder_name = fullfile(im_session.basic_info.data_dir,type_name);
	if exist(folder_name) ~= 7
		mkdir(folder_name);
	end

	% Directory for text data
	type_name = 'text';
	folder_name = fullfile(im_session.basic_info.data_dir,type_name);
	if exist(folder_name) ~= 7
		mkdir(folder_name);
	end



end