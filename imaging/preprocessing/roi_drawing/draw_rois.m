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
		%im_session.ref.roi_array{ij}.workingImageMouseClickFunction = {@axes_images_ButtonDownFcn};
		%im_session.ref.roi_array{ij}.workingImageMouseClickFunction = {@figure1_KeyPressFcn};
		%im_session.ref.roi_array{ij}.workingImageMouseClickFunction = {@obj.guiMouseClickProcessor};
		%im_session.ref.roi_array{ij}.workingImageKeyPressFunction = {@obj.guiKeyStrokeProcessor};

	end
else
	for ij = 1:im_session.ref.im_props.numPlanes
		im_session.ref.roi_array{ij}.workingImage = single(im_session.ref.base_images{ij});
		im_session.ref.roi_array{ij}.baseWorkingImage = single(im_session.ref.base_images{ij});
		im_session.ref.roi_array{ij}.masterImage = single(im_session.ref.base_images{ij});
	end
end

if isempty(im_session.ref.roi_array{ij}.permanentAccessoryImages)
	if ~isempty(im_session.reg.align_mean) %isfield(im_session,'reg')
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
	if ~isempty(im_session.spark_output.mean) %isfield(im_session,'reg')
		for ij = 1:im_session.ref.im_props.numPlanes
			for ik = 1:im_session.ref.im_props.nchans
				AccessoryIm = single(im_session.spark_output.mean{ij,ik});
				im_session.ref.roi_array{ij}.addAccessoryImage(AccessoryIm, ['Spark mean chan']);
			end
		end
	end
	if ~isempty(im_session.spark_output.localcorr) %isfield(im_session,'reg')
		for ij = 1:im_session.ref.im_props.numPlanes
			for ik = 1:im_session.ref.im_props.nchans
				AccessoryIm = single(im_session.spark_output.localcorr{ij,ik})*1000;
				im_session.ref.roi_array{ij}.addAccessoryImage(AccessoryIm, ['Spark local corr']);
			end
		end
	end
	for ih = 1:numel(im_session.spark_output.regressor.stats)
		if ~isempty(im_session.spark_output.regressor.stats{ih}) %isfield(im_session,'reg')
			for ij = 1:im_session.ref.im_props.numPlanes
				for ik = 1:im_session.ref.im_props.nchans
					AccessoryIm = single(im_session.spark_output.regressor.stats{ih}{ij,ik})*10000;
					im_session.ref.roi_array{ij}.addAccessoryImage(AccessoryIm, ['Spark regression ' im_session.spark_output.regressor.names{ih}]);
				end
			end
		end
	end
end

if isempty(im_session.ref.roi_array{cur_plane}.guiHandles)~=1
	if ishandle(im_session.ref.roi_array{cur_plane}.guiHandles(3))
		%close(im_session.ref.roi_array{cur_plane}.guiHandles(3));
	end
		im_session.ref.roi_array{cur_plane}.guiHandles = [];
end

im_session.ref.roi_array{cur_plane}.workingImageSettings.pixelRange = {['[' num2str(clim(1)) ' ' num2str(clim(2)) ']']};
im_session.ref.roi_array{cur_plane}.settings.selectedColor = [1 .5 0];


im_session.ref.roi_array{cur_plane}.startGui;
