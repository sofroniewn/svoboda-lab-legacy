%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% laser base_dir
anm_num = 235585;
base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_235585/2014_06_04/run_04'; % laser data
lase_data_name = 'laser_data_short_new.mat';
trial_range = 1:20;
keep_powers_num = 1;
layer_4 = 17.6;
ch_exclude = [11];


anm_num = 237723;
base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_04'; %laser
lase_data_name = 'laser_data_short_new.mat';
trial_range = 20:40;
keep_powers_num = 1;
layer_4 = 19.5;
ch_exclude = [11];


anm_num = 245916;
base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_245916/2014_06_20/run_04'; %laser data
lase_data_name = 'laser_data_short.mat';
trial_range = 1:40;
keep_powers_num = 2:3;
layer_4 = 26.8;
ch_exclude = [12];



anm_num = 245918;
base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_245918/2014_06_21/run_03'; %laser data
lase_data_name = 'laser_data_short.mat';
trial_range = 20:40;
keep_powers_num = 1;
layer_4 = 21.6;
ch_exclude = [12];


anm_num = 245914;
base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_245914/2014_06_23/run_06'; %laser
lase_data_name = 'laser_data_short.mat';
trial_range = 20:40;
keep_powers_num = 1;
layer_4 = NaN;
ch_exclude = [12];


anm_num = 247868;
base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_247868/2014_06_26/run_03'; %laser
lase_data_name = 'laser_data_short.mat';
trial_range = 20:40;
keep_powers_num = 2:3;
layer_4 = 23.1;
ch_exclude = [12];


anm_num = 246699;
base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_246699/2014_07_23/run_03'; %laser
lase_data_name = 'laser_data_short.mat';
trial_range = 20:40;
keep_powers_num = 1;
layer_4 = 12.9;
ch_exclude = [12];



base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_249872/2014_06_27/run_03'; %laser
lase_data_name = 'laser_data_short.mat';
trial_range = 20:40;
keep_powers_num = 1;
layer_4 = 18.5;
ch_exclude = [12];




base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_246701/2014_07_23/run_03'; %laser
lase_data_name = 'laser_data_short.mat';
trial_range = 20:40;
keep_powers_num = 1;
layer_4 = 17.3;
ch_exclude = [12];


base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_246702/2014_08_14/run_04'; %laser
lase_data_name = 'laser_data_short.mat';
trial_range = 20:40;
keep_powers_num = 2:3;
layer_4 = 21.3;
ch_exclude = [4 15];


base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250492/2014_08_15/run_03'; %laser
lase_data_name = 'laser_data_short.mat';
trial_range = 20:40;
keep_powers_num = 1;
layer_4 = 15.3;
ch_exclude = [20];



base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250494/2014_08_21/run_03'; %laser
lase_data_name = 'laser_data_short.mat';
trial_range = 20:40;
keep_powers_num = 1;
layer_4 = 18.9;
ch_exclude = [20];


base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250495/2014_08_14/run_03'; %laser
lase_data_name = 'laser_data_short.mat';
trial_range = 20:40;
keep_powers_num = 1;
layer_4 = 17.5;
ch_exclude = [12];


base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_247871/2014_08_20/run_03'; %laser
lase_data_name = 'laser_data_short.mat';
trial_range = 20:40;
keep_powers_num = 3;
layer_4 = 18.3;
ch_exclude = [20];


base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250496/2014_09_04/run_04'; %laser
lase_data_name = 'laser_data_short_new.mat';
trial_range = 5:25;
keep_powers_num = 1;
layer_4 = 27.4;
ch_exclude = [20];


base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_252776/2014_09_02/run_03'; %laser
lase_data_name = 'laser_data_short_new.mat';
trial_range = 60:90;
keep_powers_num = 1:4;
layer_4 = 28.7;
ch_exclude = [4 7 15];


base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_256043/2014_09_03/run_02'; %laser
lase_data_name = 'laser_data_short_new.mat';
trial_range = 60:90;
keep_powers_num = 1:2;
layer_4 = 28.7;
ch_exclude = [20];

%%
ij = 13;
all_anm.names{ij}
[base_dir anm_params] = ephys_anm_id_database(all_anm.names{ij},0)
trial_range =  [anm_params.trial_range_start(1):min(anm_params.trial_range_end(1),4000)];
laser_data = all_anm.data{ij}.laser_data;
keep_powers_num = [3:5];
trial_range = [1:4000];
ch_exclude = [12];
time_range = [];
layer_4 = 14.6;

ij = 14;
all_anm.names{ij}
[base_dir anm_params] = ephys_anm_id_database(all_anm.names{ij},0)
trial_range =  [anm_params.trial_range_start(1):min(anm_params.trial_range_end(1),4000)];
laser_data = all_anm.data{ij}.laser_data;
keep_powers_num = [3:5];
trial_range = [1:4000];
ch_exclude = [14 15 18];
time_range = [];
layer_4 = 5.4;

ij = 15;
all_anm.names{ij}
[base_dir anm_params] = ephys_anm_id_database(all_anm.names{ij},0)
trial_range =  [anm_params.trial_range_start(1):min(anm_params.trial_range_end(1),4000)];
laser_data = all_anm.data{ij}.laser_data;
keep_powers_num = [3:5];
trial_range = [1:4000];
ch_exclude = [12];
time_range = [];
layer_4 = 6.4;

ij = 16;
all_anm.names{ij}
[base_dir anm_params] = ephys_anm_id_database(all_anm.names{ij},0)
trial_range =  [anm_params.trial_range_start(1):min(anm_params.trial_range_end(1),4000)];
laser_data = all_anm.data{ij}.laser_data;
keep_powers_num = [3:5];
trial_range = [1:4000];
ch_exclude = [2 4 7 13 15 16 20];
time_range = [];
layer_4 = 21.4;

