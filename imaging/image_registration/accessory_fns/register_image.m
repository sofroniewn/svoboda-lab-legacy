function [shift corr_2] = register_image(cur_im,ref_im)

[shift corr_2] = gcorr(cur_im, ref_im, size(cur_im,1));

