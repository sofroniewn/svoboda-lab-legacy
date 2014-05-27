function [im_comb clim cmap_str] = plot_trial_mean_aligned(im_session,ref,trial_num,chan_num,plot_planes,clim,c_lim_overlay,streaming_mode)

num_planes = length(plot_planes);
plane_rep = ceil(sqrt(num_planes));
im_comb = zeros(plane_rep*ref.im_props.height,plane_rep*ref.im_props.width);
cmap_str = 'gray';

for ij = 1:num_planes
	row_val = mod(ij-1,plane_rep);
	col_val = floor((ij-1)/plane_rep);
	start_x = 1 + row_val*ref.im_props.height;
	start_y = 1 + col_val*ref.im_props.height;
	if trial_num > 0
		im_use = squeeze(im_session.reg.align_mean(:,:,plot_planes(ij),chan_num,trial_num));
	else
		im_use = ref.base_images{plot_planes(ij)};
	end
	im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1) = im_use;
end
