function [rawRoiData antiRoiFluoVec neuropilData] = processRoiArray(roiArray, neuropilRoiArray, im_aligned, signalChannel);

rawRoiData = cell(numel(roiArray),1);
antiRoiFluoVec = cell(numel(roiArray),1);
neuropilData = cell(numel(roiArray),1);

	for ik = 1:numel(roiArray)

		%% -- build binary masks from roiArray and neuropilRoiArray
		roiMasks = zeros(prod(roiArray{ik}.imageBounds), length(roiArray{ik}));
    	for r=1:length(roiArray{ik})
		  roiMasks(roiArray{ik}.rois{r}.indices,r) = 1;
		end

  		neuropilMasks = zeros(prod(roiArray{ik}.imageBounds), length(neuropilRoiArray{ik}));
    	for r=1:length(neuropilRoiArray{ik})
  		  neuropilMasks(neuropilRoiArray{ik}.rois{r}.indices,r) = 1;
    	end
    
		antiRoiIndices =  roiArray{ik}.getAntiRoiIndices(2,5);
		antiRoiMask = zeros(prod(roiArray{ik}.imageBounds),1);
		antiRoiMask(antiRoiIndices) = 1;

		Nchan = length(signalChannel);
		Nframes = size(im_aligned{ik,1},3);

		% main load call *** THE MEAT IS HERE ***
		rawRoiData{ik} = zeros(length(roiArray{ik}), Nframes, Nchan);
		antiRoiFluoVec{ik} = zeros(1, Nframes, Nchan);
	  	neuropilData{ik} = zeros(length(neuropilRoiArray{ik}), Nframes, Nchan);

	  	for c = 1:length(signalChannel)
      		im = im_aligned{ik,signalChannel(c)};
			% raw data matrix -- must convert to single bc matrix mult d/n work
			% with int
			tmpMat = (single(reshape(im,prod(roiArray{ik}.imageBounds),Nframes)')*roiMasks)';
			tmpMat = tmpMat./(repmat(sum(roiMasks),size(tmpMat,2),1)');
			rawRoiData{ik}(:,:,c) = tmpMat;
			
			% antiroi
			tmpMat = (single(reshape(im,prod(roiArray{ik}.imageBounds),Nframes)')*antiRoiMask)';
			tmpMat = tmpMat./(repmat(sum(antiRoiMask),size(tmpMat,2),1)');
			antiRoiFluoVec{ik}(1,:,c) = tmpMat;      
				
			% neuropil
			tmpMat = (single(reshape(im,prod(roiArray{ik}.imageBounds),Nframes)')*neuropilMasks)';
			tmpMat = tmpMat./(repmat(sum(neuropilMasks),size(tmpMat,2),1)');
			neuropilData{ik}(:,:,c) = tmpMat;      
		end
	end