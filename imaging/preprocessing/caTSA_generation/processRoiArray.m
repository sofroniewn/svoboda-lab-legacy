function [rawRoiData antiRoiFluoVec neuropilData] = processRoiArray(processedRoi, im_aligned, signalChannel);

rawRoiData = cell(numel(processedRoi),1);
antiRoiFluoVec = cell(numel(processedRoi),1);
neuropilData = cell(numel(processedRoi),1);

	for ik = 1:numel(processedRoi)
		
		Nchan = length(signalChannel);
		Nframes = size(im_aligned{ik,1},3);

		% main load call *** THE MEAT IS HERE ***
		rawRoiData{ik} = zeros(size(processedRoi{ik}.roiMasks,2), Nframes, Nchan);
		antiRoiFluoVec{ik} = zeros(1, Nframes, Nchan);
	  	neuropilData{ik} = zeros(size(processedRoi{ik}.neuropilMasks,2), Nframes, Nchan);

	  	for c = 1:length(signalChannel)
      		im = im_aligned{ik,signalChannel(c)};
			% raw data matrix -- must convert to single bc matrix mult d/n work
			% with int
			tmpMat = (single(reshape(im,prod(processedRoi{ik}.imageBounds),Nframes)')*processedRoi{ik}.roiMasks)';
			tmpMat = tmpMat./(repmat(sum(processedRoi{ik}.roiMasks),size(tmpMat,2),1)');
			rawRoiData{ik}(:,:,c) = tmpMat;
			
			% antiroi
			tmpMat = (single(reshape(im,prod(processedRoi{ik}.imageBounds),Nframes)')*processedRoi{ik}.antiRoiMask)';
			tmpMat = tmpMat./(repmat(sum(processedRoi{ik}.antiRoiMask),size(tmpMat,2),1)');
			antiRoiFluoVec{ik}(1,:,c) = tmpMat;      
				
			% neuropil
			tmpMat = (single(reshape(im,prod(processedRoi{ik}.imageBounds),Nframes)')*processedRoi{ik}.neuropilMasks)';
			tmpMat = tmpMat./(repmat(sum(processedRoi{ik}.neuropilMasks),size(tmpMat,2),1)');
			neuropilData{ik}(:,:,c) = tmpMat;      
		end
	end