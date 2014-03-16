function [ corr_offset ] = gcorr_fast(A, B, im_size)
%GCORR Summary of this function goes here
%   Detailed explanation goes here

corr_2 = ifft2(fft2(padarray(A,im_size,'post')).*B);

[max_cc, imax] = max(abs(corr_2(:)));
[ypeak, xpeak] = ind2sub(size(corr_2),imax(1));
corr_offset = [ (ypeak-size(A,1)) (xpeak-size(A,2)) ];

end

