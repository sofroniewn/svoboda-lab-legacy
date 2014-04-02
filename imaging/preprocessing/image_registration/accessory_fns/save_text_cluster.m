function save_text_cluster(data_dir,plane_num,analyze_chan,ref_file_name,num_files,num_frames,num_pixels)

	fprintf('\nStart cluster text saver plane %s \n',plane_num);
	num_files = str2num(num_files);
	plane_num = str2num(plane_num);
	num_frames = str2num(num_frames);
	num_pixels = str2num(num_pixels);
	analyze_chan = str2num(analyze_chan);

	save_path = fileparts(data_dir);
	save_path = fullfile(save_path,'session');

	cur_files = dir(fullfile(data_dir,'registered','*_registered_*.mat'));
	
	full_im_dat = zeros(num_frames,num_pixels,'uint16');
	start_ind = 1;
	for ij = 1:num_files;
		fprintf('(text)  file %g/%g \n',ij,num_files);
	    load(fullfile(data_dir,'registered',cur_files(ij).name));
		[im_cords dat] = save_im2text(im_aligned,[],analyze_chan,'',0);
		num_frame_file = size(dat,1);
		full_im_dat(start_ind:start_ind+num_frame_file-1,:) = dat(:,im_cords.z==plane_num);
		start_ind = start_ind+num_frame_file;
	end
	if start_ind ~= num_frames+1
		error('Wrong number of frames');
	end

	fprintf('Saving plane %s \n',num2str(plane_num));
    save_path_im = fullfile(save_path,['Text_images_plane_' sprintf('0%d',plane_num) '_' ref_file_name '.txt']);
	% write to text
	f = fopen(save_path_im,'w');
	fmt = repmat('%u ',1,num_frames+2);
	fprintf(f,[fmt,'%u\n'],[im_cords.y(im_cords.z==plane_num);im_cords.x(im_cords.z==plane_num);im_cords.z(im_cords.z==plane_num);full_im_dat]);
	fclose(f);

	fprintf('DONE\n');
end