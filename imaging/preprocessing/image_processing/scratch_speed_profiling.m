
fullpath = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/scanimage/an227254_2013_12_12_main_001.tif';

tic;
hdr = extern_scim_opentif(fullpath, 'header');
toc

tic;
[im improps] = load_image(fullpath);
toc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global im_session;
align_chan = 1;
ij = 1;
base_name = '';
cur_file = fullpath;
ref = im_session.ref;

tic
[im_raw im_aligned im_summary] = register_file(cur_file,base_name,ref,align_chan,ij);	
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if isfield(ref,'post_fft')
		fast_reg_flag = 1
	else
		fast_reg_flag = 0
	end

	num_planes = ref.im_props.numPlanes;
	num_chan = ref.im_props.nchans;

	% load image
	[im_raw improps] = load_image(cur_file);
	im_align = im_raw(:,:,align_chan:num_chan:end);
	num_frames = size(im_align,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		fast_reg_flag = 1

tic
	% compute shifts
	shifts_raw = zeros(num_frames,2);
	parfor ij = 1:num_frames
		plane = mod(ij-1,num_planes)+1;
		act_frame = floor((ij-1)/num_planes) + 1;
		cur_im = im_align(:,:,ij);
		if fast_reg_flag
			ref_im = ref.post_fft{plane};
			[shifts_raw(ij,:) tmp]= register_image_fast(cur_im,ref_im);			
		else
			ref_im = ref.base_images{plane};
			[shifts_raw(ij,:) tmp]= register_image(cur_im,ref_im);
		end
	end
toc











