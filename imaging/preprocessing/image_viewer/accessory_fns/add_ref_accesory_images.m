function ref = add_ref_accesory_images(data_dir,ref)

	if exist(fullfile(data_dir,'ref_means.mat')) == 2
        load(fullfile(data_dir,'ref_means.mat'));
		ref.session_mean = session_mean_images;
		ref.session_max_proj = session_max_proj_images;
	else		
		ref.session_mean = cell(ref.im_props.numPlanes,ref.im_props.nchans);
		ref.session_max_proj = cell(ref.im_props.numPlanes,ref.im_props.nchans);
		for ih = 1:ref.im_props.nchans
            for ik = 1:ref.im_props.numPlanes
            	if ih == ref.im_props.align_chan
                	ref.session_mean{ik,ih} = ref.base_images{ik};
                	ref.session_max_proj{ik,ih} = ref.base_images{ik};
            	else
            		ref.session_mean{ik,ih} = zeros(ref.im_props.height,ref.im_props.width,'uint16');
                	ref.session_max_proj{ik,ih} = zeros(ref.im_props.height,ref.im_props.width,'uint16');	
            	end
            end
        end
	end