function [corr_offset corr_2] = gcorr_fast( A, B)
%GCORR Summary of this function goes here
%   Detailed explanation goes here

n = size(A,1);
m = size(A,2);

B = fliplr(B);
B = flipud(B);
corr_2 = ifft2(fft2(A).*fft2(B);
[max_cc, imax] = max(corr_2(:));
[rloc, cloc] = ind2sub(size(corr_2),imax);

    md2 = floor(m/2); 
    nd2 = floor(n/2);
    if rloc > md2
        row_shift = rloc - m;
    else
        row_shift = rloc;
    end

    if cloc > nd2
        col_shift = cloc - n;
    else
        col_shift = cloc;
    end

	corr_offset = [row_shift col_shift];


end

