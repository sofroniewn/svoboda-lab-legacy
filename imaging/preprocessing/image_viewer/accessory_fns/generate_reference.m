function ref = generate_reference(base_im_path,align_chan,save_opt)


% Load in images
opt.data_type = 'uint16';
[im im_props] = load_image_fast(base_im_path, opt);

ref.im_props.nchans = im_props.nchans;
ref.im_props.frameRate = im_props.frameRate;
ref.im_props.numPlanes = im_props.numPlanes;
ref.im_props.height = im_props.height;
ref.im_props.width = im_props.width;
ref.im_props.align_chan = align_chan;

im = im(:,:,align_chan:ref.im_props.nchans:end);

ref.base_images = cell(ref.im_props.numPlanes,1);

for ij = 1:ref.im_props.numPlanes
	im_stack_raw = im(:,:,ij:im_props.numPlanes:end);
	num_ims = size(im_stack_raw,3);
	num_heirarch = floor(log2(num_ims));
	im_stack_raw = im_stack_raw(:,:,1:2^num_heirarch);
	% heirarchical referencing method - reference pairs of adjacent frames
	% average them together and repeat until only one frame left - this is 
	% master image
	for ik = 1:num_heirarch
        fprintf('Plane %d of %d, stage %d of %d\n',ij,ref.im_props.numPlanes, ik, num_heirarch);
        num_ims = size(im_stack_raw,3);
		im_stack_tmp = zeros(size(im_stack_raw,1),size(im_stack_raw,2),num_ims/2,'uint16');
		for ih = 1:num_ims/2
			im_A = im_stack_raw(:,:,1+2*(ih-1));
			im_B = im_stack_raw(:,:,2+2*(ih-1));
			[corr_offset corr_2] = gcorr_fast(im_A,im_B);
			im_A_shift = func_im_shift(im_A,corr_offset);
			im_stack_tmp(:,:,ih) = (im_A_shift + im_B)/2;
		end
	im_stack_raw = im_stack_tmp;
	end
    
    ref.base_images{ij} = im_stack_raw;
end

% Save ref images
if save_opt == 1
	[pathstr,name,ext] = fileparts(base_im_path);
	ref_im_path = fullfile(pathstr,['ref_images_' name '.mat']);
	save(ref_im_path,'ref');
end

fprintf('DONE\n')