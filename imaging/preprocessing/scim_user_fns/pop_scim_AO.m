function hAO = pop_scim_AO(hAO)

hAO.sampQuantSampMode = 'DAQmx_Val_None';
hAO.sampQuantSampPerChan= [];
hAO.sampTimingType= 'DAQmx_Val_None';
hAO.sampClkRate= [];
hAO.sampClkSrc= 'ao/SampleClockTimebase';
hAO.startTrigType= 'DAQmx_Val_None';
%hAO.refTrigType = '0';
hAO.pauseTrigType= 'DAQmx_Val_None';