ij = 17;
all_anm.names{ij}
[base_dir anm_params] = ephys_anm_id_database(all_anm.names{ij},0)
trial_range =  [anm_params.trial_range_start(1):min(anm_params.trial_range_end(1),4000)];
laser_data = all_anm.data{ij}.laser_data;
keep_powers_num = [3:5];
trial_range = [1:4000];
ch_exclude = [12];
time_range = [];
layer_4 = 23.4;

ij = 18;
all_anm.names{ij}
[base_dir anm_params] = ephys_anm_id_database(all_anm.names{ij},0)
trial_range =  [anm_params.trial_range_start(1):min(anm_params.trial_range_end(1),4000)];
laser_data = all_anm.data{ij}.laser_data;
keep_powers_num = [3:5];
trial_range = [1:4000];
ch_exclude = [2 4 7 13 15 16 20];
time_range = [];
layer_4 = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CSD
[laser_data] = func_extract_laser_power(base_dir, trial_range, lase_data_name, 0);
power_values = round(laser_data.max_power*10);
power_range = unique(power_values(~isnan(power_values)));
keep_powers = power_range(keep_powers_num);

trial_range = [1:4000];
CSD = get_CSD(laser_data,trial_range,power_values,keep_powers,ch_exclude,time_range);
figure('Position',[443   376   789   430]); plot_CSD([],CSD,'CSD')
figure('Position',[73   361   338   186]); plot_CSD([],CSD,'LFP')
figure('Position',[73   103   338   186]); plot_CSD([],CSD,'traces')
figure('Position',[73   103   338   186]); plot_CSD([],CSD,'profile')



base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250492/2014_08_15/run_03'; %laser
lase_data_name = 'laser_data_short.mat';
trial_range = 20:40;
keep_powers_num = 1;
layer_4 = 15.3;
ch_exclude = [20];
time_range = [];

figure('Position',[443   376   789   430]); plot_CSD([],CSD,'CSD')
set(gca,'ydir','normal')
set(gca,'visible','off')
   set(gca,'LineWidth',2)
   set(gca,'layer','top')
set(gca,'TickDir','out')
xlim([-2 10])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%




%% CSD

trial_range = [1:20];
[laser_data] = func_extract_laser_power(base_dir, trial_range, 'laser_data_short', 0);

power_values = round(laser_data.max_power*10);
power_range = unique(power_values);
keep_powers = power_range;
ch_exclude = [3:13];

CSD = get_CSD(laser_data,trial_range,power_values,keep_powers,ch_exclude);
figure('Position',[73   620   338   186]); plot_CSD([],CSD,'CSD')
figure('Position',[73   361   338   186]); plot_CSD([],CSD,'LFP')
figure('Position',[73   103   338   186]); plot_CSD([],CSD,'traces')


%% Evoked potentials
clust_id = 13;

spike_times = sorted_spikes{clust_id}.ephys_time;
spike_trials = sorted_spikes{clust_id}.trial_num;
first_only = 0;
RASTER = get_evoked_spike_probability(spike_times,spike_trials,trial_range,laser_data,first_only)
figure; plot_spk_psth([],RASTER)
figure; plot_spk_raster([],RASTER)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



trial_range = [1:20];
[laser_data] = func_extract_laser_power(base_dir, trial_range, 'laser_data_short', 1);

laser_onset = find(laser_data.time_window == 0);
avg_vlt = squeeze(mean(laser_data.raw_vlt(:,:,:),1));
%avg_vlt = squeeze(laser_data.raw_vlt(2,:,:));
avg_vlt = bsxfun(@minus,avg_vlt,mean(avg_vlt(:,(laser_onset-50):laser_onset),2));

CSD = diff(avg_vlt,2,1);
avg_vlt(end,:) = [];
avg_vlt(end,:) = [];
avg_vlt(1,:) = [];
CSD(end,:) = [];
CSD = conv2(CSD,ones(30,1),'same');

offset_shift = repmat([1:size(avg_vlt,1)]',1,size(avg_vlt,2));
figure(4); plot(laser_data.time_window,avg_vlt'+offset_shift'*10^-4)
figure(5); imagesc([laser_data.time_window(1) laser_data.time_window(end)],[1 size(avg_vlt,1)],flipdim(avg_vlt,1))
figure(6); imagesc([laser_data.time_window(1) laser_data.time_window(end)],[1 size(avg_vlt,1)],flipdim(CSD,1))




avg_vlt = aa.pot1;
%avg_vlt = squeeze(laser_data.raw_vlt(2,:,:));
CSD = diff(avg_vlt,2,1);
avg_vlt(end,:) = [];
avg_vlt(end,:) = [];
avg_vlt(1,:) = [];
CSD(end,:) = [];
CSD = conv2(CSD,ones(4,4),'same');

offset_shift = repmat([1:size(avg_vlt,1)]',1,size(avg_vlt,2));
figure(4); plot(avg_vlt'+offset_shift'*10^3)
figure(5); imagesc([laser_data.time_window(1) laser_data.time_window(end)],[1 size(avg_vlt,1)],flipdim(avg_vlt,1))
figure(6); imagesc([laser_data.time_window(1) laser_data.time_window(end)],[1 size(avg_vlt,1)],flipdim(CSD,1))





aa = avg_vlt(:,laser_onset+100);
aa = smooth(aa,2,'sgolay');
figure; plot(aa)
hold on
plot(diff(aa,2),'r')


laser_data.raw_vlt(2,:,:) - laser_data.raw_vlt(1,:,:)

clust_id = 13;
first_only = 0;
plot_evoked_spike_probability(1000*(dir_num-1)+11,clust_id,sorted_spikes,trial_range,laser_data,first_only);
%%

