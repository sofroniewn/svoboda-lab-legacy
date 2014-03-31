function [im_summary remove_first] = sync_behviour_scim_data(im_summary,trial_num_session,trial_num_im_session,remove_first)

    im_summary.behaviour.trial_num = trial_num_session;
    im_summary.behaviour.remove_first = remove_first;
    remove_first = func_scim_align_session(trial_num_session,trial_num_im_session,remove_first);
    global session;
    im_summary.behaviour.align_vect = session.data{trial_num_session}.processed_matrix(7,:);

