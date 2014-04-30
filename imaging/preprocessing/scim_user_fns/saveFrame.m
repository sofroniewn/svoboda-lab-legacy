function saveFrame(src,evnt,varargin)
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

persistent mmap_file
persistent num_acqFrames

hSI = evnt.Source; %Handle to ScanImage

switch evnt.EventName
      
    case {'focusStart', 'acquisitionStart'}
        %Configure and start (arm) Task, to begin on first frame clock received
        filename = fullfile(hSI.loggingFilePath,'memmap.dat')
        if exist(filename)~= 2
            [f, msg] = fopen(filename, 'wb');
            if f ~= -1
                fwrite(f, zeros(hSI.scanPixelsPerLine*hSI.scanLinesPerFrame*hSI.stackNumSlices+1,1,'uint16'), 'uint16');
                fclose(f);
            else
                error('MATLAB:demo:send:cannotOpenFile', ...
                    'Cannot open file "%s": %s.', filename, msg);
            end
        end
        mmap_file = memmapfile(filename, 'Writable', true,'Format', 'uint16');
        num_acqFrames = 0;
        fprintf('NJS memory map enabled \n');
        
    case 'frameAcquired'
        if num_acqFrames ~= hSI.acqFramesDone
            error('NJS USER FUNCTION NOT KEEPING UP')
        end
        num_acqFrames = num_acqFrames+1;
        vol_num = mod(hSI.acqFramesDone,hSI.stackNumSlices) + 1;
        mmap_file.Data(1+1+(vol_num-1)*hSI.scanPixelsPerLine*hSI.scanLinesPerFrame:1+vol_num*hSI.scanPixelsPerLine*hSI.scanLinesPerFrame) = uint16(hSI.acqFrameBuffer{1}(:));
        if vol_num == hSI.stackNumSlices %hSI.loggingEnable == 1 &&
            mmap_file.Data(1) = mmap_file.Data(1) + 1;
        end
        
        %     case {'acquisitionDone' 'acquisitionAborted'}
        %         %si4_postStimPulse(src,evnt);
        %
        %         %Stop Frame clock repeat Task
        %         if ~isempty(hSaveIndNJS) && isvalid(hSaveIndNJS)
        %             hSaveIndNJS.writeDigitalData(false);
        %         end
        %
        
    otherwise
        assert('User function ''%s'' triggered by unexpected event (''%s'')',mfilename,eventName);
        
end

end

