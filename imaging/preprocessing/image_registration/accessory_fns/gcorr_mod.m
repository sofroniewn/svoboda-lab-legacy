function [corr_offset corr_2] = gcorr_mod( A, B, im_size)
%GCORR Summary of this function goes here
%   Detailed explanation goes here

B = fliplr(B);
B = flipud(B);
corr_2 = ifft2(fft2(A).*(fft2(B)));

[max_cc, imax] = max(abs(corr_2(:)));
[ypeak, xpeak] = ind2sub(size(corr_2),imax(1));
corr_offset = [ (ypeak-size(A,1)) (xpeak-size(A,2)) ];

end

