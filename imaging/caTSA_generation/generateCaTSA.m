function obj = generateCaTSA(session_ca,roiArray,frameRate)

trialIndices = session_ca.file_nums;
allTime = [1:length(trialIndices)]'*1000/frameRate; % dt;
numFOVs = numel(roiArray);
numChan = length(session_ca.signalChannels);

	roiIds = [];
	for ik=1:numFOVs
		roiIds = [roiIds roiArray{ik}.roiIds];
	end

	
	% new triggerOffset, trialIndices ; roi-fov map
	roiFOVidx = zeros(length(roiIds),1);
  	caTS = {};
  	neuropilCaTS = {};
	antiRoiFluoVec = cell(numFOVs,1);
	for f=1:numFOVs
		roiFOV = find(session_ca.roiFOVidx == f);
	    for r = 1:roiArray{f}.length()
			value = session_ca.rawRoiData(roiFOV(r),:,:);
	    	caTS{length(caTS)+1} = session.timeSeries(allTime, 1, value, roiArray{f}.rois{r}.id, ['Ca TS for ' num2str(roiArray{f}.rois{r}.id)], 0, '');
			value = session_ca.neuropilData(roiFOV(r),:,:);
			neuropilCaTS{length(neuropilCaTS)+1} = session.timeSeries(allTime, 1, value, roiArray{f}.rois{r}.id, ['Neuropil Ca TS for ' num2str(roiArray{f}.rois{r}.id)], 0, '');
		end
		value = session_ca.antiRoiFluoVec(f,:,:);
		antiRoiFluoVec{f} = session.timeSeries(allTime, 1, value, 1, ['dF/F anti-ROI FOV ' num2str(f)], 0, '');
	     % populate rawData matrix
	end

    

	% --- and build actual objects ...
	obj = session.calciumTimeSeriesArray(caTS, trialIndices, roiArray, 1);
	obj.triggerOffsetForTrialInMS = 0;
	obj.roiFOVidx = roiFOVidx;
	obj.antiRoiFluoTS = antiRoiFluoVec;

	obj.neuropilTimeSeriesArray  =  session.timeSeriesArray(neuropilCaTS, trialIndices, [], [], obj.time, obj.timeUnit, [], 1);
	obj.rawDataAllChansValueMatrix = session_ca.rawRoiData;
	

