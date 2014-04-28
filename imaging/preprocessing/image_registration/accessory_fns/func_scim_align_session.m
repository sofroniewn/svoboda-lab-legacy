function remove_first = func_scim_align_session(trial_num_session,trial_num_im_session,remove_first)

global session
global im_session

numPlanes = im_session.ref.im_props.numPlanes;

    scim_trigs_vect = session.data{trial_num_session}.processed_matrix(6,:);
    scim_cum_trigs = session.trial_info.scim_cum_trigs(trial_num_session);
    scim_logging = session.trial_info.scim_logging(trial_num_session);
    scim_vols = im_session.reg.nFrames(trial_num_im_session);
    scim_firstFrame = im_session.reg.startFrame(trial_num_im_session);

    %%% ALIGN
    [remove_first parsed_scim_trigs_vect scim_num_frames firstFrameNumberRelTrigger] = func_scim_align_trial(numPlanes,remove_first,scim_logging,scim_trigs_vect,scim_cum_trigs,scim_vols,scim_firstFrame);

    session.data{trial_num_session}.processed_matrix(7,:) = parsed_scim_trigs_vect;
    session.trial_info.scim_num_frames(trial_num_session) = scim_num_frames;
    session.trial_info.firstFrameNumberRelTrigger(trial_num_session) = firstFrameNumberRelTrigger;


