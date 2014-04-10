function roi_mask = automated_roi_njs(cords,roi_params,im_stack)

	width_cord = 205;
	height_cord = 340;
	cords = [height_cord width_cord];
	roi_params.min_radii = 0;
	roi_params.max_radii = 4;
	roi_params.max_search = 15;
	roi_params.thresh = .1;

	im_stack = squeeze(im_session.reg.align_mean(:,:,1,1,:));
	im_avg = mean(im_stack,3);

	%figure; imshow(im_avg/500);

mask_large = make_circle(size(im_stack,1),size(im_stack,2),cords(2),cords(1),roi_params.max_radii);
mask_small = make_circle(size(im_stack,1),size(im_stack,2),cords(2),cords(1),roi_params.min_radii);

mask = mask_large &~mask_small;



mean_cell = zeros(size(im_stack,3),1);

for ij = 1:size(im_stack,3)
	tmp_mat = im_stack(:,:,ij);
	mean_cell(ij) = mean(tmp_mat(mask));
end


im_avg_mask = im_avg;
im_avg_mask(mask) = 0;

figure; imshow(im_avg_mask/500)

figure; plot(mean_cell)

corr_grid = zeros(2*roi_params.max_search+1);
base_im = zeros(2*roi_params.max_search+1);

for disp_x = -roi_params.max_search:roi_params.max_search;
	for disp_y = -roi_params.max_search:roi_params.max_search;

	cords_use = cords + [disp_y disp_x];
	tmp_vals = double(squeeze((im_stack(cords_use(1),cords_use(2),:))));
	base_im(roi_params.max_search+1+disp_y,roi_params.max_search+1+disp_x) = mean(tmp_vals);
	%tmp_vals = tmp_vals - mean(tmp_vals);
	mean_cell_adj = mean_cell ;%- mean(mean_cell);
	
	corr_grid(roi_params.max_search+1+disp_y,roi_params.max_search+1+disp_x) = corr(mean_cell_adj,tmp_vals);

	end
end

figure(2); 
imshow(corr_grid)
figure(3); 
imshow(base_im/500)

overlay = zeros(size(base_im,1),size(base_im,2),3);
overlay(:,:,1) = base_im/500;
overlay(:,:,2) = base_im/500;
overlay(:,:,3) = corr_grid_imposed;


figure(4); imshow(overlay)


se = strel('disk', 3);

I = imerode(corr_grid,se);
corr_grid_imposed = corr_grid;

level = graythresh(I);
BW = im2bw(I,level);

corr_grid_imposed(BW) = 0;

figure(2)
imshow(corr_grid)

DL = watershed(corr_grid_imposed);
label = DL((size(base_im,1)+1)/2,(size(base_im,2)+1)/2);

BW_mask = DL==label;

figure(2)
imshow(BW_mask)

imshow(medfilt2(corr_grid,[2 2]))

I = imtophat(corr_grid,se);

obr = imreconstruct(double(BW_mask),corr_grid);

BW = imextendedmin(corr_grid,.2);

BW = zeros(size(corr_grid));
BW((size(base_im,1)+1)/2,(size(base_im,2)+1)/2) = 1;

I2 = imimposemin(1-corr_grid,BW);


figure; 
hold on
plot(mean_cell)
plot(tmp_vals,'r')




