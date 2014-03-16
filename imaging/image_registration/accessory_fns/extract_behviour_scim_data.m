function im_summary = extract_behviour_scim_data(im_summary,scim_trig_vect,behaviour_trial_num)

% peform behaviour and scan image alignment on this file
num_planes = im_summary.props.num_planes;
num_frames_scim = im_summary.props.num_frames;
first_trig_scim = im_summary.props.firstFrame;

global prev_num_trigs_behaviour;
im_summary.behaviour.prev_num_trigs = prev_num_trigs_behaviour;

im_summary.behaviour.trial_num = behaviour_trial_num;

[parsed_scim_trig_vect] = synch_behaviour_scim(scim_trig_vect,num_planes,num_frames_scim,first_trig_scim);

im_summary.behaviour.align_vect = parsed_scim_trig_vect;

global extra_frame_behaviour;
im_summary.behaviour.extra_frame = extra_frame_behaviour;

