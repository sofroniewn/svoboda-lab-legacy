%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SETUP CLUSTERING
clear all
%close all
%drawnow

base_dir = 'Z:\EPHYS_RIG\DATA\anm_245128\2014_05_09\run_02';
base_dir = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0221172/2014_02_21/run_09';
base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_225493/2013_12_12/run_06';
base_dir = '/Users/sofroniewn/Documents/DATA/ephys_ex/run_06';

f_name_flag = '*_trial*.bin';
file_nums = [1:3];
cluster_name = 'klusters_data';

%% TO PREPARE DATA FOR KLUSTERS
over_write_vlt = 0;
over_write_spikes = 0;
over_write_klusters = 1;
file_list = func_spike_sort_klusters(base_dir,f_name_flag,file_nums,cluster_name,over_write_vlt,over_write_spikes,over_write_klusters);

%% TO EXTRACT CLU FILE
over_write_sorted = 1;
sorted_spikes = extract_sorted_units_klusters(base_dir,cluster_name,over_write_sorted);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inspect sorted units across entire session

trial_range = [0 Inf];

clust_id = 1;

plot_spike_raster(clust_id,sorted_spikes,trial_range)
plot_isi_full(clust_id,sorted_spikes,trial_range)
plot_waveforms_chan(clust_id,sorted_spikes,trial_range)
plot_waveforms_chan_norm(clust_id,sorted_spikes,trial_range)
plot_stability_full(clust_id,sorted_spikes,[])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
