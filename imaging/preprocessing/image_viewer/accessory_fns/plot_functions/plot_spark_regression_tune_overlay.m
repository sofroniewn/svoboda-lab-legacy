function [im_comb clim cmap_str] = plot_spark_regression_tune_overlay(im_session,ref,trial_num,chan_num,plot_planes,clim,c_lim_overlay,streaming_mode)


num_planes = length(plot_planes);
plane_rep = ceil(sqrt(num_planes));
im_comb = zeros(plane_rep*ref.im_props.height,plane_rep*ref.im_props.width,3);
cmap_str = 'jet';

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
    %cur_trial = ceil((trial_num+.01)/(length(im_session.reg.nFrames)+.01)*size(im_session.spark_output.streaming.stats{cur_ind}{1},3));
    cur_trial = trial_num;
end

range_val = im_session.spark_output.regressor.range{cur_ind};

if ~isempty(im_array) && ~isempty(im_array_tune)
if ~isempty(im_array{1,1}) && ~isempty(im_array_tune{1,1}) && ~isempty(im_session.spark_output.mean) && cur_trial > 0
for ij = 1:num_planes
	row_val = mod(ij-1,plane_rep);
	col_val = floor((ij-1)/plane_rep);
	start_x = 1 + row_val*ref.im_props.height;
	start_y = 1 + col_val*ref.im_props.height;
	
    r = im_array{plot_planes(ij),chan_num}(:,:,cur_trial);
    if max(max(im_array_tune_var{plot_planes(ij),chan_num}(:,:,cur_trial)))~=0
        r = r.*(1-im_array_tune_var{plot_planes(ij),chan_num}(:,:,cur_trial)/max(max(im_array_tune_var{plot_planes(ij),chan_num}(:,:,cur_trial)))).^(clim(1)/256);
    end
    r = (r - clim(1)/10000)/clim(2)*10000;
	
    tune = im_array_tune{plot_planes(ij),chan_num}(:,:,cur_trial);
	tune = (tune - min(range_val))/(max(range_val) - min(range_val));
   
    tmp = jet(clip(tune,0,1));
    %tmp(:,:,2) = 0;
    tmp = rgb2hsv(tmp);
    oim(:,:,1) = tmp(:,:,1);
    oim(:,:,2) = 1;
    oim(:,:,3) = clip(r);
    im_use = hsv2rgb(oim);

    im_use_mean = im_session.spark_output.mean{plot_planes(ij),chan_num};
    im_use_mean = im_use_mean/c_lim_overlay;

    im_use_mean(im_use_mean>1) = 1;
    im_use_mean(im_use_mean<0) = 0;
    scale = r;
    scale(scale>.4) = .4;
    scale = scale*1/.4;
    scale(scale<0) = 0;
    im_use_mean = im_use_mean.*(1-scale);

%im_use_mean = adapthisteq(im_use_mean);

    im_use_mean = repmat(im_use_mean,[1 1 3]);
	im_use = im_use + im_use_mean;
    im_use(im_use>1) = 1;
    im_use(im_use<0) = 0;
    
	im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1,:) = im_use;
end
end
end

clim = [min(range_val) max(range_val)];
