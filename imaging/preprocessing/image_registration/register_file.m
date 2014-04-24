function [im_shifted shifts] = register_file(im_raw,ref)


num_planes = ref.im_props.numPlanes;
num_chan = ref.im_props.nchans;
align_chan = ref.im_props.align_chan;
num_frames = size(im_raw,3)/num_chan;

%display('Computing shifts')
%tic
% compute shifts
shifts = zeros(num_frames,2);
for ij = 1:num_frames
    plane = mod(ij-1,num_planes)+1;
    cur_im = im_raw(:,:,align_chan + (ij-1)*num_chan);
    ref_im = ref.post_fft{plane};
    [shifts(ij,:) corr_vals] = register_image_fast(cur_im,ref_im);
end
%toc

%display('Shifting images')
%tic
% shift images
im_shifted = zeros(size(im_raw),'uint16');
%	im_raw = uint16(im_raw);
for ij = 1:size(im_raw,3)
    ind = floor((ij-1)/num_chan)+1;
    im_shifted(:,:,ij) = func_im_shift(im_raw(:,:,ij),shifts(ind,:));
end
%toc

end