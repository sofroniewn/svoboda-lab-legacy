function [im im_adj im_summary] = register_file(cur_file,base_name,ref,align_chan,scim_trial)

	if isfield(ref,'post_fft')
		fast_reg_flag = 1;
	else
		fast_reg_flag = 0;
	end
	
	num_planes = ref.im_props.numPlanes;
	num_chan = ref.im_props.nchans;

%display('Loading image')
%tic
	% load image
	opt.data_type = 'uint16';
	[im_raw improps] = load_image_fast(cur_file,opt);
	num_frames = size(im_raw,3)/num_chan;
%toc

%display('Computing shifts')
%tic
	% compute shifts
	shifts_raw = zeros(num_frames,2);
	if fast_reg_flag
		for ij = 1:num_frames
			plane = mod(ij-1,num_planes)+1;
			cur_im = im_raw(:,:,align_chan + (ij-1)*num_chan);
			ref_im = ref.post_fft{plane};
			shifts_raw(ij,:)= register_image_fast(cur_im,ref_im);			
		end
	else
		for ij = 1:num_frames
			plane = mod(ij-1,num_planes)+1;
			cur_im = im_raw(:,:,align_chan + (ij-1)*num_chan);
			ref_im = ref.base_images{plane};
			[shifts_raw(ij,:) tmp]= register_image(cur_im,ref_im);
		end

	end
%toc

%display('Shifting images')
%tic
	% shift images 
	im_adj_raw = zeros(size(im_raw),'uint16');
%	im_raw = uint16(im_raw);
	for ij = 1:size(im_raw,3)
		ind = floor((ij-1)/num_chan)+1;
		im_adj_raw(:,:,ij) = func_im_shift(im_raw(:,:,ij),shifts_raw(ind,:));
	end
%toc

%display('Resorting data')
%tic

	% resort data
	im = cell(num_planes,num_chan);
	im_adj = cell(num_planes,num_chan);
	mean_aligned = cell(num_planes,num_chan);
	mean_raw = cell(num_planes,num_chan);
	shifts = cell(num_planes,1);
	for ij = 1:num_chan
		for ik = 1:num_planes
%			im{ik,ij} = im_raw(:,:,(ik+(ij-1)*num_chan):num_planes*num_chan:end);
			im_adj{ik,ij} = im_adj_raw(:,:,(ik+(ij-1)*num_chan):num_planes*num_chan:end);
%			mean_raw{ik,ij} = uint16(mean(im{ik,ij},3));
%			mean_aligned{ik,ij} = mean(im_adj{ik,ij},3,'native');
			mean_raw{ik,ij} = uint16(mean(im_raw(:,:,(ik+(ij-1)*num_chan):num_planes*num_chan:end),3));
			mean_aligned{ik,ij} = uint16(mean(im_adj{ik,ij},3));
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
%toc

end