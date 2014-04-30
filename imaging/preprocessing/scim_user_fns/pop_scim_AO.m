function hAO = pop_scim_AO(hAO)

hAO.sampQuantSampMode = 'DAQmx_Val_ContSamps';
hAO.sampQuantSampPerChan= 1000;
hAO.sampTimingType= 'DAQmx_Val_OnDemand';
hAO.sampClkRate= 1000;
hAO.sampClkSrc= 'ao/SampleClockTimebase';
hAO.startTrigType= 'DAQmx_Val_None';
%hAO.refTrigType = '0';
hAO.pauseTrigType= 'DAQmx_Val_None';