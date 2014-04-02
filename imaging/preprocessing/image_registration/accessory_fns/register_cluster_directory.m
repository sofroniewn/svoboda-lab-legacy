function register_cluster_directory(data_dir,file_num)

	fprintf('\n Start cluster register %s \n',file_num);

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
	
	num_planes = ref.im_props.numPlanes;
	num_chan = ref.im_props.nchans;
	align_chan = ref.im_props.align_chan;

	% load image
	[im_raw improps] = load_image(cur_file);
	im_align = im_raw(:,:,align_chan:num_chan:end);
	num_frames = size(im_align,3);

	fprintf('Compute shifts %s \n',file_num);
	% compute shifts
	shifts_raw = zeros(num_frames,2);
	for ij = 1:num_frames
		plane = mod(ij-1,num_planes)+1;
		act_frame = floor((ij-1)/num_planes) + 1;
		cur_im = im_align(:,:,ij);
		ref_im = ref.base_images{plane};
		[shifts_raw(ij,:) tmp]= register_image(cur_im,ref_im);
	end

	fprintf('Do shifts %s \n',file_num);
	% shift images 
	im_adj_raw = zeros(size(im_raw),'single');
	for ij = 1:size(im_raw,3)
		ind = floor((ij-1)/num_chan)+1;
		im_adj_raw(:,:,ij) = func_im_shift(im_raw(:,:,ij),shifts_raw(ind,:));
	end

	fprintf('Resort data %s \n',file_num);
	% resort data
	im = cell(num_planes,num_chan);
	im_aligned = cell(num_planes,num_chan);
	mean_aligned = cell(num_planes,num_chan);
	mean_raw = cell(num_planes,num_chan);
	shifts = cell(num_planes,1);
	for ij = 1:num_chan
		im_tmp = im_raw(:,:,ij:num_chan:end);
		im_adj_tmp = im_adj_raw(:,:,ij:num_chan:end);
		for ik = 1:num_planes
			im{ik,ij} = im_tmp(:,:,ik:num_planes:end);
			im_aligned{ik,ij} = im_adj_tmp(:,:,ik:num_planes:end);
			mean_raw{ik,ij} = mean(im{ik,ij},3);
			mean_aligned{ik,ij} = mean(im_aligned{ik,ij},3);
			im{ik,ij} = uint16(im{ik,ij});
			im_aligned{ik,ij} = uint16(im_aligned{ik,ij});
			mean_raw{ik,ij} = uint16(mean_raw{ik,ij});
			mean_aligned{ik,ij} = uint16(mean_aligned{ik,ij});
			shifts{ik} = shifts_raw(ik:num_planes:end,:);
		end
	end

	fprintf('Extract summary data %s \n',file_num);
	% extract summary data
	im_summary.props.num_frames = size(shifts_raw,1)/num_planes;
	im_summary.props.num_planes = num_planes;
	im_summary.props.num_chan = num_chan;
	im_summary.props.height = improps.height;
	im_summary.props.width = improps.width;
	im_summary.props.firstFrame = improps.firstFrameNumberRelTrigger;
	im_summary.props.frameRate = improps.frameRate;
	im_summary.shifts = shifts;
	im_summary.mean_raw = mean_raw;
	im_summary.mean_aligned = mean_aligned;

	fprintf('Save data %s \n',file_num);
	% save data
	replace_start = strfind(base_name,'main');
	replace_end = replace_start+4;
	type_name = 'summary';
	file_name = [base_name(1:replace_start-1) type_name  base_name(replace_end:end)];
	full_file_name = fullfile(data_dir,type_name,[file_name '.mat']);
	save(full_file_name,'im_summary');

	type_name = 'registered';
	file_name = [base_name(1:replace_start-1) type_name  base_name(replace_end:end)];
	full_file_name = fullfile(data_dir,type_name,[file_name '.mat']);
	save(full_file_name,'im_aligned');

	fprintf('DONE\n');
end