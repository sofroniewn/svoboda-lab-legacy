 hSys = dabs.ni.daqmx.System();
        
        taskName = 'test_njs3';
        
        if hSys.taskMap.isKey(taskName) %This shouldn't happen in usual operation
            delete(hSys.taskMap(taskName));
        end
        %%
        hFrmClkRpt_njs = dabs.ni.daqmx.Task('test_njs3');
        %%
            hFrmClkRpt_njs.createDOChan('si4-2',sprintf('port%d/line%d',0,2));    
            %%
            hFrmClkRpt_njs.writeDigitalData(logical(1)); 
            
            444
            %%
             hFrmClkRpt_njs.cfgDigEdgeStartTrig(sprintf('PFI%d',hSI.mdfData.extFrameClockTerminal));
       %%
       hFrmClkRpt_njs.start
       %%
        hFrmClkRpt_njs.createCOPulseChanTime('si4-2',sprintf('port%d/line%d',0,2),'',10e-5,1e-3,0); %Create channel on Ctr0 to generate pulse of 10us after stimDelay time following trigger55
        hFrmClkRpt_njs.cfgImplicitTiming('DAQmx_Val_FiniteSamps',1); %Multiply ScanImage frame clock rate by 2x (dummy value -- will be overridden at acquisitionStart event)
        hFrmClkRpt_njs.cfgDigEdgeStartTrig(sprintf('PFI%d',hSI.mdfData.extFrameClockTerminal));
        hFrmClkRpt_njs.set('startTrigRetriggerable',1);
          
        
        
        
        
        
        
        %%
        hAO_njs98 = dabs.ni.daqmx.Task('test_njs98');
        %%
            hAO_njs98.createAOVoltageChan('si4-2',1);  
            
%%
                  hAO_njs98 = pop_scim_AO(hAO_njs98)
              
            
            %%
hAO_njs98.writeAnalogData(10)
444
            %%
hAO_njs98.cfgSampClkTiming(1000,'DAQmx_Val_ContSamps',1000);
       %%
       hFrmClkRpt_njs.start
       %%
        hFrmClkRpt_njs.createCOPulseChanTime('si4-2',sprintf('port%d/line%d',0,2),'',10e-5,1e-3,0); %Create channel on Ctr0 to generate pulse of 10us after stimDelay time following trigger55
        hFrmClkRpt_njs.cfgImplicitTiming('DAQmx_Val_FiniteSamps',1); %Multiply ScanImage frame clock rate by 2x (dummy value -- will be overridden at acquisitionStart event)
        hFrmClkRpt_njs.cfgDigEdgeStartTrig(sprintf('PFI%d',hSI.mdfData.extFrameClockTerminal));
        hFrmClkRpt_njs.set('startTrigRetriggerable',1);
        