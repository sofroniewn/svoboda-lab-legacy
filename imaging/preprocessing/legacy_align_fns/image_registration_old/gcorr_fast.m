function [corr_offset corr_2] = gcorr_fast( A, B, im_size)
%GCORR Summary of this function goes here
%   Detailed explanation goes here
% Pad fft by 2, use pre fft ref image, don't take abs of cross corr

corr_2 = (ifft2(fft2(padarray(A,[im_size,im_size],'post')).*B));
[max_cc, imax] = max(corr_2(:));
[ypeak, xpeak] = ind2sub(size(corr_2),imax);
corr_offset = [ (ypeak-size(A,1)) (xpeak-size(A,2)) ];

end

