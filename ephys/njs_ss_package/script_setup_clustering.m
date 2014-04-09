%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SETUP CLUSTERING
clear all
%close all
%drawnow

ch_common_noise = [3, 27:29, 32];
ch_spikes = [1:2, 4:26, 30:31];

base_dir = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0221172/2014_02_21/run_09';
base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_225493/2013_12_12/run_06';
f_name_flag = '*_trial*.bin';
file_nums = [1:1000];
over_write = 0;
over_write_spikes = 0;
over_write_cluster = 0;
cluster_name = 'matclust_data_B.mat';

file_list = func_list_files(base_dir,f_name_flag,file_nums);

func_concat_raw_voltages(base_dir,file_list);


[ch_data] = func_spike_sort(base_dir,file_list,cluster_name,ch_common_noise,ch_spikes,over_write,over_write_spikes,over_write_cluster);

%% Start matclust
cd('/Users/sofroniewn/Documents/code/external/matclust_v1.2')
matclust(ch_data)

%% Load clustered data
load('/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0221172/2014_02_21/run_09/ephys/sorted/matclust_sorted.mat')
global clustattrib
global clustdata

%% Quick, global inspection of sorted data
clust_id = 6;
ISIviewer_njs(clust_id);
wavesViewer_njs(clust_id);
rasterViewer_njs(clust_id);
stabilityViewer_njs(clust_id);

%% Inspect sorted units trial by trial
trial_id = 20;
[s p d] = load_ephys_trial(base_dir,file_list,trial_id);

clust_id = 6;
show_not_clustered = 0;
show_artifact = 0;

plot_spike_overlay(clust_id,trial_id,[],s,d);
plot_waveforms_across_channel(clust_id,trial_id,[],s,d,show_not_clustered,show_artifact);
plot_isi(clust_id,trial_id,[],s,d);

%% Extract sorted units
over_write = 1;
[sorted_spikes sync_trigs] = extract_sorted_units(base_dir,file_list,'sorted_units_A',over_write);

%% Inspect sorted units
plot_spike_raster(clust_id,sorted_spikes)
plot_isi_full(clust_id,sorted_spikes)
plot_waveforms_full(clust_id,sorted_spikes)
plot_stability_full(clust_id,sorted_spikes,[])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Extract laser power onset, offset, and magnitude for each trial
laser_power_name = 'laser_data_A.mat';
over_write = 1;
[laser_data] = func_extract_laser_power(base_dir, file_list, laser_power_name, over_write);

groups = round(laser_data.laser_power*10);
group_ids = unique(groups);
col_mat = [0 0 0;.3 0 0; .6 0 0; 1 0 0];
plot_spike_raster_groups(7,sorted_spikes,groups,group_ids,col_mat);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

