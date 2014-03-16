function [im im_adj im_summary] = register_file(cur_file,base_name,ref,align_chan,scim_trial)

	num_planes = ref.im_props.numPlanes;
	num_chan = ref.im_props.nchans;

	% load image
	[im_raw improps] = load_image(cur_file);
	im_align = im_raw(:,:,align_chan:num_chan:end);
	num_frames = size(im_align,3);


	% compute shifts
	shifts_raw = zeros(num_frames,2);
	for ij = 1:num_frames
		plane = mod(ij-1,num_planes)+1;
		act_frame = floor((ij-1)/num_planes) + 1;
		cur_im = im_align(:,:,ij);
		ref_im = ref.base_images{plane};
		[shifts_raw(ij,:) tmp]= register_image(cur_im,ref_im);
	end

	% shift images 
	im_adj_raw = zeros(size(im_raw),'single');
	for ij = 1:size(im_raw,3)
		ind = floor((ij-1)/num_chan)+1;
		im_adj_raw(:,:,ij) = func_im_shift(im_raw(:,:,ij),shifts_raw(ind,:));
	end

	% resort data
	im = cell(num_planes,num_chan);
	im_adj = cell(num_planes,num_chan);
	mean_aligned = cell(num_planes,num_chan);
	mean_raw = cell(num_planes,num_chan);
	shifts = cell(num_planes,1);
	for ij = 1:num_chan
		im_tmp = im_raw(:,:,ij:num_chan:end);
		im_adj_tmp = im_adj_raw(:,:,ij:num_chan:end);
		for ik = 1:num_planes
			im{ik,ij} = im_tmp(:,:,ik:num_planes:end);
			im_adj{ik,ij} = im_adj_tmp(:,:,ik:num_planes:end);
			mean_raw{ik,ij} = mean(im{ik,ij},3);
			mean_aligned{ik,ij} = mean(im_adj{ik,ij},3);
			shifts{ik} = shifts_raw(ik:num_planes:end,:);
		end
	end

	% extract summary data
	im_summary.props.num_frames = size(shifts_raw,1)/num_planes;
	im_summary.props.num_planes = num_planes;
	im_summary.props.num_chan = num_chan;
	im_summary.props.height = improps.height;
	im_summary.props.width = improps.width;
	im_summary.props.firstFrame = improps.firstFrameNumberRelTrigger;
	im_summary.props.frameRate = improps.frameRate;
	im_summary.props.scim_trial = scim_trial;
	im_summary.shifts = shifts;
	im_summary.mean_raw = mean_raw;
	im_summary.mean_aligned = mean_aligned;

end