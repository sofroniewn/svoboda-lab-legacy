function session = func_scim_align_5(session,scim_info)
%%
disp(['--------------------------------------------']);
disp(['GENERATE SCIM ALIGNMENT']);
display([]);

% NEED TO DETERMINE CORRESPONDANCE BETWEEN NUM TRIALS & NUM FILES
% if numel(scim_info) ~=  numel(session.data);
%     error('WRONG NUM FILES')
% end
num_files = numel(session.data);

numPlanes = scim_info{1}.numPlanes;

remove_first = 0;
display(['Start alignment ']);
for ij = 1:19 %num_files-1
    scim_trigs_vect = session.data{ij}.processed_matrix(6,:);
    scim_cum_trigs = session.trial_info.scim_cum_trigs(ij);
    scim_logging = session.trial_info.scim_logging(ij);
    scim_vols = scim_info{ij}.nframes/numPlanes;
    scim_firstFrame = scim_info{ij}.firstFrameNumberRelTrigger;

    fprintf('(scim_align) loading file %g/%g \n',ij,num_files);
    %%% ALIGN
    [remove_first parsed_scim_trigs_vect scim_num_frames firstFrameNumberRelTrigger] = func_scim_align_trial(numPlanes,remove_first,scim_logging,scim_trigs_vect,scim_cum_trigs,scim_vols,scim_firstFrame);

    session.data{ij}.processed_matrix(7,:) = parsed_scim_trigs_vect;
    session.trial_info.scim_num_frames(ij) = scim_num_frames;
    session.trial_info.firstFrameNumberRelTrigger(ij) = firstFrameNumberRelTrigger;
end

disp(['SCIM ALIGNED']);
disp(['--------------------------------------------']);





