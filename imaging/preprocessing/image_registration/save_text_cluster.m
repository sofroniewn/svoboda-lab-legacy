function save_text_cluster(data_dir,plane_num,analyze_chan,down_sample,num_files,num_frames,num_pixels)

	fprintf('\nStart cluster text saver plane %s \n',plane_num);
	num_files = str2num(num_files);
	plane_num = str2num(plane_num);
	num_frames = str2num(num_frames);
	num_pixels = str2num(num_pixels);
	analyze_chan = str2num(analyze_chan);
	down_sample = str2num(down_sample);

	save_path = fileparts(data_dir);
	save_path = fullfile(save_path,'session');

	cur_files = dir(fullfile(data_dir,'*_main_*.tif'));

	full_im_dat = zeros(num_frames,num_pixels,'uint16');
	start_ind = 1;

	for ij = 1:num_files;
		fprintf('(text)  file %g/%g \n',ij,num_files);	
		cur_file = fullfile(data_dir,cur_files(ij).name);
		[keys values] = read_aligned_images(cur_file,plane_num,analyze_chan,down_sample);
		im_cords = keys;
		num_frame_file = size(values,1);
		full_im_dat(start_ind:start_ind+num_frame_file-1,:) = values;
		start_ind = start_ind+num_frame_file;
	end
	if start_ind ~= num_frames+1
		error('Wrong number of frames');
	end

	fprintf('Saving plane %s \n',num2str(plane_num));
    save_path_im = fullfile(save_path,['Text_images_p' sprintf('%02d',plane_num) '_c' sprintf('%02d',analyze_chan) '.txt']);
    % write to text
	f = fopen(save_path_im,'w');
	fmt = repmat('%u ',1,num_frames+3);
	fprintf(f,[fmt,'%u\n'],[im_cords;full_im_dat]);
	fclose(f);

	fprintf('DONE\n');
end