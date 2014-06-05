function summary_ca = generate_neuron_summary

global session_ca;
num_roi = length(session_ca.roiIds);

summary_ca = cell(2,1);

stim_type_name = 'corPos';
keep_type_name = 'running';
trial_range = [0 Inf];
summary_ca{1,1}.tuning_param = fit_tuning_curves(stim_type_name,keep_type_name,trial_range,num_roi);


stim_type_name = 'speed';
keep_type_name = 'farFromWall';
trial_range = [0 Inf];
summary_ca{2,1}.tuning_param = fit_tuning_curves(stim_type_name,keep_type_name,trial_range,num_roi);

