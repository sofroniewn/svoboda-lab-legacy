function gpuMotionCorrection(src,evnt,varargin)
%GPUMOTIONCORRECTION SI4 user function for interfacing to GPU motion correction module via a TCP port
%
% SYNTAX
%     gpuMotionCorrection(src,evnt,argName1,argVal1,argName2,argVal2,...)
%
%  Arguments, by event. If default is specified, argument is optional.
%   acquisitionStart Event:
%       'portNumber': <Default=10001> TCP port number to use for connection to GPU motion correction module
%       'ipAddress': <Default='localhost'> IP address at which GPU motion correction module is running
%
%   frameAcquired Event:
%       'chanNumber': <Default=1> ScanImage channel number (1-4) whose data will be processed by GPU motion correction module
%

% addpath('C:\Program Files\ScanImage\SCANIMAGE_BRANCH_r4.1\Samples\UserFcns\prep\gpuMotionCorrection\Routines');

type_ref = 0;
type_curr = 1;
type_corr = 2;
type_ROI = 3;
type_z = 4;
type_new = 77;
type_end = 99;

cropMode = 0;

persistent acqStartFlag frames_skipped temp_buffer trialID lastTrialID
persistent H

H=fspecial('gaussian'); %default size = 3*3, sigma = 0.5

% persistent gpuEMA

hSI = evnt.Source; %Handle to ScanImage

switch evnt.EventName
        
    case 'acquisitionStart'   
%         addpath('C:\Program Files\ScanImage\SCANIMAGE_BRANCH_r4.1\Samples\UserFcns\prep\gpuMotionCorrection\Routines');
        
%         fid = fopen('C:\Program Files\ScanImage\SCANIMAGE_BRANCH_r4.1\Samples\UserFcns\prep\gpuMotionCorrection\MotionCorrectionServer\Current\ReTiNA\ReTiNA\x64\Release\tmp\fname.dat','w');
        fid = fopen('G:\MotionCorrectionServer\ReTiNA\x64\Release\tmp\fname.dat','w');

%         fprintf(fid, [hSI.loggingFileStem, '_', num2str(hSI.loggingFileCounter)]);
        fprintf(fid, [hSI.loggingFileStem]);
        fclose(fid);
        trialID = hSI.loggingFileCounter
        lastTrialID = trialID-1;
        frames_skipped=int32(0);
%         gpuEMA=zeros(512);
        tic;

        % signal beginning of new trial
%         new_header = [10 0 0 trialID type_new 0 0 0 0 0 ];  
%         new_trial_sig = save_mat(double(new_header), double([]));
%         pause(0.05);
        acqStartFlag = true;
%         frameToProcess = 1;

    case 'frameAcquired'                    
        
        if isequal(hSI.acqState,'focus')
            disp('focusing')
            return;
        end
            
        %check trialID
        trialID = hSI.loggingFileCounter;
        if trialID ~= lastTrialID
            new_header = [10 0 0 trialID type_new 0 0 0 0 0 ];  
            new_trial_sig = save_mat(double(new_header), double([]));
            lastTrialID = trialID;
            disp('New trigger signal sent!')
        end
        acqCurrTime = toc;

        %Default vals
        chanNumber = 1;

%         %Override defaults with args
%         if ~isempty(varargin)            
%             assert(isequal(varargin{1},'chanNumber'),argErrorMessage());
%             assert(nargin == 2,argErrorMessage());
%             chanNumber = varargin{2};
%             assert(isnumeric(chanNumber) && isscalar(chanNumber) && ismember(chanNumber,1:4),argErrorMessage());
%         end                        
        
%% for 256*256 imaging
%         if mod(hSI.acqFramesDone,2)==1
%             if cropMode == 0
%                 temp_buffer = hSI.acqFrameBuffer{1}(:,:,chanNumber);
%             elseif cropMode == 1
% %                 temp_buffer = hSI.acqFrameBuffer{1}(129:384,129:384,chanNumber);
%                 temp_buffer = medfilt2(hSI.acqFrameBuffer{1}(129:384,129:384,chanNumber));
%             end
%         elseif mod(hSI.acqFramesDone,2)==0
%             %%!!!!!!!!!!! images must be 256*256 !!!!!!!!!!!
%             gpuMessageType = type_curr; %Code for sending 'current' image
% %             gpuImage = hSI.acqFrameBuffer{1}(:,:,chanNumber); %Most-recent frame            
%             if cropMode == 0
%                 gpuImage = (temp_buffer + hSI.acqFrameBuffer{1}(:,:,chanNumber))/2; 
%                 gpuImage = impyramid(gpuImage,'reduce');
%             elseif cropMode == 1
% %                 gpuImage = (temp_buffer + hSI.acqFrameBuffer{1}(129:384,129:384,chanNumber))/2; 
%                 gpuImage = temp_buffer + medfilt2(hSI.acqFrameBuffer{1}(129:384,129:384,chanNumber));
% %                 gpuImage = imfilter(gpuImage,H,'same');
%             end
%             
%             gpuHeader = [10 hSI.acqFramesDone 1000*acqCurrTime 0 gpuMessageType size(gpuImage,1) size(gpuImage,2) 0 0 hSI.loggingEnable];
% 
%             im_copied = save_mat(double(gpuHeader), double(gpuImage));
% 
%             if (im_copied == 0)
%                 frames_skipped = int32(frames_skipped) + int32(1 - im_copied)
%             end
%         end
        
%% for 512*512 imaging

    if hSI.stackSlicesDone==1
%     if mod(hSI.acqFramesDone,4)==1
        gpuMessageType = type_curr; %Code for sending 'current' image
        gpuImage = hSI.acqFrameBuffer{1}(:,:,chanNumber); 

        gpuHeader = [10 hSI.acqFramesDone 1000*acqCurrTime 0 gpuMessageType size(gpuImage,1) size(gpuImage,2) 0 0 hSI.loggingEnable];

        im_copied = save_mat(double(gpuHeader), double(gpuImage));

        if (im_copied == 0)
            frames_skipped = int32(frames_skipped) + int32(1 - im_copied)
        end
    end




    case {'acquisitionDone' 'acquisitionAborted'}

        
    case 'nextTriggerReceived'
%         new_header = [10 0 0 trialID type_new 0 0 0 0 0 ];  
%         new_trial_sig = save_mat(double(new_header), double([]));
%         disp('New trigger signal sent!')
        
    otherwise
%         assert('User function ''%s'' triggered by unexpected event (''%s'')',mfilename,evnt.EventName);    
    
end

%     function str = argErrorMessage()
%         str = sprintf('Argument(s) supplied to ''%s'' user function for event ''%s'' is/are invalid. Please check carefully.',mfilename(),evnt.EventName);
%     end
end

