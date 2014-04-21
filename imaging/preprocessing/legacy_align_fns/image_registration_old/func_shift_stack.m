function shifts_raw = func_shift_stack(x,im_raw,align_chan,num_chan,num_planes,post_fft)

		plane = mod(x-1,num_planes)+1;
		cur_im = im_raw(:,:,align_chan+(x-1)*num_chan);
		shifts_raw = register_image_fast(cur_im,post_fft{plane});
shifts_raw = shifts_raw(1);