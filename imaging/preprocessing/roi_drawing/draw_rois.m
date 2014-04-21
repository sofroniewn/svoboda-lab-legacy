function draw_rois(cur_plane,overwrite,clim)

global im_session


if isfield(im_session.ref,'roi_array') == 0 || overwrite == 1;
	im_session.ref.roi_array = cell(im_session.ref.im_props.numPlanes,1);
	for ij = 1:im_session.ref.im_props.numPlanes
		im_session.ref.roi_array{ij} = roi.roiArray();
		im_session.ref.roi_array{ij}.workingImage = single(im_session.ref.base_images{ij});
		im_session.ref.roi_array{ij}.baseWorkingImage = single(im_session.ref.base_images{ij});
		im_session.ref.roi_array{ij}.workingImageSettings.pixelRange = {['[' num2str(clim(1)) ' ' num2str(clim(2)) ']']};
		im_session.ref.roi_array{ij}.masterImage = single(im_session.ref.base_images{ij});
		im_session.ref.roi_array{ij}.roiIdRange = [1 10000] + 10000*(ij-1);
		im_session.ref.roi_array{ij}.settings.selectedColor = [1 .5 0];

	end
else
	for ij = 1:im_session.ref.im_props.numPlanes
		im_session.ref.roi_array{ij}.workingImage = single(im_session.ref.base_images{ij});
		im_session.ref.roi_array{ij}.baseWorkingImage = single(im_session.ref.base_images{ij});
		im_session.ref.roi_array{ij}.masterImage = single(im_session.ref.base_images{ij});
	end
end

if ~isempty(im_session.reg.align_mean) %isfield(im_session,'reg')
	if isempty(im_session.ref.roi_array{ij}.permanentAccessoryImages)
		for ij = 1:im_session.ref.im_props.numPlanes
			for ik = 1:im_session.ref.im_props.nchans
				AccessoryIm = max(single(im_session.reg.align_mean(:,:,ij,ik,:)),[],5);
				im_session.ref.roi_array{ij}.addAccessoryImage(AccessoryIm, ['Max proj chan ' num2str(ik)]);
				AccessoryIm = mean(single(im_session.reg.align_mean(:,:,ij,ik,:)),5);
				im_session.ref.roi_array{ij}.addAccessoryImage(AccessoryIm, ['Mean chan ' num2str(ik)]);
			end
			align_chan = im_session.ref.im_props.align_chan;
			AccessoryIm = squeeze(single(im_session.reg.align_mean(:,:,ij,align_chan,:)));
			im_session.ref.roi_array{ij}.addAccessoryImage(AccessoryIm, 'Trial averages');
			im_session.ref.roi_array{ij}.masterImage = single(im_session.ref.base_images{ij});
		end
	end
end

if isempty(im_session.ref.roi_array{cur_plane}.guiHandles)~=1
	if ishandle(im_session.ref.roi_array{cur_plane}.guiHandles(3))
		close(im_session.ref.roi_array{cur_plane}.guiHandles(3));
	end
		im_session.ref.roi_array{cur_plane}.guiHandles = [];
end

im_session.ref.roi_array{cur_plane}.workingImageSettings.pixelRange = {['[' num2str(clim(1)) ' ' num2str(clim(2)) ']']};
im_session.ref.roi_array{cur_plane}.settings.selectedColor = [1 .5 0];


im_session.ref.roi_array{cur_plane}.startGui;
