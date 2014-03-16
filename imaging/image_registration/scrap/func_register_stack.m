function [im_register corr_offset] = func_register_stack(im_stack,fft_target)
% Register stack

%
num_frames = size(im_stack,3);
im_size = [size(im_stack,1) size(im_stack,2)];
corr_offset = NaN(num_frames,2);
im_register = NaN(size(im_stack));

for ij = 1:num_frames
    corr_offset(ij,:) = gcorr_fast(im_stack(:,:,ij),fft_target,im_size);
 	im_register(:,:,ij) = func_im_shift(im_stack(:,:,ij),corr_offset(ij,:));
end
