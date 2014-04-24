function [shift corr_2] = register_image_fast(cur_im,ref_im)

	[shift corr_2] = gcorr_mod_fast(cur_im, ref_im);
