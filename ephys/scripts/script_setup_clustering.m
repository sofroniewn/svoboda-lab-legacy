%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SETUP CLUSTERING
clear all
close all
drawnow
batch_mode = cell(1,1);


batch_mode{1}.base_dir = {'/Users/sofroniewn/Documents/DATA/ephys_ex/artifact/run_09/'};
batch_mode{1}.file_nums = {[1:4]};
batch_mode{1}.cluster_name = 'klusters_data';

%batch_mode{2}.base_dir = {'/Users/sofroniewn/Documents/DATA/ephys_ex/run_06'};
%batch_mode{2}.file_nums = {[1:2],3};
%batch_mode{2}.cluster_name = 'klusters_data_again';


% batch_mode{2}.base_dir = {'Z:\EPHYS_RIG\DATA\anm_241133\2014_06_01\run_02\'};
% batch_mode{2}.file_nums = {[91:200]};
% batch_mode{2}.cluster_name = 'klusters_data_new2';
% 
% batch_mode{3}.base_dir = {'Z:\EPHYS_RIG\DATA\anm_241133\2014_06_01\run_02\'};
% batch_mode{3}.file_nums = {[210:340]};
% batch_mode{3}.cluster_name = 'klusters_data_new3';
 
% batch_mode{4}.base_dir = {'Z:\EPHYS_RIG\DATA\anm_241133\2014_06_01\run_02\'};
% batch_mode{4}.file_nums = {[345:405]};
% batch_mode{4}.cluster_name = 'klusters_data_new4';

% TO PREPARE DATA FOR KLUSTERS
over_write_vlt = 0;
over_write_spikes = 0;
failed = func_spike_sort_klusters(batch_mode,over_write_vlt,over_write_spikes);

%%
i_batch = 2;
merge_klusters_files(batch_mode,i_batch);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
