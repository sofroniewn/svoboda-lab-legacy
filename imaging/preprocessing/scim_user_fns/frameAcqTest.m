function frameAcqTest(src,evnt,varargin)
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

persistent hFrameIndNJS 

hSI = evnt.Source; %Handle to ScanImage

switch evnt.EventName
        
    case 'applicationOpen'        
        
    case 'applicationWillClose'                
        
    case 'acquisitionStart'        
                         fprintf('NJS start acq \n');                
        
    case {'acquisitionDone' 'acquisitionAborted'}
        
   case 'frameAcquired'        
                 fprintf('NJS frame acq 2 \n');      
                 hSI.stackSlicesDone
   case 'sliceDone'        
                 fprintf('NJS slice acq \n');     
   otherwise
        assert('User function ''%s'' triggered by unexpected event (''%s'')',mfilename,eventName);    
    
end

    function initFrameInd    

    end
        

end

