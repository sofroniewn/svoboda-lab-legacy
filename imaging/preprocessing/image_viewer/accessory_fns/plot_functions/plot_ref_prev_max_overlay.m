function [im_comb clim cmap_str] = plot_ref_prev_max_overlay(im_session,ref,trial_num,chan_num,plot_planes,clim,c_lim_overlay)

num_planes = length(plot_planes);
plane_rep = ceil(sqrt(num_planes));
im_comb = zeros(plane_rep*ref.im_props.height,plane_rep*ref.im_props.width,3);
cmap_str = 'gray';

for ij = 1:num_planes
	row_val = mod(ij-1,plane_rep);
	col_val = floor((ij-1)/plane_rep);
	start_x = 1 + row_val*ref.im_props.height;
	start_y = 1 + col_val*ref.im_props.height;
	if isfield(im_session,'prev_ref')
		im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1,1) = im_session.prev_ref.session_max_proj{plot_planes(ij)};
	end
	if isfield(im_session,'ref')
		im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1,2) = im_session.ref.session_max_proj{plot_planes(ij)};
        im_comb(start_y:start_y+ref.im_props.height-1,start_x:start_x+ref.im_props.width-1,3) = im_session.ref.session_max_proj{plot_planes(ij)};
	end
end

im_comb = im_comb - clim(1);
im_comb(:,:,1) = im_comb(:,:,1)/clim(2);
im_comb(:,:,2:3) = im_comb(:,:,2:3)/c_lim_overlay;
im_comb(im_comb>1) = 1;
im_comb(im_comb<0) = 0;

