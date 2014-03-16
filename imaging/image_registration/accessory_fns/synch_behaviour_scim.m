function [parsed_scim_trig_vect] = synch_behaviour_scim(scim_trig_vect,num_planes,num_frames_scim,first_trig_scim)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INPUTS
% scim_trig_vect, vector of scanimage triggers in behaviour data
% num_planes, scalar of number of planes in current scim data
% num_frames_scim, number of frames according to scim data;
% prev_num_trigs_scim, first frame number according to scim data

% GLOBAL INPUTS
% prev_num_trigs_behaviour, scalar of number of previous triggers in behaviour data
% extra_frame_behaviour, whether current behaviour file has an extra frame or not
global prev_num_trigs_behaviour;
global extra_frame_behaviour;


% OUTPUTS
% parsed_scim_trig_vect, vector of aligned imaging frames
% prev_num_trigs_behaviour, number of previous triggers, including this trial
% extra_frame_behaviour, whether next file has an extra frame or not


%%% REMOVE TRIGGERS CORRESPONDING TO INTERMEDIATE PLANES
scim_trigs = find(scim_trig_vect);
num_scim_trigs = length(scim_trigs);
%% Determine which plane first behaviour scim trigger corresponds to
frame_shift = mod(prev_num_trigs_behaviour,num_planes);
if frame_shift ~=0
    frame_shift = num_planes - frame_shift;
end
firstFrameNumberRelTrigger = prev_num_trigs_behaviour + frame_shift + 1;
frame_trigs = scim_trigs(1+frame_shift:num_planes:end);

% If previous trial had an extra_frame remove first frame from this trial
if extra_frame_behaviour == 1
    frame_trigs(1) = [];
end

% Update vector of frame triggers and number of frames according to behaviour
parsed_scim_trig_vect = zeros(size(scim_trig_vect));
parsed_scim_trig_vect(frame_trigs) = 1;
num_frames_behaviour = length(frame_trigs);

% Check that first frame number according to behaviour matches
% first frame according to scan image
if firstFrameNumberRelTrigger ~= first_trig_scim
    error(['Not aligned trigger start trial'])
end

% Check if number of volumes is either correct or one extra
if num_frames_scim == num_frames_behaviour || num_frames_scim - 1 == num_frames_behaviour
    % Check if number of volumes is one extra
    if num_frames_scim - 1 == num_frames_behaviour
       % If have one extra volume add it to the end of the current
       % trial
        parsed_scim_trig_vect(end) = 1;
        num_frames_behaviour = num_frames_behaviour + 1;
        extra_frame_behaviour = 1;
        prev_num_trigs_behaviour = prev_num_trigs_behaviour + num_scim_trigs + num_planes;
    else
        extra_frame_behaviour = 0;
        prev_num_trigs_behaviour = prev_num_trigs_behaviour + num_scim_trigs;
    end
else
    error(['Not aligned number of frames'])
end

end

