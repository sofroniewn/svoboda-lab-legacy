function [shift corr_2] = register_image_fast(cur_im,ref_im)

	[shift corr_2] = gcorr_fast(cur_im, ref_im, size(cur_im,1));
