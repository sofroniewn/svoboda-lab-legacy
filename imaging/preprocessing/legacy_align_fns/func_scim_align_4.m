function session = func_scim_align_4(session,scim_info)
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

numPlanes = scim_info{1}.numPlanes;
remove_first = 0;

%%
display([]);
display(['Start alignment ']);
for ij = 1:16 %num_files-1

    %%% REMOVE TRIGGERS CORRESPONDING TO INTERMEDIATE PLANES
    scim_trigs_vect = session.data{ij}.processed_matrix(6,:);
    scim_cum_trigs = session.trial_info.scim_cum_trigs(ij);
    scim_logging = session.trial_info.scim_logging(ij);
    trial_num = ij;
    remove_first;
    scim_vols = scim_info{ij}.nframes/numPlanes;
    scim_firstFrame = scim_info{ij}.firstFrameNumberRelTrigger;


    fprintf('(scim_align) loading file %g/%g \n',trial_num,num_files);
    scim_trigs = find(scim_trigs_vect);
    frame_shift = mod(scim_cum_trigs,numPlanes);
    if frame_shift ~=0
        frame_shift = numPlanes - frame_shift;
    end
    scim_trigs = scim_trigs(1+frame_shift:numPlanes:end);
    parsed_scim_trigs_vect = zeros(1,length(scim_trigs_vect));
    parsed_scim_trigs_vect(scim_trigs) = 1;
    if remove_first
        ind = find(parsed_scim_trigs_vect == 1,1,'first');
        parsed_scim_trigs_vect(ind) = 0;
        firstFrameNumberRelTrigger = scim_cum_trigs + frame_shift + 1 + numPlanes;
    else
        firstFrameNumberRelTrigger = scim_cum_trigs + frame_shift + 1;
    end
    remove_first = 0;
    scim_num_frames = length(find(parsed_scim_trigs_vect));
    
    % Check if trial has logging enabled
    if scim_logging
        % Check if start frame relative to onset trigger is correct
        if scim_firstFrame ~= firstFrameNumberRelTrigger
            error(['Not aligned trigger start trial ' num2str(trial_num)])
        end
        % Check if number of volumes is either correct or one extra
        if scim_vols == scim_num_frames || scim_vols - 1 == scim_num_frames
            % Check if number of volumes is one extra
            if scim_vols - 1 == scim_num_frames
               % If have one extra volume add it to the end of the current
               % trial
                parsed_scim_trigs_vect(end) = 1;
                scim_num_frames = scim_num_frames+1;
               % If next file exists remove first volume from that one
                remove_first = 1;
            end
        else
            error(['Not aligned num vols ' num2str(trial_num)])
        end
    end

    remove_first;
    session.data{ij}.processed_matrix(7,:) = parsed_scim_trigs_vect;
    session.trial_info.scim_num_frames(ij) = scim_num_frames;
    session.trial_info.firstFrameNumberRelTrigger(ij) = firstFrameNumberRelTrigger;
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




