function corr_grid = automated_roi_njs(height_cord,width_cord,min_radii,max_radii,max_search,im_stack)

mask_large = make_circle(size(im_stack,1),size(im_stack,2),width_cord,height_cord,max_radii);
mask_small = make_circle(size(im_stack,1),size(im_stack,2),width_cord,height_cord,min_radii);
mask = mask_large &~mask_small;

mean_cell = zeros(size(im_stack,3),1);
for ij = 1:size(im_stack,3)
	tmp_mat = im_stack(:,:,ij);
	mean_cell(ij) = mean(tmp_mat(mask));
end

corr_grid = zeros(size(im_stack,1),size(im_stack,2));
for disp_x = -max_search:max_search;
	for disp_y = -max_search:max_search;
		if height_cord+disp_y > 0 && height_cord+disp_y <= size(im_stack,1) && width_cord+disp_x > 0 && width_cord+disp_x <= size(im_stack,2) 
			tmp_vals = double(squeeze((im_stack(height_cord+disp_y,width_cord+disp_x,:))));
			corr_grid(height_cord+disp_y,width_cord+disp_x) = corr(mean_cell,tmp_vals);
		end
	end
end
