global im_session


	for ij = 1:im_session.ref.im_props.numPlanes
		im_session.ref.roi_array{ij}.workingImage = im_session.ref.base_images{ij};
		im_session.ref.roi_array{ij}.baseWorkingImage = im_session.ref.base_images{ij};
	end

%rA_1 = im_session.ref.roi_array{2};
%rA_2 = roi.roiArray();
%rA_2.workingImage = zeros(512,512);
%rA_2.workingImage(30:end,:) = im_session.ref.base_images{2}(1:end-29,:)+20*randn(512-29,512);
%rA_2.baseWorkingImage = rA_2.workingImage;		
%rA_1.idStr = {'1'};
%rA_2.idStr = {'2'};
%corrval = roi.roiArray.findMatchingRoisInNewImage(rA_1,rA_2)

cur_im = zeros(512,512);
cur_im(30:end,:) = im_session.ref.base_images{4}(1:end-29,:)+20*randn(512-29,512);

ref_im = im_session.ref.roi_array{4}.workingImage;


[shift corr_2] = register_image(cur_im,ref_im);

roi_source = im_session.ref.roi_array{4};
roi_source.idStr = '2';

roi_shifted = roi.roiArray();
roi_shifted.workingImage = cur_im;
roi_shifted.baseWorkingImage = cur_im;
roi_shifted.idStr = '1';



% roi_shifted - where rois will be placed
roi.roiArray.findMatchingRoisInNewImage(roi_source,roi_shifted);


%rA_1 = im_session.ref.roi_array{2};
%rA_2 = roi.roiArray();
%rA_2.workingImage = zeros(512,512);
%rA_2.workingImage(30:end,:) = im_session.ref.base_images{2}(1:end-29,:)+20*randn(512-29,512);
%rA_2.baseWorkingImage = rA_2.workingImage;		
%rA_1.idStr = {'1'};
%rA_2.idStr = {'2'};
%corrval = roi.roiArray.findMatchingRoisInNewImage(rA_1,rA_2)
im_session.ref.roi_array{2}.rois;
im_session.ref.roi_array{2}.roiIds;
im_session.ref.roi_array{2}.roiIdRange;