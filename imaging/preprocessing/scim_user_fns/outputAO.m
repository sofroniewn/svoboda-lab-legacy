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
%persistent num_acqFrames

hSI = evnt.Source; %Handle to ScanImage

switch evnt.EventName
        
    case {'acquisitionStart' 'focusStart'}
        %Configure and start (arm) Task, to begin on first frame clock received
        hAO_njs = [];
        taskName = 'SI Mask AO';
        hSys = dabs.ni.daqmx.System();
        if hSys.taskMap.isKey(taskName)
            hSys.taskMap.remove(taskName);
        end
        
        devName = 'si4-2';
        chanID = 1;
        hAO_njs = dabs.ni.daqmx.Task(taskName);
        hAO_njs.createAOVoltageChan('si4-2',chanID);
        hAO_njs.writeAnalogData(0);
        fprintf('NJS AO enabled \n');
        
    case 'frameAcquired'
        tic
        hAO_njs.writeAnalogData(5+5*rand);
        toc
        
        
        
        
    case {'acquisitionDone' 'acquisitionAborted' 'focusDone'}
        hAO_njs = [];
        taskName = 'SI Mask AO';
        hSys = dabs.ni.daqmx.System();
        if hSys.taskMap.isKey(taskName)
            hSys.taskMap.remove(taskName);
            %delete(hSys.taskMap(taskName));
        end
        devName = 'si4-2';
        chanID = 1;
        hAO_njs = dabs.ni.daqmx.Task(taskName);
        hAO_njs.createAOVoltageChan('si4-2',chanID);
        hAO_njs.writeAnalogData(0);
        fprintf('NJS AO disabled \n');
        
    otherwise
        assert('User function ''%s'' triggered by unexpected event (''%s'')',mfilename,eventName);
        
end

end

