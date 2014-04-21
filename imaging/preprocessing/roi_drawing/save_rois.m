function save_rois(file_name_tag)

global im_session

if isfield(im_session.ref,'roi_array') == 1
% post process ROIs and then save
num_planes = im_session.ref.im_props.numPlanes;
for ij = 1:num_planes
	if isempty(im_session.ref.roi_array{ij}.guiHandles)~=1
		if ishandle(im_session.ref.roi_array{ij}.guiHandles(3))
			close(im_session.ref.roi_array{ij}.guiHandles(3));
		end
	end
	im_session.ref.roi_array{ij}.resolveOverlaps('com');
end

roi_array = im_session.ref.roi_array;
for ij = 1:num_planes
	if ~isempty(roi_array{ij}.permanentAccessoryImages)
		roi_array{ij}.permanentAccessoryImages = {};
		roi_array{ij}.accessoryImagesRelPaths = {};
		roi_array{ij}.accessoryImageProps = [];
	end
end

save(fullfile(im_session.ref.path_name,['ROIs_' file_name_tag '.mat']),'roi_array')

display('ROIs saved')
end