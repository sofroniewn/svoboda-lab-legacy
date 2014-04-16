function im_adj = func_im_shift(im,corr_offset)

%%
im_adj = zeros(size(im),'uint16');
size_im_x = size(im,1);
size_im_y = size(im,2);
corr_offset = -corr_offset;

if corr_offset(1) > 0 && corr_offset(2) > 0
    im_adj(1+corr_offset(1):size_im_x,1+corr_offset(2):size_im_y) = im(1:size_im_x-corr_offset(1),1:size_im_y-corr_offset(2));
elseif corr_offset(1) <= 0 && corr_offset(2) > 0
    im_adj(1:size_im_x+corr_offset(1),1+corr_offset(2):size_im_y) = im(1-corr_offset(1):size_im_x,1:size_im_y-corr_offset(2));
elseif corr_offset(1) <= 0 && corr_offset(2) <= 0
    im_adj(1:size_im_x+corr_offset(1),1:size_im_y+corr_offset(2)) = im(1-corr_offset(1):size_im_x,1-corr_offset(2):size_im_y);
else
    im_adj(1+corr_offset(1):size_im_x,1:size_im_y+corr_offset(2)) = im(1:size_im_x-corr_offset(1),1-corr_offset(2):size_im_y);
end


