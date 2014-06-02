function trial_raster = generate_trial_raster(roi_id,stim_type_name,keep_type_name,trial_range)


global session_bv;
global session_ca;
respones_vect = session_ca.dff(roi_id,:);
trial_raster = get_full_trial_vars(stim_type_name,keep_type_name,trial_range,respones_vect);




