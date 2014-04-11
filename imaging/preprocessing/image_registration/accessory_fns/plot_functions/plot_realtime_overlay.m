function im_comb = plot_realtime_overlay(plot_axes,im_session,trial_num,chan_num,plot_planes,clim,plot_on)

axes(plot_axes);
num_planes = length(plot_planes);
plane_rep = ceil(sqrt(num_planes));
im_comb = zeros(plane_rep*im_session.ref.im_props.height,plane_rep*im_session.ref.im_props.width,3);

for ij = 1:num_planes
	row_val = mod(ij-1,plane_rep);
	col_val = floor((ij-1)/plane_rep);
	start_x = 1 + row_val*im_session.ref.im_props.height;
	start_y = 1 + col_val*im_session.ref.im_props.height;
	im_comb(start_y:start_y+im_session.ref.im_props.height-1,start_x:start_x+im_session.ref.im_props.width-1,1) = im_session.ref.base_images{plot_planes(ij)};
	im_comb(start_y:start_y+im_session.ref.im_props.height-1,start_x:start_x+im_session.ref.im_props.width-1,2) = im_session.ref.base_images{plot_planes(ij)};
	
	if isempty(im_session.realtime.im_raw) ~= 1
		if im_session.realtime.start == 0
			im_use = squeeze(mean(im_session.realtime.im_raw(:,:,plot_planes(ij),1:im_session.realtime.ind),4));
		else
			im_use = squeeze(mean(im_session.realtime.im_raw(:,:,plot_planes(ij),:),4));			
		end
		im_comb(start_y:start_y+im_session.ref.im_props.height-1,start_x:start_x+im_session.ref.im_props.width-1,3) = im_use;
	end
end

if plot_on == 1
	im_comb = (im_comb - clim(1))/clim(2);
	imshow(im_comb)	
	set(gca,'xtick',[])
	set(gca,'ytick',[])
end

end