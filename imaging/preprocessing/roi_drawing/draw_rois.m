function draw_rois(overwrite)

global im_session

if isfield(im_session.ref,'roi_array') == 0 || overwrite == 1;
	im_session.ref.roi_array = cell(im_session.ref.im_props.numPlanes,1);
	for ij = 1:im_session.ref.im_props.numPlanes
		im_session.ref.roi_array{ij} = roi.roiArray();
		im_session.ref.roi_array{ij}.masterImage = single(im_session.ref.base_images{ij});
		im_session.ref.roi_array{ij}.roiIdRange = [1 10000] + 10000*(ij-1);
		im_session.ref.roi_array{ij}.settings.selectedColor = [1 .5 0];
		im_session.ref.roi_array{plot_planes}.workingImageSettings.pixelRange = {['[' num2str(0) ' ' num2str(1) ']']};
		%im_session.ref.roi_array{ij}.workingImageMouseClickFunction = {@axes_images_ButtonDownFcn};
		%im_session.ref.roi_array{ij}.workingImageMouseClickFunction = {@figure1_KeyPressFcn};
		%im_session.ref.roi_array{ij}.workingImageMouseClickFunction = {@obj.guiMouseClickProcessor};
		%im_session.ref.roi_array{ij}.workingImageKeyPressFunction = {@obj.guiKeyStrokeProcessor};
	end
else
	for ij = 1:im_session.ref.im_props.numPlanes
		im_session.ref.roi_array{ij}.masterImage = single(im_session.ref.base_images{ij});
		im_session.ref.roi_array{ij}.settings.selectedColor = [1 .5 0];
		im_session.ref.roi_array{ij}.workingImageSettings.pixelRange = {['[' num2str(0) ' ' num2str(1) ']']};
	end
end
