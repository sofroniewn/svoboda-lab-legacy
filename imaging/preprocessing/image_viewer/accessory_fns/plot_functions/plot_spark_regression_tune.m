function im_comb = plot_spark_regression_tune(plot_axes,im_session,trial_num,chan_num,plot_planes,clim,plot_on)

axes(plot_axes);
num_planes = length(plot_planes);
plane_rep = ceil(sqrt(num_planes));
im_comb = zeros(plane_rep*im_session.ref.im_props.height,plane_rep*im_session.ref.im_props.width,3);

cur_ind = im_session.spark_output.regressor.cur_ind;
im_array = im_session.spark_output.regressor.stats{cur_ind};
im_array_tune = im_session.spark_output.regressor.tune{cur_ind};
vals = im_session.spark_output.regressor.vals{cur_ind};

if ~isempty(im_array) && ~isempty(im_array_tune)
for ij = 1:num_planes
	row_val = mod(ij-1,plane_rep);
	col_val = floor((ij-1)/plane_rep);
	start_x = 1 + row_val*im_session.ref.im_props.height;
	start_y = 1 + col_val*im_session.ref.im_props.height;
	
    r = im_array{plot_planes(ij),chan_num};
	r = (r - clim(1)/10000)/clim(2)*10000;
	
    tune = im_array_tune{plot_planes(ij),chan_num};
	tune = (tune - min(vals))/(max(vals) - min(vals));
    
    tmp = rgb2hsv(jet(clip(tune,0,1)));
    oim(:,:,1) = tmp(:,:,1);
    oim(:,:,2) = 1;
    oim(:,:,3) = clip(r);
    im_use = hsv2rgb(oim);

    
	im_comb(start_y:start_y+im_session.ref.im_props.height-1,start_x:start_x+im_session.ref.im_props.width-1,:) = im_use;
end
end

if plot_on == 1
    subimage(im_comb);
    colormap(gca,'jet');
	set(gca,'xtick',[])
	set(gca,'ytick',[])
end

end