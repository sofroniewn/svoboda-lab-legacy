function [im_comb clim cmap_str] = plot_spark_regression_tune(im_session,ref,trial_num,chan_num,plot_planes,clim,c_lim_overlay,streaming_mode)


num_planes = length(plot_planes);
plane_rep = ceil(sqrt(num_planes));
im_comb = zeros(plane_rep*ref.im_props.height,plane_rep*ref.im_props.width,3);
cmap_str = 'jet';

cur_ind = im_session.spark_output.regressor.cur_ind;
if ~streaming_mode
	im_array = im_session.spark_output.regressor.stats{cur_ind};
	im_array_tune = im_session.spark_output.regressor.tune{cur_ind};
else
	im_array = im_session.spark_output.streaming.stats{cur_ind};
	im_array_tune = im_session.spark_output.streaming.tune{cur_ind};
end
range_val = im_session.spark_output.regressor.range{cur_ind};

if ~isempty(im_array) && ~isempty(im_array_tune)
for ij = 1:num_planes
	row_val = mod(ij-1,plane_rep);
	col_val = floor((ij-1)/plane_rep);
	start_x = 1 + row_val*ref.im_props.height;
	start_y = 1 + col_val*ref.im_props.height;
	
    r = im_array{plot_planes(ij),chan_num};
	r = (r - clim(1)/10000)/clim(2)*10000;
	
    tune = im_array_tune{plot_planes(ij),chan_num};
	tune = (tune - min(range_val))/(max(range_val) - min(range_val));
    
    tmp = rgb2hsv(jet(clip(tune,0,1)));
    oim(:,:,1) = tmp(:,:,1);
    oim(:,:,2) = 1;
    oim(:,:,3) = clip(r);
    im_use = hsv2rgb(oim);

    
	im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1,:) = im_use;
end
end

clim = [min(range_val) max(range_val)];
