%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set path to run
clear all
base_dir = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0221172/2014_02_21/run_09';
f_name_flag = '*_trial*.bin';
file_nums = [1:100];
file_list = func_list_files(base_dir,f_name_flag,file_nums);

% Load in behaviour data
base_path_behaviour = fullfile(base_dir, 'behaviour');
session = load_session_data(base_path_behaviour);
session = parse_session_data(1,session);

% Load in clustered data
base_path_clustered = fullfile(base_dir, 'ephys', 'sorted');
cur_file = dir(fullfile(base_path_clustered,'sorted_units*.mat'));
f_name = fullfile(base_path_clustered,cur_file(1).name);
load(f_name);

% Load in laser power data
cur_file = dir(fullfile(base_path_clustered,'laser_data*.mat'));
f_name = fullfile(base_path_clustered,cur_file(1).name);
load(f_name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inspect sorted units across entire session

trial_range = [0 Inf];

clust_id = 1;

plot_spike_raster(clust_id,sorted_spikes,trial_range)
plot_isi_full(clust_id,sorted_spikes,trial_range)
plot_waveforms_full(clust_id,sorted_spikes,trial_range)
plot_stability_full(clust_id,sorted_spikes,[])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Synchronize in time

[session] = sync_ephys_behaviour(base_dir,file_list,sync_trigs,session)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visualize unit data trial by trial

trial_id = 9;
[s p d] = load_ephys_trial(base_dir,file_list,trial_id);
start_time = sync_trigs{trial_id}.start_time;

clust_id = 2;
spike_inds = sorted_spikes{clust_id}.spike_inds(:,1) == trial_id;
spike_times = sorted_spikes{clust_id}.spike_inds(spike_inds,3);

match_time = ~isnan(session.data{trial_id}.processed_matrix(6,:));


figure(43)
clf(43)
hold on
plot(d.TimeStamps - start_time,-d.Trigger_allCh/5,'k')
plot(session.data{trial_id}.processed_matrix(1,match_time),-d.Trigger_allCh(session.data{trial_id}.processed_matrix(6,match_time))/5,'k')
plot(spike_times - start_time,0,'.k')
plot(session.data{trial_id}.processed_matrix(1,:),-(1-session.data{trial_id}.trial_matrix(9,:)),'k')
plot(session.data{trial_id}.processed_matrix(1,:),session.data{trial_id}.processed_matrix(5,:))
plot(session.data{trial_id}.processed_matrix(1,:),session.data{trial_id}.trial_matrix(5,:),'Color', [1 .65 0])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot across session ephys and behaviour data

behaviour_vector = 20*session.trial_info.mean_speed;
%behaviour_vector = 20*session.trial_info.max_laser_power;

plot_stability_full(clust_id,sorted_spikes,behaviour_vector);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot spike raster's, splitting according to trial types

groups = round(laser_data.laser_power*10);
group_ids = [unique(groups); Inf];
col_mat = [0 0 0;.3 0 0; .6 0 0; 1 0 0];

group_ids = [0 3 Inf];
groups = session.trial_info.mean_speed;
col_mat = [0 0 0; 1 0 0];

group_ids = [0 1 2 3 Inf];
groups = session.trial_info.max_laser_power;
col_mat = [0 0 0;.3 0 0; .6 0 0; 1 0 0];

group_ids = [0 10 100 Inf];
groups = session.trial_info.forward_distance;
groups(session.trial_info.max_laser_power > 0) = 150;
col_mat = [0 0 0; 1 0 0; 0 1 0];

clust_id = 2;
trial_range = [1 30];

plot_spike_raster_groups(clust_id,sorted_spikes,trial_range,groups,group_ids,col_mat);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Across epoch rasters & PSTHs and tuning curves

clust_id = 2;

x_vars = cell(5,1);
x_vars{1}.str = 'session.data{trial_id}.processed_matrix(5,:)';
x_vars{1}.name = 'Speed';
x_vars{1}.range = [0 Inf];
x_vars{2}.str = 'session.data{trial_id}.trial_matrix(9,:)';
x_vars{2}.name = 'ITI';
x_vars{2}.range = [0 .01];
x_vars{3}.str = 'smooth(session.data{trial_id}.trial_matrix(5,:),500)';
x_vars{3}.name = 'laser_power';
x_vars{3}.range = [0 0.01];
x_vars{4}.str = 'session.data{trial_id}.processed_matrix(1,:)';
x_vars{4}.name = 'Time';
x_vars{4}.range = [0 2];
x_vars{5}.str = 'session.data{trial_id}.trial_matrix(3,:)';
x_vars{5}.name = 'Cor_pos';
x_vars{5}.range = [0 30];

%%% for raster like representation
var_tune = 1;
edges = [0 5 Inf]; % each interval corresponds to one type
t_window_inds = 200; % 200 ms window
plot_on = 1;

x_vals = diff(edges)/2+edges(1:end-1);
x_vals(x_vals==Inf) = edges(end-1);

%%% for tuning curves
var_tune = 1;
edges = [0:15 Inf]; % each interval corresponds to one type
t_window_inds = 25; % 50 ms window
plot_on = 0;

x_vals = diff(edges)/2+edges(1:end-1);

%%% for tuning curves
var_tune = 5;
edges = [0:30]; % each interval corresponds to one type
t_window_inds = 250; % 50 ms window
plot_on = 0;

x_vals = diff(edges)/2+edges(1:end-1);

%%% for raster like representation
var_tune = 3;
edges = [0 1 2 3 4]; % each interval corresponds to one type
t_window_inds = 950; % 200 ms window
plot_on = 1;
x_vars{4}.range = [1 5];

x_vals = diff(edges)/2+edges(1:end-1);

% make full variable array for small variable array
[full_vars col_mat] = expand_behavioural_types(x_vars,var_tune,edges);

% extract num spikes in each time window where conditions are true
[extracted_times max_time] = extract_time_windows(session,full_vars,t_window_inds,trial_range);

% either plot rasters or make tuning curves with error bars
group_ids = [1:length(edges)-1];
tuning_curve = plot_spike_raster_time_windows(clust_id,sorted_spikes,extracted_times,group_ids,max_time,col_mat,plot_on);
tuning_curve.x_vals = x_vals;

plot_tuning_curves(tuning_curve)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% SCRAP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Across transition rasters and PSTHs

% Pull out intervals of time when a behavioural variable transitions
% Each x_vars must be between range x_vars_range (x_vars_range(1) <= and < x_vars_range(2)) for entire t_window;
% x_vars is a cell array of strings, each string defining 

x_vars = cell(4,1);
x_vars{1}.str = 'session.data{trial_id}.processed_matrix(5,:)';
x_vars{1}.name = 'Speed';
x_vars{1}.range = [0 Inf];
x_vars{2}.str = 'session.data{trial_id}.trial_matrix(9,:)';
x_vars{2}.name = 'ITI';
x_vars{2}.range = [0 .01];
x_vars{3}.str = 'session.data{trial_id}.trial_matrix(5,:)';
x_vars{3}.name = 'laser_power';
x_vars{3}.range = [0 .01];
x_vars{4}.str = 'session.data{trial_id}.processed_matrix(1,:)';
x_vars{4}.name = 'Time';
x_vars{4}.range = [0 2];


%%% for raster like representation
var_tune = 1; % var for transition
thresholds = [5];
lower_bouns = 3;
[0 5 Inf]; % each interval corresponds to one type
t_window_inds = 200; % 200 ms window
plot_on = 1;

x_vals = diff(edges)/2+edges(1:end-1);
x_vals(x_vals==Inf) = edges(end-1);



transition_vars.str = 'smooth(session.data{trial_id}.processed_matrix(5,:),200)';
%transition_vars.str  = 'session.data{trial_id}.trial_matrix(9,:)';
transition_vars.name = 'Speed';
transition_vars.range = [0 5 5 Inf];
%transition_vars.range = [5 Inf 0 5];

transition_vars.str = 'session.data{trial_id}.trial_matrix(5,:)';
%transition_vars.str  = 'session.data{trial_id}.trial_matrix(9,:)';
transition_vars.name = 'laser_power';
transition_vars.range = [1 Inf 0 0.1];
%transition_vars.range = [5 Inf 0 5];

col_mat = [0 0 0; 1 0 0];

t_window_inds = [-250 250];
extracted_times = extract_time_transitions(session,x_vars,transition_vars,t_window_inds)
extracted_times(:,4) = (extracted_times(:,2) - 500)/500;
extracted_times(:,5) = (extracted_times(:,3) - 500)/500;

max_time = (t_window_inds(2)-t_window_inds(1))/500;
plot_spike_raster_time_windows(3,sorted_spikes,extracted_times,max_time,col_mat)

% for transitions
var_tune = 1;
edges = [0 5 5 Inf;5 Inf 0 1]; % each column corresponds to one type and one transition
t_window_inds = [-200 100]; % window range
% max_time = (t_window_inds(2)-t_window_inds(1))/500;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
