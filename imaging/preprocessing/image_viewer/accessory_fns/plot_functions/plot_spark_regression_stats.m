function [im_comb clim] = plot_spark_regression_stats(plot_axes,cbar_axes,im_session,ref,trial_num,chan_num,plot_planes,clim,c_lim_overlay,plot_on)

axes(plot_axes);
colormap(gca,'gray');
    
num_planes = length(plot_planes);
plane_rep = ceil(sqrt(num_planes));
im_comb = zeros(plane_rep*ref.im_props.height,plane_rep*ref.im_props.width);

cur_ind = im_session.spark_output.regressor.cur_ind;
im_array = im_session.spark_output.regressor.stats{cur_ind};
if ~isempty(im_array)
for ij = 1:num_planes
	row_val = mod(ij-1,plane_rep);
	col_val = floor((ij-1)/plane_rep);
	start_x = 1 + row_val*ref.im_props.height;
	start_y = 1 + col_val*ref.im_props.height;
	im_use = im_array{plot_planes(ij),chan_num};
	im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1) = im_use;
end
end

clim = clim/10000;

if ~isempty(cbar_axes)
end


if plot_on == 1
	imagesc(im_comb,clim)
	set(gca,'xtick',[])
	set(gca,'ytick',[])
    axis equal
end

end