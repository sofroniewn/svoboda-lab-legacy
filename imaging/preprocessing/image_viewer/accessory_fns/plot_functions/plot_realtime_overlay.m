function [im_comb clim] = plot_realtime_overlay(plot_axes,cbar_axes,im_session,ref,trial_num,chan_num,plot_planes,clim,c_lim_overlay,plot_on)

num_planes = length(plot_planes);
plane_rep = ceil(sqrt(num_planes));
im_comb = zeros(plane_rep*ref.im_props.height,plane_rep*ref.im_props.width,3);

for ij = 1:num_planes
	row_val = mod(ij-1,plane_rep);
	col_val = floor((ij-1)/plane_rep);
	start_x = 1 + row_val*ref.im_props.height;
	start_y = 1 + col_val*ref.im_props.height;
	im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1,1) = ref.base_images{plot_planes(ij)};	
	if isempty(im_session.realtime.im_raw) ~= 1
		if im_session.realtime.start == 0
			im_use = squeeze(mean(im_session.realtime.im_raw(:,:,plot_planes(ij),1:im_session.realtime.ind),4));
		else
			im_use = squeeze(mean(im_session.realtime.im_raw(:,:,plot_planes(ij),:),4));			
		end
		im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1,2) = im_use;
		im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1,3) = im_use;
	end
end

im_comb = im_comb - clim(1);
im_comb(:,:,1) = im_comb(:,:,1)/clim(2);
im_comb(:,:,2:3) = im_comb(:,:,2:3)/c_lim_overlay;
im_comb(im_comb>1) = 1;
im_comb(im_comb<0) = 0;

if plot_on == 1
	axes(plot_axes);
	colormap(gca,'gray');
	imagesc(im_comb,clim)	
	set(gca,'xtick',[])
	set(gca,'ytick',[])
    axis equal
end

end