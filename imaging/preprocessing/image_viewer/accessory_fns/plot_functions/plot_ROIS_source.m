function [im_comb clim cmap_str] = plot_ROIS_source(im_session,ref,trial_num,chan_num,plot_planes,clim,c_lim_overlay)

num_planes = length(plot_planes);
plane_rep = ceil(sqrt(num_planes));
im_comb = zeros(plane_rep*ref.im_props.height,plane_rep*ref.im_props.width,3);
cmap_str = 'gray';

for ij = 1:num_planes
	row_val = mod(ij-1,plane_rep);
	col_val = floor((ij-1)/plane_rep);
	start_x = 1 + row_val*ref.im_props.height;
	start_y = 1 + col_val*ref.im_props.height;
	if isfield(im_session.ref,'roi_array_source') == 1
		if isempty(ref.roi_array_source{plot_planes(ij)}.guiHandles)~=1
			if ishandle(ref.roi_array_source{plot_planes(ij)}.guiHandles(3))
				close(ref.roi_array_source{plot_planes(ij)}.guiHandles(3));
			end
			ref.roi_array_source{plot_planes(ij)}.guiHandles = [];
		end
		ref.roi_array_source{plot_planes(ij)}.workingImageSettings.pixelRange = {['[' num2str(clim(1)) ' ' num2str(clim(2)) ']']};
		im_use = generateImage(ref.roi_array_source{plot_planes(ij)}, 1, 1, 0);
	else
		im_use = zeros(ref.im_props.height,ref.im_props.width,3);
	end
	im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1,:) = im_use;
end

