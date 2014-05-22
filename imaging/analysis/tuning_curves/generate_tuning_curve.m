function tuning_curve = generate_tuning_curve(roi_id,type_nam,trial_range,t_window_ms)

	plot_on = 0;

	[full_vars x_vals col_mat] = generate_tuning_curve_params(type_nam);

global session_bv;
global session_ca;

session_bv.data_names;
scim_frames = logical(session_bv.data_mat(24,:));
trigs = zeros(1,length(scim_frames));
trigs(scim_frames) = [1:sum(scim_frames)];
trial_ind = 25;

bv_ca_data = session_bv.data_mat(:,scim_frames);

% Set ind time
t_window_inds = round(t_window_ms*session_bv.rig_config.sample_freq/1000);
% extract num spikes in each time window where conditions are true
extracted_times = extract_time_windows_session(session_bv,trigs,trial_ind,full_vars,t_window_inds,trial_range);


% either plot rasters or make tuning curves with error bars
analysis_var = session_ca.dff(roi_id,:);
phys = 1;

max_time = t_window_ms;
group_ids = [1:length(x_vals)-1];
[tuning_curve raster] = plot_imaging_time_windows(analysis_var,phys,extracted_times,group_ids,max_time,col_mat,plot_on);
tuning_curve.x_vals = x_vals(1:end-1);
