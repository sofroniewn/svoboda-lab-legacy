function save_rois_scratch

global im_session

plot_planes = [1:im_session.ref.im_props.numPlanes];
num_planes = im_session.ref.im_props.numPlanes;
plane_rep = ceil(sqrt(num_planes));
im_comb = zeros(plane_rep*im_session.ref.im_props.height,plane_rep*im_session.ref.im_props.width,3);

figure(10);
clf(10)

for ij = 1:num_planes
	if isempty(im_session.ref.roi_array{ij}.guiHandles)~=1
		if ishandle(im_session.ref.roi_array{ij}.guiHandles(3))
			close(im_session.ref.roi_array{ij}.guiHandles(3));
		end
	end

	im_session.ref.roi_array{ij}.resolveOverlaps('com');
	im_use = generateImage(im_session.ref.roi_array{ij}, 1, 1, 0);

	row_val = mod(ij-1,plane_rep);
	col_val = floor((ij-1)/plane_rep);
	start_x = 1 + row_val*im_session.ref.im_props.height;
	start_y = 1 + col_val*im_session.ref.im_props.height;
	im_comb(start_y:start_y+im_session.ref.im_props.height-1,start_x:start_x+im_session.ref.im_props.width-1,:) = im_use;
end

clim = [0 500];
imagesc(im_comb,clim)	
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 im_session.ref.im_props.height im_session.ref.im_props.width])

	

