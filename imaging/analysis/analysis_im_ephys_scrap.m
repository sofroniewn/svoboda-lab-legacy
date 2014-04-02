%%analysis_im_ephys
global session_bv;
global session_ca;


session_bv.data_names
scim_frames = logical(session_bv.data_mat(24,:));
trigs = zeros(1,length(scim_frames));
trigs(scim_frames) = [1:sum(scim_frames)];
trial_ind = 25;

bv_ca_data = session_bv.data_mat(:,scim_frames);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Across epoch rasters & PSTHs and tuning curves

x_vars = cell(5,1);
x_vars{1}.str = 'session_bv.data_mat(22,:)';
x_vars{1}.name = 'Speed';
x_vars{1}.range = [0 Inf];
x_vars{2}.str = 'session_bv.data_mat(9,:)';
x_vars{2}.name = 'ITI';
x_vars{2}.range = [0 .01];
x_vars{4}.str = 'session_bv.data_mat(21,:)';
x_vars{4}.name = 'Frac';
x_vars{4}.range = [0 1];
x_vars{5}.str = 'session_bv.data_mat(3,:)';
x_vars{5}.name = 'Cor_pos';
x_vars{5}.range = [0 30];
x_vars{3}.str = 'session_bv.data_mat(4,:)';
x_vars{3}.name = 'Cor_width';
x_vars{3}.range = [0 30];

trial_range = [0 Inf];
%%% for raster like representation
var_tune = 1;
edges = [0 5 Inf]; % each interval corresponds to one type
t_window_ms = 1000; % 200 ms window
plot_on = 1;

x_vals = diff(edges)/2+edges(1:end-1);
x_vals(x_vals==Inf) = edges(end-1);

%%% for tuning curves
var_tune = 1;
edges = [0:15 Inf]; % each interval corresponds to one type
t_window_ms = 25; % 50 ms window
plot_on = 0;

x_vals = diff(edges)/2+edges(1:end-1);

%%% for tuning curves
var_tune = 5;
edges = [0:30]; % each interval corresponds to one type
t_window_ms = 250; % 50 ms window
plot_on = 0;

x_vals = diff(edges)/2+edges(1:end-1);

%%% for raster like representation
var_tune = 3;
edges = [0 1 2 3 4]; % each interval corresponds to one type
t_window_ms = 950; % 200 ms window
plot_on = 1;
x_vars{4}.range = [1 5];

x_vals = diff(edges)/2+edges(1:end-1);

% make full variable array for small variable array
[full_vars col_mat] = expand_behavioural_types(x_vars,var_tune,edges);

% Set ind time
t_window_inds = round(t_window_ms*session_bv.rig_config.sample_freq/1000);
% extract num spikes in each time window where conditions are true
extracted_times = extract_time_windows_session(session_bv,trigs,trial_ind,full_vars,t_window_inds,trial_range);


% either plot rasters or make tuning curves with error bars
roi_id = 2;
analysis_var = session_ca.dff(roi_id,:);
phys = 1;

max_time = t_window_ms;
group_ids = [1:length(edges)-1];
[tuning_curve raster] = plot_imaging_time_windows(analysis_var,phys,extracted_times,group_ids,max_time,col_mat,plot_on);
tuning_curve.x_vals = x_vals;

plot_tuning_curves(tuning_curve)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%