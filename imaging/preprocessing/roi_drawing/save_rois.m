function save_rois(file_name_tag)

global im_session

if isfield(im_session.ref,'roi_array') == 1
% post process ROIs and then save
num_planes = im_session.ref.im_props.numPlanes;
for ij = 1:num_planes
		im_session.ref.roi_array{ij}.resolveOverlaps('com');
end
roi_array = im_session.ref.roi_array;
save(fullfile(im_session.ref.path_name,['ROIs_' file_name_tag '.mat']),'roi_array')
im_session.ref.roi_array_fname = fullfile(im_session.ref.path_name,['ROIs_' file_name_tag '.mat']);
neuropilDilationRange = [3 8];
processedRoi = generate_roi_indices(roi_array,neuropilDilationRange,im_session.ref.roi_array_fname,1);

display('ROIs saved')
end