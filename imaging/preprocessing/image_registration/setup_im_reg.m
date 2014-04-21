function setup_im_reg(handles)

	global im_session;

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
	folder_name = handles.text_path;
	if exist(folder_name) ~= 7
		mkdir(folder_name);
	end

	% If overwrite is not on go through summary data session and reload 
	% already generated data
	% Initialize registration
	im_session.reg = [];
	im_session.reg.nFrames = [];
	im_session.reg.startFrame = [];
	im_session.reg.raw_mean = [];
	im_session.reg.align_mean = [];

end