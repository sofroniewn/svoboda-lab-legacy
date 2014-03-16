function [corr_offset] = gcorr_fast_v2(cur_im, fft_target, im_size)
%GCORR Summary of this function goes here
%   Detailed explanation goes here

corr_2 = ifftn(fft(fft(cur_im,im_size(2)*2,2),im_size(1)*2,1).*fft_target,'symmetric');
[max_cc, imax] = max(abs(corr_2(:)));
[ypeak, xpeak] = ind2sub(size(corr_2),imax(1));
corr_offset = [(ypeak-im_size(2)) (xpeak-im_size(1))];

end

