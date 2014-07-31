function [im_comb clim cmap_str] = plot_spark_regression_stats(im_session,ref,trial_num,chan_num,plot_planes,clim,c_lim_overlay,streaming_mode)
  
num_planes = length(plot_planes);
plane_rep = ceil(sqrt(num_planes));
im_comb = zeros(plane_rep*ref.im_props.height,plane_rep*ref.im_props.width);
cmap_str = 'gray';

cur_ind = im_session.spark_output.regressor.cur_ind;
if ~streaming_mode
	im_array = im_session.spark_output.regressor.stats{cur_ind};
	im_array_tune = im_session.spark_output.regressor.tune{cur_ind};
	im_array_tune_var = im_session.spark_output.regressor.tune_var{cur_ind};
    cur_trial = 1;
else
    im_array = im_session.spark_output.streaming.stats{cur_ind};
	im_array_tune = im_session.spark_output.streaming.tune{cur_ind};
	im_array_tune_var = im_session.spark_output.streaming.tune_var{cur_ind};
    cur_trial = ceil((trial_num+.01)/(length(im_session.reg.nFrames)+.01)*size(im_session.spark_output.streaming.stats{cur_ind}{1},3));
end

if ~isempty(im_array{1,1})
for ij = 1:num_planes
	row_val = mod(ij-1,plane_rep);
	col_val = floor((ij-1)/plane_rep);
	start_x = 1 + row_val*ref.im_props.height;
	start_y = 1 + col_val*ref.im_props.height;
	im_use = im_array{plot_planes(ij),chan_num}(:,:,cur_trial);
   	if max(max(im_array_tune_var{plot_planes(ij),chan_num}(:,:,cur_trial)))~=0
    im_use = im_use.*(1-im_array_tune_var{plot_planes(ij),chan_num}(:,:,cur_trial)/max(max(im_array_tune_var{plot_planes(ij),chan_num}(:,:,cur_trial)))).^(c_lim_overlay/256);
    end
	im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1) = im_use;
end
end

clim = clim/10000;
