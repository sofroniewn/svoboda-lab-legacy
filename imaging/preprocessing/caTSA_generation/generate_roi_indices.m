function processedRoi = generate_roi_indices(roiArray,neuropilDilationRange,roi_array_fname,overwrite)

[pathstr,name,ext] = fileparts(roi_array_fname);
fname = fullfile(pathstr,['PROCESSED_' name '.mat']);

if exist(fname) == 2 && overwrite == 0
	load(fname)
else

  	for ik=1:numel(roiArray)
		% neuropil
		neuropilRoiArray{ik} = roiArray{ik}.getNeuropilRoiArray (neuropilDilationRange(1), neuropilDilationRange(2));
	end

	
	processedRoi = cell(numel(roiArray),1);

	for ik = 1:numel(roiArray)
		%% -- build binary masks from roiArray and neuropilRoiArray
		processedRoi{ik}.roiMasks = zeros(prod(roiArray{ik}.imageBounds), length(roiArray{ik}));
    	for r=1:length(roiArray{ik})
		  processedRoi{ik}.roiMasks(roiArray{ik}.rois{r}.indices,r) = 1;
		end

  		processedRoi{ik}.neuropilMasks = zeros(prod(roiArray{ik}.imageBounds), length(neuropilRoiArray{ik}));
    	for r=1:length(neuropilRoiArray{ik})
  		  processedRoi{ik}.neuropilMasks(neuropilRoiArray{ik}.rois{r}.indices,r) = 1;
    	end
    
		antiRoiIndices =  roiArray{ik}.getAntiRoiIndices(2,5);
		processedRoi{ik}.antiRoiMask = zeros(prod(roiArray{ik}.imageBounds),1);
		processedRoi{ik}.antiRoiMask(antiRoiIndices) = 1;
		
		processedRoi{ik}.imageBounds = roiArray{ik}.imageBounds;
	end


save(fname,'processedRoi');

end

