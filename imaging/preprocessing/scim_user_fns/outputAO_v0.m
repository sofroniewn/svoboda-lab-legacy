function outputAO(src,evnt,varargin)
%FRAMETRIGSAVEON SI4 user function to generate output trigger signal at
% with frame trigger only in acquisition mode with save on, e.g. for 
% synchornization with behaviour software
%
% SYNTAX
%  applicationOpenEvent:
%    frameTrigSaveOn(src,evnt,devName,ctrID)
%      devName: DAQmx device name of board on which output trigger signal should be generated
%      ctrID: <Default=0> Counter channel number on board identi
%
%  acquisitionStartEvent:
%    frameTrigSaveOn(src,evnt)
%
% NOTES
%  Function is assumed to work in SI4 'internal' triggered mode, for which
%  LSM frame clock generation starts after self start trigger is generated/received
%

persistent hAO_njs 
persistent num_acqFrames

hSI = evnt.Source; %Handle to ScanImage

switch evnt.EventName
        
    case 'applicationOpen'        
        initAO_chan;
        
    case 'applicationWillClose'                
        if ~isempty(hAO_njs) && isvalid(hAO_njs)
            hAO_njs.writeAnalogData(0);      
            delete(hAO_njs);
        end
        
    case {'acquisitionStart' 'focusStart'}
        %Configure and start (arm) Task, to begin on first frame clock received
      hAO_njs
      initAO_chan(); 
      fprintf('NJS AO enabled \n');
      hAO_njs.writeAnalogData(0);
        
     case 'frameAcquired'
        
      hAO_njs.writeAnalogData(5*rand);
        
    case {'acquisitionDone' 'acquisitionAborted' 'focusDone'}
                     %   delete(hAO_njs);
%hAO_njs.writeAnalogData(0);
            
    otherwise
        assert('User function ''%s'' triggered by unexpected event (''%s'')',mfilename,eventName);    
    
end

    function initAO_chan   
        
        devName = 'si4-2';
        chanID = 1;
        taskName = 'SI Mask AO'; 
                hSys = dabs.ni.daqmx.System();

                if hSys.taskMap.isKey(taskName) %This shouldn't happen in usual operation
            888
                    delete(hSys.taskMap(taskName));
                end
                
       hAO_njs = dabs.ni.daqmx.Task(taskName);
        hAO_njs.createAOVoltageChan('si4-2',chanID);    
        hAO_njs.writeAnalogData(0);      
    end
        

end

