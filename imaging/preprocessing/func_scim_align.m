function session = func_scim_align(session,scim_info)
%%
disp(['--------------------------------------------']);
disp(['GENERATE SCIM ALIGNMENT']);

% NEED TO DETERMINE CORRESPONDANCE BETWEEN NUM TRIALS & NUM FILES
% if numel(scim_info) ~=  numel(session.data);
%     error('WRONG NUM FILES')
% end
num_files = numel(session.data);
%%
% For legacy files (i.e. L4 data where triggering was at end of iti) needed to correct !!!!!   
% ind = unique(session.trial_info.trial_start);
% for ij = 1:num_files-1
%    session.data{ij}.trial_matrix = [session.data{ij}.trial_matrix(:,ind:end) session.data{ij+1}.trial_matrix(:,1:ind-1)];
%    session.data{ij}.processed_matrix = [session.data{ij}.processed_matrix(:,ind:end) session.data{ij+1}.processed_matrix(:,1:ind-1)];
%    session.trial_info.trial_start(ij) = find(session.data{ij}.trial_matrix(9,:)==1,1,'first');
% end

%%

%%% REMOVE TRIGGERS CORRESPONDING TO INTERMEDIATE PLANES
for ij = 1:num_files
% LEGACY CODE
%   session.trial_info.scim_num_trigs(ij) = length(find(session.data{ij}.processed_matrix(6,:)));
%   if ij > 1 && session.trial_info.scim_logging(ij-1) == 1;
%       session.trial_info.scim_cum_trigs(ij) = session.trial_info.scim_cum_trigs(ij-1) + session.trial_info.scim_num_trigs(ij-1);
%   else
%       session.trial_info.scim_cum_trigs(ij) = 0;
%   end     
    scim_trigs = find(session.data{ij}.processed_matrix(6,:));
    numPlanes = scim_info{ij}.numPlanes;
    frame_shift = mod(session.trial_info.scim_cum_trigs(ij),numPlanes);
    if frame_shift ~=0
        frame_shift = numPlanes - frame_shift;
    end
    scim_trigs = scim_trigs(1+frame_shift:numPlanes:end);
    session.data{ij}.processed_matrix(7,:) = 0*session.data{ij}.processed_matrix(7,:);
    session.data{ij}.processed_matrix(7,scim_trigs) = 1;
    session.trial_info.scim_num_frames(ij) = length(find(session.data{ij}.processed_matrix(7,:)));
    session.trial_info.firstFrameNumberRelTrigger(ij) = session.trial_info.scim_cum_trigs(ij) + frame_shift + 1;
end

%%
display([]);
display(['Start alignment ']);
for ij = 1:num_files-1
    fprintf('(scim_align) loading file %g/%g \n',ij,num_files-1);
    scim_info{ij}.nvols = scim_info{ij}.nframes/scim_info{ij}.numPlanes;
    
    % Check if trial has logging enabled
    if session.trial_info.scim_logging(ij) == 1
        % Check if start frame relative to onset trigger is correct
        if scim_info{ij}.firstFrameNumberRelTrigger ~= session.trial_info.firstFrameNumberRelTrigger(ij)
            error(['Not aligned trigger start trial ' num2str(ij)])
        end
        
        % Check if number of volumes is either correct or one extra
        if scim_info{ij}.nvols == session.trial_info.scim_num_frames(ij) || scim_info{ij}.nvols - 1 == session.trial_info.scim_num_frames(ij)
            % Check if number of volumes is one extra
            if scim_info{ij}.nvols - 1 == session.trial_info.scim_num_frames(ij)
               % If have one extra volume add it to the end of the current
               % trial
                session.data{ij}.processed_matrix(7,end) = 1;
                session.trial_info.scim_num_frames(ij) = session.trial_info.scim_num_frames(ij)+1;
               % If next file exists remove first volume from that one
               if ij+1 <= num_files
                ind = find(session.data{ij+1}.processed_matrix(7,:) == 1,1,'first');
                session.data{ij+1}.processed_matrix(7,ind) = 0;
                session.trial_info.scim_num_frames(ij+1) = session.trial_info.scim_num_frames(ij+1)-1;
                session.trial_info.firstFrameNumberRelTrigger(ij+1) = session.trial_info.firstFrameNumberRelTrigger(ij+1) + scim_info{ij}.numPlanes;
               end
            end
        else
            error(['Not aligned num vols ' num2str(ij)])
        end
    end
end

disp(['SCIM ALIGNED']);
disp(['--------------------------------------------']);

%%     
% trial_num = 4;
% figure(1)
% clf(1)
% hold on
% plot(session.data{trial_num}.trial_matrix(14,:))
% plot(session.data{trial_num}.trial_matrix(9,:),'r','LineWidth',2)
% plot(session.data{trial_num}.processed_matrix(7,:),'.g')
% 




