%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SETUP CLUSTERING
clear all
close all
drawnow
 
base_dir = {'/Users/sofroniewn/Documents/DATA/ephys_ex/run_06'};
sorted_name = 'klusters_data_again_concat';
over_write_sorted = 1;
dir_num = 1;
sorted_spikes = extract_sorted_units_klusters(base_dir,sorted_name,dir_num,over_write_sorted);

% Load in behaviour data
base_path_behaviour = fullfile(base_dir{dir_num}, 'behaviour');
session = load_session_data(base_path_behaviour);
session = parse_session_data(1,session);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inspect sorted units across entire session

trial_range = [0:1000];

clust_id = 1;




plot_spike_raster(1000*(dir_num-1)+1,clust_id,sorted_spikes,trial_range)
plot_isi_full(1000*(dir_num-1)+10,clust_id,sorted_spikes,trial_range)
plot_waveforms_chan(1000*(dir_num-1)+20,clust_id,sorted_spikes,trial_range,'avg')
%plot_waveforms_chan(clust_id,sorted_spikes,trial_range,'')
%plot_waveforms_chan_norm(clust_id,sorted_spikes,trial_range)
behaviour_vector = 20*session.trial_info.mean_speed;
plot_stability_full(1000*(dir_num-1)+30,clust_id,sorted_spikes,behaviour_vector)
xlim([min(trial_range) max(trial_range)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT SPEED
x_vars = cell(7,1);
x_vars{1}.str = 'session.data{trial_id}.processed_matrix(5,:)';
x_vars{1}.name = 'Speed';
x_vars{1}.vals = [0 Inf];
x_vars{1}.type = 'range';
x_vars{2}.str = 'session.data{trial_id}.trial_matrix(9,:)';
x_vars{2}.name = 'ITI';
x_vars{2}.vals = 0;
x_vars{2}.type = 'equal';
x_vars{3}.str = 'session.data{trial_id}.trial_matrix(5,:)/10';
x_vars{3}.name = 'laser_power';
x_vars{3}.vals = [0 Inf];
x_vars{3}.type = 'range';
x_vars{4}.str = 'session.data{trial_id}.processed_matrix(1,:)';
x_vars{4}.name = 'Time';
x_vars{4}.vals = [1 4];
x_vars{4}.type = 'range';
x_vars{5}.str = 'session.data{trial_id}.trial_matrix(3,:)';
x_vars{5}.name = 'Cor_pos';
x_vars{5}.vals = [0 30];
x_vars{5}.type = 'range';
x_vars{6}.str = 'session.data{trial_id}.trial_matrix(8,:)';
x_vars{6}.name = 'Trial_id';
x_vars{6}.vals = find(~session.trial_config.processed_dat.vals.trial_type);
x_vars{6}.type = 'equal';
x_vars{7}.str = 'session.data{trial_id}.processed_matrix(8,:)';
x_vars{7}.name = 'Trial_num';
x_vars{7}.vals = trial_range;
x_vars{7}.type = 'range';


var_tune = 1;
edges = [0 5 Inf]; % each interval corresponds to one type
t_window_inds = 25; % 200 ms window
plot_on = 0;

x_vals = edges(1:end-1);

% make full variable array for small variable array
[full_vars col_mat] = expand_behavioural_types(x_vars,var_tune,edges);

% extract num spikes in each time window where conditions are true
[extracted_times max_time] = extract_time_windows(session,full_vars,t_window_inds,trial_range);

% either plot rasters or make tuning curves with error bars
group_ids = [1:length(edges)-1];
tuning_curve = plot_spike_raster_time_windows(clust_id,sorted_spikes,extracted_times,group_ids,max_time,col_mat,plot_on);
tuning_curve.x_vals = x_vals;
fig_id = 1000*(dir_num-1)+60;
plot_tuning_curves(fig_id,tuning_curve)
set(gcf,'Position',[785   637   367   360])
xlim([-3 8])
xlabel('Not running / Running')
ylabel('Firing rate')
set(gca,'xtick',[])
title(['Cluster Id ' num2str(clust_id)])

% PLOT CORRIDOR TUNING OL
if dir_num == 1
edges = find(~session.trial_config.processed_dat.vals.trial_type); % each interval corresponds to one type
x_vals = session.trial_config.processed_dat.vals.trial_ol_vals(2:13,2);

%edges = find(session.trial_config.processed_dat.vals.trial_type); % each interval corresponds to one type
%x_vals = [1:length(edges)];

x_vars = cell(7,1);
x_vars{1}.str = 'session.data{trial_id}.processed_matrix(5,:)';
x_vars{1}.name = 'Speed';
x_vars{1}.vals = [5 Inf];
x_vars{1}.type = 'range';
x_vars{2}.str = 'session.data{trial_id}.trial_matrix(9,:)';
x_vars{2}.name = 'ITI';
x_vars{2}.vals = 0;
x_vars{2}.type = 'equal';
x_vars{3}.str = 'session.data{trial_id}.trial_matrix(5,:)/10';
x_vars{3}.name = 'laser_power';
x_vars{3}.vals = [0 0.5];
x_vars{3}.type = 'range';
x_vars{4}.str = 'session.data{trial_id}.processed_matrix(1,:)';
x_vars{4}.name = 'Time';
x_vars{4}.vals = [1 4];
x_vars{4}.type = 'range';
x_vars{5}.str = 'session.data{trial_id}.trial_matrix(3,:)';
x_vars{5}.name = 'Cor_pos';
x_vars{5}.vals = [0 30];
x_vars{5}.type = 'range';
x_vars{6}.str = 'session.data{trial_id}.trial_matrix(8,:)';
x_vars{6}.name = 'Trial_id';
x_vars{6}.vals = find(~session.trial_config.processed_dat.vals.trial_type);
x_vars{6}.type = 'equal';
x_vars{7}.str = 'session.data{trial_id}.processed_matrix(8,:)';
x_vars{7}.name = 'Trial_num';
x_vars{7}.vals = trial_range;
x_vars{7}.type = 'range';

var_tune = 6;
t_window_inds = 25; % 200 ms window
plot_on = 0;


% make full variable array for small variable array
[full_vars col_mat] = expand_behavioural_types(x_vars,var_tune,edges);

% extract num spikes in each time window where conditions are true
[extracted_times max_time] = extract_time_windows(session,full_vars,t_window_inds,trial_range);

% either plot rasters or make tuning curves with error bars
group_ids = [1:length(edges)];
tuning_curve = plot_spike_raster_time_windows(clust_id,sorted_spikes,extracted_times,group_ids,max_time,col_mat,plot_on);
tuning_curve.x_vals = x_vals;
fig_id = 1000*(dir_num-1)+40;
plot_tuning_curves(fig_id,tuning_curve)
text(25,0,['Trl Rng ' num2str(trial_range)])

set(gcf,'Position',[1170         637         367         360])
%xlim([-3 8])
xlabel('Wall distance')
ylabel('Firing rate')
title(['Cluster Id ' num2str(clust_id)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

if dir_num == 2
% Plot spike raster's, splitting according to trial types
% LASER POWER
group_ids = [0 2 3 4 Inf];
groups = 10*session.trial_info.max_laser_power;
col_mat = [0 0 0;.3 0 0; .6 0 0; 1 0 0];


plot_spike_raster_groups(clust_id,sorted_spikes,trial_range,groups,group_ids,col_mat);
%plot([2 2],[0 200],'k')
xlim([2 3])
set(gcf,'Position',[385   194   389   345])
%xlim([-3 8])
xlabel('Wall distance')
ylabel('Firing rate')
title(['Cluster Id ' num2str(clust_id)])

% PLOT LASER POWER TUNING


edges = [1:session.trial_config.processed_dat.vals.num_trial_types]; % each interval corresponds to one type

x_vars = cell(6,1);
x_vars{1}.str = 'session.data{trial_id}.processed_matrix(5,:)';
x_vars{1}.name = 'Speed';
x_vars{1}.vals = [0 Inf];
x_vars{1}.type = 'range';
x_vars{2}.str = 'session.data{trial_id}.trial_matrix(9,:)';
x_vars{2}.name = 'ITI';
x_vars{2}.vals = 0;
x_vars{2}.type = 'equal';
x_vars{3}.str = 'session.data{trial_id}.trial_matrix(5,:)/10';
x_vars{3}.name = 'laser_power';
x_vars{3}.vals = [0 Inf];
x_vars{3}.type = 'range';
x_vars{4}.str = 'session.data{trial_id}.processed_matrix(1,:)';
x_vars{4}.name = 'Time';
x_vars{4}.vals = [2 3];
x_vars{4}.type = 'range';
x_vars{5}.str = 'session.data{trial_id}.trial_matrix(3,:)';
x_vars{5}.name = 'Cor_pos';
x_vars{5}.vals = [0 30];
x_vars{5}.type = 'range';
x_vars{6}.str = 'session.data{trial_id}.trial_matrix(8,:)';
x_vars{6}.name = 'Trial_num';
x_vars{6}.vals = find(~session.trial_config.processed_dat.vals.trial_type);
x_vars{6}.type = 'equal';

var_tune = 6;
t_window_inds = 25; % 200 ms window
plot_on = 0;

x_vals = edges;

% make full variable array for small variable array
[full_vars col_mat] = expand_behavioural_types(x_vars,var_tune,edges);

% extract num spikes in each time window where conditions are true
[extracted_times max_time] = extract_time_windows(session,full_vars,t_window_inds,trial_range);

% either plot rasters or make tuning curves with error bars
group_ids = [1:length(edges)];
tuning_curve = plot_spike_raster_time_windows(clust_id,sorted_spikes,extracted_times,group_ids,max_time,col_mat,plot_on);
tuning_curve.x_vals = x_vals;
fig_id = 1000*(dir_num-1)+50;
plot_tuning_curves(fig_id,tuning_curve)
set(gcf,'Position',[789   186   367   360])
%xlim([-3 8])
xlabel('Trial ID')
ylabel('Firing rate ratio')
title(['Cluster Id ' num2str(clust_id)])
text(0,15,sprintf('%f',tuning_curve.means(end)/tuning_curve.means(1)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end



























%% SCRAP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Visualize unit data trial by trial
% file_list = func_list_files(base_dir,f_name_flag,file_nums);
% 
% trial_id = 11;
% [s p d] = load_ephys_trial(base_dir,file_list,trial_id);
% 
% clust_id = 4;
% spike_inds = sorted_spikes{clust_id}.trial_num == trial_id;
% spike_times = sorted_spikes{clust_id}.ephys_time(spike_inds);
% 
% figure(43)
% clf(43)
% hold on
% %plot(d.TimeStamps,-d.aux_chan(:,3)/5,'k') % trial start
% %plot(d.TimeStamps,-d.aux_chan(:,1)/5,'b') % laser power
% 
% plot(spike_times,0,'.k') % plot spikes
% plot(session.data{trial_id}.processed_matrix(1,:),-(1-session.data{trial_id}.trial_matrix(9,:)),'r') % trial start
% plot(session.data{trial_id}.processed_matrix(1,:),session.data{trial_id}.trial_matrix(5,:),'g') % laser power
% 
% 
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
