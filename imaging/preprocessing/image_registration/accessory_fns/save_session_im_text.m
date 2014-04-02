function save_session_im_text(save_path,num_files,analyze_chan,imaging_on,behaviour_on)

global im_session;
full_im_dat = [];
full_trial_data = [];
dat = [];
trial_data = [];

if behaviour_on
	global session;
end

% --- extract data
for ij = 1:num_files		
	fprintf('(text)  file %g/%g ',ij,num_files);
	
	if imaging_on
			fprintf(' images ');
		% get file name of registered data
		cur_file = fullfile(im_session.basic_info.data_dir,im_session.basic_info.cur_files(ij).name);
		trial_name = cur_file(end-6:end-4);
		[pathstr, base_name, ext] = fileparts(cur_file);
		% define file name
		replace_start = strfind(base_name,'main');
		replace_end = replace_start+4;
		type_name = 'registered';
		file_name = [base_name(1:replace_start-1) type_name  base_name(replace_end:end)];
		full_file_name = fullfile(im_session.basic_info.data_dir,type_name,[file_name '.mat']);	
		load(full_file_name);

		% load in raw registered data
		% convert to text format
		[im_cords dat] = save_im2text(im_aligned,[],analyze_chan,'',0);
		full_im_dat = cat(1,full_im_dat,dat);
	end

	if behaviour_on
		fprintf(' behaviour ');
		trial_num_session = im_session.ref.behaviour_scim_trial_align(ij);
		trial_data_raw = session.data{trial_num_session};
		scim_frame_trig = session.data{trial_num_session}.processed_matrix(7,:);
		[trial_data data_variable_names] = parse_behaviour2im(trial_data_raw,trial_num_session,scim_frame_trig);
  		
		if size(trial_data,1) ~= size(dat,1) && imaging_on
			error('Synchronization scim/behaviour error')
		end
		full_trial_data = cat(1,full_trial_data,trial_data);
	end
	fprintf('\n');
end

if imaging_on
	tSize = size(full_im_dat,1);
	num_planes = max(im_cords.z);
	% parse the info
	for iPlane = 1:num_planes
    	save_path_im = fullfile(save_path,['Text_images_plane_' sprintf('0%d',iPlane) '_' im_session.ref.file_name '.txt']);
		% write to text
		f = fopen(save_path_im,'w');
		fmt = repmat('%u ',1,tSize+2);
		fprintf(f,[fmt,'%u\n'],[im_cords.y(im_cords.z==iPlane);im_cords.x(im_cords.z==iPlane);im_cords.z(im_cords.z==iPlane);full_im_dat(:,im_cords.z==iPlane)]);
		fclose(f);
	end
end

if behaviour_on
	save_path_bv = fullfile(save_path,['Text_behaviour_' im_session.ref.file_name '.txt']);
	
	% write to text
	tSize = size(full_trial_data,1);
    dSize = size(full_trial_data,2);
    z = repmat(999,1,dSize);
    x = repmat(1,1,dSize);
    y = 1:dSize;

	f = fopen(save_path_bv,'w');
    fmt = repmat('%.4f ',1,tSize+2);
    fprintf(f,[fmt,'%.4f\n'],[y;x;z;full_trial_data]);
	fclose(f);

	save_path_bv = fullfile(save_path,['Text_behaviour_names_' im_session.ref.file_name '.mat']);
	save(save_path_bv,'data_variable_names')
end

fprintf('(text)  DONE\n');

