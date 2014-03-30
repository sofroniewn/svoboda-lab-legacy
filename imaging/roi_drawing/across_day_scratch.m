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

roi_shifted = cell(4,1);
for ij = 1:4
cur_im = zeros(512,512);
cur_im(30:end,:) = im_session.ref.base_images{ij}(1:end-29,:)+20*randn(512-29,512);

ref_im = im_session.ref.roi_array{ij}.workingImage;


[shift corr_2] = register_image(cur_im,ref_im);

roi_source = im_session.ref.roi_array{ij};
roi_source.idStr = '2';

roi_shifted{ij} = roi.roiArray();
roi_shifted{ij}.workingImage = cur_im;
roi_shifted{ij}.baseWorkingImage = cur_im;
roi_shifted{ij}.masterImage = cur_im;
roi_shifted{ij}.idStr = '1';


% roi_shifted - where rois will be placed
roi.roiArray.findMatchingRoisInNewImage(roi_source,roi_shifted{ij});

end

roi_array = roi_shifted;
save('/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/ROIs_cells_an227254_2013_12_11_main_001.mat','roi_array');


roi_new = roi.roiArray();
roi_new.masterImage = im_session.ref.roi_array{1}.masterImage;
roi.roiArray.findMatchingRoisInNewImage(im_session.ref.roi_array_source{1},roi_new);

im_session.ref.roi_array_source{1}.startGui

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