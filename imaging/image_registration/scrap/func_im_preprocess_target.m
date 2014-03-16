function [fft_target] = func_im_preprocess_target(im_target)
%func_im_preprocess_target
%   Pre process target image for fft based image registration

im_target = fliplr(im_target);
im_target = flipud(im_target);
fft_target = fft(fft(im_target,size(im_target,2)*2,2),size(im_target,1)*2,1);

end

