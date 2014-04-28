function frameTrigSaveOn(src,evnt,varargin)
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

persistent hSaveIndNJS 

hSI = evnt.Source; %Handle to ScanImage

switch evnt.EventName
        
    case 'applicationOpen'        
        initSaveOnInd;
        
    case 'applicationWillClose'                
        if ~isempty(hSaveIndNJS) && isvalid(hSaveIndNJS)
            hSaveIndNJS.writeDigitalData(false);      
            delete(hSaveIndNJS);
        end
        
    case 'acquisitionStart'        
        
      
        %Configure and start (arm) Task, to begin on first frame clock received
        if isempty(hSaveIndNJS) || ~isvalid(hSaveIndNJS)
            hSys = dabs.ni.daqmx.System();
            if hSys.taskMap.isKey('SI Save On Indicator');
                hSaveIndNJS = hSys.taskMap('SI Save On Indicator');
            else
                initSaveOnInd();
            end
        end
        
        if hSI.loggingEnable == 1
            hSaveIndNJS.writeDigitalData(true);      
          fprintf('NJS logging enabled \n');
        else
              hSaveIndNJS.writeDigitalData(false);      
          fprintf('NJS logging off \n');
        end
     
      

        
    case {'acquisitionDone' 'acquisitionAborted'}
        %si4_postStimPulse(src,evnt);
        
        %Stop Frame clock repeat Task
        if ~isempty(hSaveIndNJS) && isvalid(hSaveIndNJS)
            hSaveIndNJS.writeDigitalData(false);      
        end
        
        
    otherwise
        assert('User function ''%s'' triggered by unexpected event (''%s'')',mfilename,eventName);    
    
end

    function initSaveOnInd    
        
        devName = 'si4-2';
        ctrID = 2;
        
        hSys = dabs.ni.daqmx.System();
        
        taskName = 'SI Save On Indicator';
        
        if hSys.taskMap.isKey(taskName) %This shouldn't happen in usual operation
            delete(hSys.taskMap(taskName));
        end
        
        hSaveIndNJS = dabs.ni.daqmx.Task(taskName);
        hSaveIndNJS.createDOChan(devName,sprintf('port%d/line%d',0,ctrID));    
        hSaveIndNJS.writeDigitalData(false);      

    end
        

end

