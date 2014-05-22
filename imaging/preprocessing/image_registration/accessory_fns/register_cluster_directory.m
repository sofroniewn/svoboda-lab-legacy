function register_cluster_directory(data_dir,file_num)

	fprintf('\n Start cluster register %s \n',file_num);

	save_registered_on = 1;
	save_text_on = 0;

	% Directory for registered images
	type_name = 'registered';
	folder_name = fullfile(data_dir,type_name);
	if exist(folder_name) ~= 7
		mkdir(folder_name);
	end

	% Directory for summary data including mean images and shifts
	type_name = 'summary';
	folder_name = fullfile(data_dir,type_name);
	if exist(folder_name) ~= 7
		mkdir(folder_name);
	end

	cur_files = dir(fullfile(data_dir,'*_main_*.tif'));
	cur_file = fullfile(data_dir,cur_files(str2num(file_num)).name);
	[pathstr, base_name, ext] = fileparts(cur_files(str2num(file_num)).name);

	ref_files = dir(fullfile(data_dir,'ref_images_*.mat'));
    load(fullfile(data_dir,ref_files(1).name));
	ref = post_process_ref_fft(ref);
	
	num_planes = ref.im_props.numPlanes;
	num_chan = ref.im_props.nchans;

% if overwrite is off and summary file exists load it in
%if overwrite ~= 1 && exist(summary_file_name) == 2
%else % Otherwise register file
    fprintf('Loading images\n')
    opt.data_type = 'uint16';
    [im_raw improps] = load_image_fast(cur_file,opt);
    
    % register files
    fprintf('Registering images\n')
    [im_shifted shifts] = register_file(im_raw,ref);
    
    % summarize images
    fprintf('Summarizing images\n')
    im_summary = sumarize_images(improps,im_raw,im_shifted,shifts_raw,trial_num);
      
    % save summary data
    save(summary_file_name,'im_summary');
    
    % save registered data
	fprintf('Saving registered images\n')
	save_text_on = 0;
    save_registered_data(data_dir,base_name,trial_str,im_shifted,num_planes,num_chan,text_dir,trial_data,save_registered_on,save_text_on);
%end

	fprintf('DONE\n');
end