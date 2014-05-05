function maskAO(src,evnt,varargin)
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
persistent ref
persistent maks
persistent ao_val
persistent num_acqFrames

hSI = evnt.Source; %Handle to ScanImage

switch evnt.EventName
        
    case {'acquisitionStart' 'focusStart'}
        
        % Find and load reference
        ref_files = dir(fullfile(hSI.loggingFilePath,'ref_images_*.mat'));
        if numel(ref_files) == 0
            error('No reference file')
        end
        filename = fullfile(hSI.loggingFilePath,ref_files(1).name);
        load(filename);
        ref = post_process_ref_fft(ref);
        fprintf('NJS load reference \n');

        % Find and load mask
        mask_files = dir(fullfile(hSI.loggingFilePath,'mask_*.mat'));
        %if numel(mask_files) == 0
        %    error('No mask file')
        %end
        %filename = fullfile(hSI.loggingFilePath,mask_files(1).name);
        %load(filename);
        mask_vals = rand(512,512,4);
        fprintf('NJS load mask \n');

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
        
        ao_val = 0;

        hAO_njs.writeAnalogData(ao_val);
        fprintf('NJS AO enabled \n');
    

    case 'frameAcquired'
           
        vol_num = hSI.stackSlicesDone+1;
        % vol_num = mod(hSI.acqFramesDone,hSI.stackNumSlices) + 1;

       if vol_num > 0
            cur_im = uint16(hSI.acqFrameBuffer{1}(:));
            [shift corr_2] = gcorr_mod_fast(cur_im, ref.post_fft{vol_num});
            im_shifted = func_im_shift(cur_im,shift);
            inner_product = im_shifted.*mask_vals(:,:,vol_num);
            ao_val = ao_val + sum(inner_product(:));
       end
       
        % when volume acquired write ao value
       if vol_num == hSI.stackNumSlices
            hAO_njs.writeAnalogData(ao_val);
            ao_val = 0;
       end



        
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

