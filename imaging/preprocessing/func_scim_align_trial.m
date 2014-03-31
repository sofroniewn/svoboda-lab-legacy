function [remove_first parsed_scim_trigs_vect scim_num_frames firstFrameNumberRelTrigger] = func_scim_align_trial(numPlanes,remove_first,scim_logging,scim_trigs_vect,scim_cum_trigs,scim_vols,scim_firstFrame)

    %%% REMOVE TRIGGERS CORRESPONDING TO INTERMEDIATE PLANES
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
            error('Not aligned trigger start trial')
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
            error('Not aligned num vols')
        end
    end
