function session_ca = calculate_dff(session_ca,im_session,neuropilSubSF)

	caTSA = generateCaTSA(session_ca,im_session.ref.roi_array,im_session.ref.im_props.frameRate);
	caTSA.genParams.neuropilSubSF = neuropilSubSF; %-1 determine auto, 0 none, >0 scale factor
	caTSA.runPostProcessing;
	session_ca.neuropilSubSF = neuropilSubSF;
	session_ca.dff = caTSA.dffTimeSeriesArray.valueMatrix;
	session_ca.events = caTSA.caPeakTimeSeriesArray.valueMatrix;
	session_ca.event_array = caTSA.caPeakEventSeriesArray.esa;
	session_ca.event_dff = caTSA.eventBasedDffTimeSeriesArray.valueMatrix;
	session_ca.time = [1:size(session_ca.dff,2)]/im_session.ref.im_props.frameRate;
