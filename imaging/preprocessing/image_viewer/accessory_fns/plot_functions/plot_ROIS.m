function [im_comb clim cmap_str] = plot_ROIS(im_session,ref,trial_num,chan_num,plot_planes,clim,c_lim_overlay)

num_planes = length(plot_planes);
plane_rep = ceil(sqrt(num_planes));
im_comb = zeros(plane_rep*ref.im_props.height,plane_rep*ref.im_props.width,3);
cmap_str = 'gray';

for ij = 1:num_planes
	row_val = mod(ij-1,plane_rep);
	col_val = floor((ij-1)/plane_rep);
	start_x = 1 + row_val*ref.im_props.height;
	start_y = 1 + col_val*ref.im_props.height;
	if isfield(im_session.ref,'roi_array') == 1
		if isempty(ref.roi_array{plot_planes(ij)}.guiHandles)~=1
			if ishandle(ref.roi_array{plot_planes(ij)}.guiHandles(3))
				close(ref.roi_array{plot_planes(ij)}.guiHandles(3));
			end
			ref.roi_array{plot_planes(ij)}.guiHandles = [];
		end
		im_data = (ref.base_images{plot_planes(ij)} - clim(1))/clim(2);
        im_data(im_data>1) = 1;
        im_data(im_data<0) = 0;
        ref.roi_array{plot_planes(ij)}.workingImage = im_data;
        im_use = generateImage(ref.roi_array{plot_planes(ij)}, 1, 1, 0);
		im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1,:) = im_use;
	end
end

