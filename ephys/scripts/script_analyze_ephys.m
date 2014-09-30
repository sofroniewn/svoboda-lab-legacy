%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SETUP CLUSTERING
clear all
close all
drawnow
all_anm_id = {'235585','237723','245918','249872','246702','250492','250494','250495','247871','250496','256043','252776'};
for ih = 1:numel(all_anm_id)
%anm_id = '237723';
anm_id = all_anm_id{ih};
laser_on = 0;
[base_dir trial_range_start exp_type layer_4] = ephys_anm_id_database(anm_id,laser_on);

global trial_range; trial_range = [trial_range_start:4000];

%base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250492/2014_08_15/run_02'; %anm #1 for olR and olB and olL
%base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250495/2014_08_14/run_03'; %anm #2 for olR and olB and olL

% Load in ephys data
sorted_name = 'klusters_data';
over_write_sorted = 0;
dir_num = 1;
global sorted_spikes;
sorted_spikes = extract_sorted_units_klusters(base_dir,sorted_name,dir_num,over_write_sorted);

% Load in behaviour data
base_path_behaviour = fullfile(base_dir, 'behaviour');
global session;
session = load_session_data(base_path_behaviour);
session = parse_session_data(1,session);

% Load in summary data
global ephys_summary;
f_name_summary = fullfile(base_dir,'ephys',['summary_data.mat']);
if exist(f_name_summary) == 2
    load(f_name_summary,'summary_data','summary_data_labels');
    ephys_summary.d = summary_data;
    ephys_summary.labels = summary_data_labels;
    ephys_summary.layer_4 = layer_4;
else
    ephys_summary = [];
end
    ephys_summary = [];

if strcmp(anm_id,'237723')
   sorted_spikes = sorted_spikes(1:30);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PUBLISH PLOTS OF CLUSTERS

all_clust_ids = 3:numel(sorted_spikes);
plot_on = 0;
d = [];
d = summarize_cluster_params(d,ephys_summary,all_clust_ids,sorted_spikes,session,exp_type,trial_range,layer_4);

cd('/Users/sofroniewn/Documents/DATA/ephys_summary');
save(['./' anm_id '_d'],'d','-v7.3');
end
% num2clip(d.p_nj)
% %%


summarize_name = 'summarize_cluster_new_wall_dist'; % 'publish_ephys.m' or 'publish_ephys_new.m'
create_publish_ephys(summarize_name);
outputDir = ['anm_' anm_id '_summary_A'];

cd('/Users/sofroniewn/Documents/DATA/ephys_summary');
publish('publish_ephys.m','showCode',false,'outputDir',outputDir); close all;
num2clip(d.p_nj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CSD
[laser_data] = func_extract_laser_power(base_dir, trial_range, lase_data_name, 0);
power_values = round(laser_data.max_power*10);
power_range = unique(power_values);
keep_powers = power_range(keep_powers_num);

CSD = get_CSD(laser_data,trial_range,power_values,keep_powers,ch_exclude);
figure('Position',[443   376   789   430]); plot_CSD([],CSD,'CSD')
figure('Position',[73   361   338   186]); plot_CSD([],CSD,'LFP')
figure('Position',[73   103   338   186]); plot_CSD([],CSD,'traces')
figure('Position',[73   103   338   186]); plot_CSD([],CSD,'profile')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%





%%%%%%%%%%%%%%%%%%%%%%%
%% LOAD summary data without plotting
global id_type; id_type = 'olR';
all_clust_ids = 4 %[3:numel(sorted_spikes)];
plot_on = 1;
d = [];

%trial_range = [1:600];
all_clust_ids = 5 %[3:numel(sorted_spikes)];
d = summarize_cluster_new_wall_dist(d,ephys_summary,all_clust_ids,sorted_spikes,session,exp_type,id_type,trial_range,plot_on);
%%


figure(88)
clf(88)
plot(d.p_nj(:,5),d.p_nj(:,7),'.k');

figure(99)
hist(d.p_nj(:,5),10)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Inspect sorted units across entire session
%[laser_data] = func_extract_laser_power(base_dir, trial_range, 'laser_data', 0);

[group_ids groups] = define_group_ids(exp_type,'olR',[]);
%group_ids = 3;
keep_trials = ismember(d.u_ck(1,:),group_ids) & d.u_ck(2,:) > 5;

wall_pos = flipdim(squeeze(d.s_ctk(1,:,keep_trials))',1);
run_var = flipdim(squeeze(d.s_ctk(6,:,keep_trials))',1);

run_var = run_var - mean(run_var(:));
run_var(run_var>100) = 100;
run_var(run_var<-100) = -100;

gap = [0.0355 0.0355];
marg_h = [0.08 0.03];
marg_w = [0.03 0.01];

fil = triang(100)';
figure(114)
clf(114)
subtightplot(2,2,1,gap,marg_h,marg_w)
imagesc(wall_pos)
subtightplot(2,2,2,gap,marg_h,marg_w)
h = imagesc(run_var-5);
%set(h, 'AlphaData', run_speed>1)
colormap('gray')



imagesc(conv2(flipdim(squeeze(d.r_ntk(26,:,keep_trials))',1),fil,'same'));
subplot(4,3,5)
imagesc(conv2(flipdim(squeeze(d.r_ntk(13,:,keep_trials))',1),fil,'same'));
subplot(4,3,6)
imagesc(conv2(flipdim(squeeze(d.r_ntk(1,:,keep_trials))',1),fil,'same'));
subplot(4,3,7)
imagesc(conv2(flipdim(squeeze(d.r_ntk(3,:,keep_trials))',1),fil,'same'));
subplot(4,3,8)
imagesc(conv2(flipdim(squeeze(d.r_ntk(11,:,keep_trials))',1),fil,'same'));
subplot(4,3,9)
imagesc(conv2(flipdim(squeeze(d.r_ntk(17,:,keep_trials))',1),fil,'same'));
subplot(4,3,10)
imagesc(conv2(flipdim(squeeze(d.r_ntk(12,:,keep_trials))',1),fil,'same'));
subplot(4,3,11)
imagesc(conv2(flipdim(squeeze(d.r_ntk(25,:,keep_trials))',1),fil,'same'));
subplot(4,3,12)
imagesc(conv2(flipdim(squeeze(d.r_ntk(22,:,keep_trials))',1),fil,'same'));

% cmap = ones(60,3);
% cmap(:,2) = linspace(1,0,60);
% cmap(:,1) = linspace(1,0,60);
% colormap(flipdim(cmap,1));



figure(114)
clf(114)
imagesc(wall_pos)
axis off
cmap = ones(60,3);
cmap(:,2) = linspace(1,0,60);
cmap(:,1) = linspace(1,0,60);
colormap(flipdim(cmap,1));


figure(121)
clf(121)
hold on
aa = unique(wall_pos(:,1000))
cmap = zeros(length(aa),3);
cmap(:,3) = linspace(1,0,length(aa));
for ij = 1:length(aa)
    ind = find(wall_pos(:,1000) == aa(ij),1,'first');
    plot(d.t,wall_pos(ind,:),'color',cmap(ij,:),'linewidth',2)
end
xlim([0 4])
xlabel('Time (s)')
ylabel('Wall distance (mm)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% 2D plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%

fig_props = []
% wall dist when wall moving
clust_id = 5;

keep_name = 'ol_running';
exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl';
id_type = 'olR';
time_range = [0 4];
stim_name = 'wall_direction';
stim_name2 = 'corPos';
tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type,time_range);
figure(4);clf(4); plot_tuning_curve_multi_ephys(fig_props,tuning_curve)

% wall dist when running left / right
clust_id = 5;

keep_name = 'ol_running';
exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl';
id_type = 'olR';
time_range = [0 4];
stim_name = 'run_direction';
stim_name2 = 'corPos';
tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type,time_range);
figure(4);clf(4); plot_tuning_curve_multi_ephys(fig_props,tuning_curve)

% wall dist when not running, running slow & fast
clust_id = 5;

keep_name = 'ol_base';
exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl';
id_type = 'olR';
time_range = [0 4];
stim_name = 'running_fast';
stim_name2 = 'corPos';
tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type,time_range);
figure(4);clf(4); plot_tuning_curve_multi_ephys(fig_props,tuning_curve)

% wall dist when running, whisking slow & fast
clust_id = 5;
keep_name = 'ol_running';
exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl';
id_type = 'olR';
time_range = [0 4];
stim_name = 'whisking';
stim_name2 = 'corPos';
tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type,time_range);
figure(4);clf(4); plot_tuning_curve_multi_ephys(fig_props,tuning_curve)

% wall dist when not running, whisking slow & fast
clust_id = 5;
keep_name = 'ol_not_running';
exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl';
id_type = 'olR';
time_range = [0 4];
stim_name = 'whisking';
stim_name2 = 'corPos';
tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type,time_range);
figure(4);clf(4); plot_tuning_curve_multi_ephys(fig_props,tuning_curve)





clust_id = 5;
keep_name = 'ol_base';
exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl';
id_type = 'olR';
time_range = [0 4];
stim_name = 'speed';
stim_name2 = 'corPos';
tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type,time_range);
figure(3);clf(3); plot_tuning_curve_2D_ephys([],tuning_curve)


% wall dist when not running, whisking slow & fast
clust_id = 21;
keep_name = 'ol_base';
exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl';
id_type = 'olR';
time_range = [0 4];
stim_name = 'touch';
stim_name2 = 'speed';
tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type,time_range);
figure(5);clf(5); plot_tuning_curve_multi_ephys(fig_props,tuning_curve)


% wall dist when not running, whisking slow & fast
clust_id = 21;
keep_name = 'ol_base';
exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl';
id_type = 'olR';
time_range = [0 4];
stim_name = 'touch';
stim_name2 = 'whisker_amp';
tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type,time_range);
figure(4);clf(4); plot_tuning_curve_multi_ephys(fig_props,tuning_curve)












fig_props = []
% wall dist when wall moving
clust_id = 23;

id_type = 'olR';
keep_name = 'ol_base';
exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl';

time_range = [0 4];
stim_name = 'whisker_amp';
stim_name2 = 'corPos';
tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type,time_range);
figure(4);clf(4); set(gcf,'Position',[440   590   282   208])
plot_tuning_curve_2D_ephys(fig_props,tuning_curve)




15 26 3 23
25 18 12 5




clust_id = 18;

figure(2)
clf(2)
set(gcf,'Position',[90   474   346   332])

fig_props = [];
gap = 0.1;
marg_h = [0.1 0.03];
marg_w = [0.1 0.1];


exp_type = 'classic_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl';
id_type = 'olR';
stim_name = 'speed';
keep_name = 'ol_whisking';
time_range = [0 4];
tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range);
%[peak_rate loc] = max(tuning_curve.model_fit.curve);
%peak_dist = tuning_curve.regressor_obj.x_fit_vals(loc);
%s_ind = find(strcmp(d.p_labels,'peak_rate'));
%s_ind = find(strcmp(d.p_labels,'peak_distance'));
tuning_curve.col_mat = [1 0 0];
subtightplot(3,2,[1 2],gap,marg_h,marg_w);
plot_tuning_curve_ephys(fig_props,tuning_curve)
%   text(.05,.96,sprintf('Peak rate %.2f Hz',peak_rate),'Units','Normalized','Color','r')
%   text(.05,.89,sprintf('Peak distance %.1f mm',peak_dist),'Units','Normalized','Color','r')

stim_name = 'whisker_amp';
keep_name = 'ol_whisking';
time_range = [0 4];
tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range);
tuning_curve.col_mat = [0 1 0];
subtightplot(3,2,[3 4],gap,marg_h,marg_w);
plot_tuning_curve_ephys(fig_props,tuning_curve)


stim_name = 'corPos';
keep_name = 'ol_whisking';
time_range = [0 4];
tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range);
subtightplot(3,2,[5 6],gap,marg_h,marg_w);
plot_tuning_curve_ephys(fig_props,tuning_curve)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



[group_ids groups] = define_group_ids(exp_type,'olR',[]);
%group_ids = 3;
keep_trials = ismember(d.u_ck(1,:),group_ids) & d.u_ck(2,:) > 5;

wall_pos = flipdim(squeeze(d.s_ctk(1,:,keep_trials))',1);
run_var = flipdim(squeeze(d.s_ctk(6,:,keep_trials))',1);

trial_plt_range = 240:300;
%trial_plt_range = 150:200;

mean_run = nanmean(run_var(trial_plt_range,:));
mean_wall = nanmean(wall_pos(trial_plt_range,:));
mean_run_sm = smooth(mean_run,100,'sgolay',1);
mean_run_sm = mean_run_sm - mean(mean_run_sm(1:100));
mean_run_sm = -mean_run_sm;
mean_wall = mean_wall - min(mean_wall);
mean_wall = mean_wall*100/mean_wall(1);

figure(17); clf(17);
hold on;
for ij = [4 8 5 6 15 19 25]  %11 22 23 24 %1:size(d.r_ntk,1)
    avg_fr = conv2(flipdim(squeeze(d.r_ntk(ij,:,keep_trials))',1),fil,'same');
    mean_curve = nanmean(avg_fr(trial_plt_range,:));
    mean_curve = mean_curve - mean(mean_curve(20:120));
    plot(d.t,100*mean_curve/max(abs(mean_curve)),'r','Linewidth',2)
end
plot(d.t,mean_wall,'b','Linewidth',4);
%plot(d.t,mean_run,'k');
plot(d.t,mean_run_sm,'k','Linewidth',4);

ylim([-10 100])
xlabel('Time (s)')
xlim([0 1.5])
%onset(onset>1000) = onset(onset>1000) - 10000;

[vals order] = sort(onset);

mean_reorder = mean_fr(order,:);

figure;
imagesc(cat(1,.4*zscore(mean_wall),.4*zscore(diff_angle'),0*zscore(diff_angle'),0*zscore(diff_angle'),0*zscore(diff_angle'),mean_reorder))


figure(333);
clf(333)
set(gcf,'Position',[5   229   861   569])
%subplot(2,2,1)
hold on
% avg_fr = conv2(flipdim(squeeze(r_ntk(1,:,:))',1),fil,'same');
% mean_curve = mean(avg_fr(30:end,100:end-100));
% plot(zscore(mean_curve),'linewidth',2)
for ij = 1:10 %size(r_ntk,1)
    %	plot(mean_reorder(ij,:),'b','linewidth',1)
end
for ij = 11:19 %size(r_ntk,1)
    %plot(mean_reorder(ij,:),'c','linewidth',1)
end
for ij = 20:size(r_ntk,1)
    %plot(mean_reorder(ij,:),'r','linewidth',1)
end

plot(zscore(diff_angle),'k','linewidth',4)
plot(zscore(mean(mean_reorder))+1,'r')
plot(zscore(mean_wall),'g','linewidth',2)

subplot(2,2,2)
hold on
scatter(diff_angle,mean_curve,[],-mean_wall)

subplot(2,2,3)
hold on
imagesc(flipdim(avg_fr,1))
axis tight

subplot(2,2,4)
hold on
scatter(mean_wall,mean_curve,[],diff_angle)


mean_curve = mean(avg_fr(13:25,:));
mean_vel = mean(avg_vel(13:25,:));
mean_wall = mean(avg_wall(13:25,:));
mean_for = mean(avg_for_speed(13:25,:));


%%
firing_rate = conv2(flipdim(squeeze(r_ntk(7,:,:))',1),fil,'same');
figure(43);
clf(43);
scatter3(wall_pos(:),lat_vel(:),firing_rate(:),[],firing_rate(:))




subplot(1,2,2)
hold on
plot(zscore(mean_curve),'linewidth',2)
plot(zscore(mean_vel)+1,'r')
plot(zscore(mean_wall),'g')
plot(zscore(mean_for)+1,'k')


fil = triang(100)';
mean_vel = mean(avg_vel(30:end,:));
mean_wall = mean(avg_wall(30:end,:));
mean_for = mean(avg_for_speed(30:end,:));

figure(334);
clf(334)
hold on
avg_fr = conv2(flipdim(squeeze(r_ntk(24,:,:))',1),fil,'same');
mean_curve = mean(avg_fr(30:end,:));
plot(zscore(mean_curve),'linewidth',2)


avg_fr = conv2(flipdim(squeeze(r_ntk(1,:,:))',1),fil,'same');
mean_curve = mean(avg_fr(30:end,:));
plot(zscore(mean_curve),'linewidth',2,'Color','k')

avg_fr = conv2(flipdim(squeeze(r_ntk(13,:,:))',1),fil,'same');
mean_curve = mean(avg_fr(30:end,:));
plot(zscore(mean_curve),'linewidth',2,'Color','g')

avg_fr = conv2(flipdim(squeeze(r_ntk(6,:,:))',1),fil,'same');
mean_curve = mean(avg_fr(30:end,:));
plot(zscore(mean_curve),'linewidth',2,'Color','c')


plot(zscore(mean_vel)+1,'r')
%plot(zscore(mean_wall),'g')
%plot(zscore(mean_for)+1,'k')









%%
firing_rate = conv2(flipdim(squeeze(r_ntk(26,:,:))',1),fil,'same');
figure(43);
clf(43);
scatter(wall_pos(1:5:end),lat_vel(1:5:end),[],firing_rate(1:5:end))





%psth_all = flipdim(psth_all,1);

psth_all_conv = conv2(psth_all,ones(1,100)/100,'same');

psth_all_conv = psth_all;

x_vel = conv2(500*diff(x_pos,1,2),ones(1,50)/50,'same');
y_vel = conv2(500*diff(y_pos,1,2),ones(1,50)/50,'same');


x_acc = conv2(500*diff(x_vel,1,2),ones(1,50)/50,'same');
y_acc = conv2(500*diff(y_vel,1,2),ones(1,50)/50,'same');



run_angle = 180/pi*atan2(x_vel,y_vel);
run_speed = sqrt(x_vel.^2 + y_vel.^2);
run_acc = 500*conv2(diff(run_angle,1,2),ones(1,50)/50,'same');
run_acc(run_acc>500) = 500;
run_acc(run_acc<-500) = -500;

figure(13);
clf(13)
hold on
%imagesc(conv2(diff(wall_dist,1,2),ones(1,50)/50,'same'));
%imagesc(-conv2(diff(y_pos,2,2),ones(1,50)/50,'same'));
%imagesc(wall_dist);
h = imagesc(run_speed);
%set(h, 'AlphaData', run_speed>5)
axis tight
for ij = 1:size(psth_all,1)
    spks = find(psth_all(ij,:)>0);
    if ~isempty(spks)
        hh = plot(spks,ij,'.','MarkerEdgeColor',[0.5 .5 .5],'MarkerSize',6,'MarkerFaceColor','none');
    end
end


%%%
fil = ones(1,100)/100;

psth_all_7 = psth_all;


s_ctk %c behav var, t time pts, k trials
r_ntk %n neurons, t time pts, k trials







all_spk = psth_all(:,2:end-1);
all_spk = all_spk(:);
all_dat = round(run_acc(:)/20);
all_dat = all_dat + 1 - min(all_dat);
spk_hist = accumarray(all_dat,all_spk,[],[],0);

all_spk = psth_all(:,1:end-1);
all_spk = all_spk(:);
all_dat = round(y_vel(:));
all_dat = all_dat + 1 - min(all_dat);
spk_hist = accumarray(all_dat,all_spk,[],[],0);
cnt_hist = accumarray(all_dat,ones(size(all_dat)),[],[],0);

figure; plot(spk_hist./cnt_hist)

run_speed

figure;
hold on
imagesc(wall_dist);
h = image(psth_all_conv);
axis off
set(h, 'AlphaData', psth_all_conv)



figure;
%imagesc(flipdim(wall_dist,1))
plot(psth_all>0,'.r')

% time_comb = session.data{1}.processed_matrix(1,501:end);
%
% figure(323);
% clf(323)
% set(gcf,'Position',[13   549   560   257])
%
% hold on
% for ij = 1:length(group_ids)
% 	trial_id = find(groups == group_ids(ij),1,'first');
% 	plot(session.data{trial_id}.processed_matrix(1,:),session.data{trial_id}.trial_matrix(3,:),'color',col_mat(ij,:),'LineWidth',3)
% end
% xlim([0 4])

%
% %figure(324);
% %clf(324)
% %hold on
% for ij = 1:size(psth_all,1)
% 	trial_id = find(groups == group_ids(ij),1,'first');
% 	all_sensory_curves(ij,:) = session.data{trial_id}.trial_matrix(3,501:end);
% 	%plot(time_comb,all_sensory_curves(ij,:),'color',col_mat(ij,:),'LineWidth',3)
% 	all_psth_curves(ij,:) = interp1(time_vec,psth_all(ij,:),time_comb);
% 	%plot(time_comb,all_psth_curves(ij,:)/100,'color',col_mat(ij,:));
% end
% %xlim([0 4])












session.trial_info.lateral_distance = zeros(size(session.trial_info.forward_distance));
for ij = 1:numel(session.data)
    session.trial_info.lateral_distance(ij) = session.data{ij}.processed_matrix(3,end); % forward distance
end
session.trial_info.run_angle = 180/pi*atan2(session.trial_info.lateral_distance,session.trial_info.forward_distance);


plot_spike_pair_corr(32,11,17,sorted_spikes,trial_range,[0 1 0])




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





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

%% 1 multi
%% 3 act / inh --- interesting
%% 5 act / inh
%% 7 act
%% 8 act
%% 13 act
%% 14 act trans on
%% 15 inh trans
%% 17 act trans on
%% 20 inh
%% 21 act trans on
%% 22 act
%% 23 act trans off
%% 24 act trans off
%% 24 act
%% 28 act trans both
%% 29 act trans both
%% 30 act trans both
%% 31 act


clust_id = 3;
time_range = [2 3];
plot_group_raster_summary(clust_id,dir_num,sorted_spikes,session,trial_range,time_range)




group_ids = find(session.trial_config.processed_dat.vals.trial_type);
groups = session.trial_info.inds;






group_ids = [0 2 3 4 Inf];
groups = 10*session.trial_info.max_laser_power;
col_mat = [0 0 0;.3 0 0; .6 0 0; 1 0 0];
plot_spike_raster_groups(1000*(dir_num-1)+12,clust_id,sorted_spikes,trial_range,groups,group_ids,col_mat,1);
%plot([2 2],[0 200],'k')
xlim([2 3])



plot_spike_raster(1000*(dir_num-1)+1,clust_id,sorted_spikes,trial_range)








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edges = [-40:4:40]; % each interval corresponds to one type
x_vals = edges;

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
x_vars{4}.vals = [0 1000];
x_vars{4}.type = 'range';
x_vars{5}.str = 'smooth([0;500*diff(smooth(session.data{trial_id}.trial_matrix(3,:),25))],25)';
%x_vars{5}.str = 'session.data{trial_id}.trial_matrix(3,:)';

x_vars{5}.name = 'Cor_pos';
x_vars{5}.vals = [0 30];
x_vars{5}.type = 'range';
x_vars{6}.str = 'session.data{trial_id}.trial_matrix(8,:)';
x_vars{6}.name = 'Trial_id';
x_vars{6}.vals = find(session.trial_config.processed_dat.vals.trial_type);
x_vars{6}.type = 'equal';
x_vars{7}.str = 'session.data{trial_id}.processed_matrix(8,:)';
x_vars{7}.name = 'Trial_num';
x_vars{7}.vals = trial_range;
x_vars{7}.type = 'equal';

var_tune = 5;
t_window_inds = 10; % 200 ms window
plot_on = 0;


% make full variable array for small variable array
[full_vars col_mat] = expand_behavioural_types(x_vars,var_tune,edges);

% extract num spikes in each time window where conditions are true
[extracted_times max_time] = extract_time_windows(session,full_vars,t_window_inds,trial_range);

clust_id = 31;
% either plot rasters or make tuning curves with error bars
group_ids = [1:length(edges)];
tuning_curve = plot_spike_raster_time_windows(clust_id,sorted_spikes,extracted_times,group_ids,max_time,col_mat,plot_on);
tuning_curve.x_vals = x_vals+.5;
tuning_curve.x_range = [edges(1) edges(end)];
tuning_curve.model_fit = [];
tuning_curve.title = ['Cluster Id ' num2str(clust_id)];
tuning_curve.x_label = 'Wall distance (cm)';
tuning_curve.y_label = 'Firing rate (Hz)';

fig_id = 1000*(dir_num-1)+40;
plot_tuning_curves(fig_id,tuning_curve,[0 .5 1])
%text(25,0,['Trl Rng ' num2str(trial_range)])

set(gcf,'Position',[395   446   367   360])
%xlim([-3 8])

trial_id = 84;
clust_id = 13;
spike_inds = sorted_spikes{clust_id}.ephys_time(sorted_spikes{clust_id}.trial_num == trial_id);

figure(1);
clf(1)
hold on;
plot(smooth([0;500*diff(smooth(session.data{trial_id}.trial_matrix(3,:),25))],25))
if ~isempty(spike_inds)
    plot(spike_inds*500,0,'.r')
end

%% 14 act trans on
%% 15 inh trans
%% 17 act trans on
%% 20 inh
%% 21 act trans on
%% 22 act
%% 23 act trans off
%% 24 act trans off
%% 24 act
%% 28 act trans both
%% 29 act trans both
%% 30 act trans both
%% 31 act











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

id_diff_types = {'olR';'olRLP';'olLP'};

figure(12)
clf(12)
hold on
for ind = 1:3
  subplot(1,numel(id_diff_types),ind)
  hold on
  id_type = id_diff_types{ind};
  [group_ids groups] = define_group_ids(exp_type,id_type,[]);
  trial_ind = find(ismember(d.u_ck(1,:),group_ids));
  num_trials = length(trial_ind);
  col_mat = zeros(length(group_ids),3);
  col_mat(:,1) = 1-linspace(0,1,length(group_ids));
  if ind > 2
    trial_ind = flipdim(trial_ind,2);
  end
  for ij = 1:num_trials
    x_pos = cumsum(squeeze(d.s_ctk(4,:,trial_ind(ij))))/500;
    y_pos = cumsum(squeeze(d.s_ctk(5,:,trial_ind(ij))))/500;
    id = d.u_ck(1,trial_ind(ij))-min(group_ids)+1;
  if ind > 2
    id = size(col_mat,1)-id+1;
  end
    plot(x_pos,y_pos,'Color',col_mat(id,:))
  end
  xlabel(id_type)
  xlim([-5 200])
  ylim([-70 10])
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(3)
clf(3)
hold on
n = hist(p(p(:,7)>5&p(:,6)<.11 & p(:,9)<350 ,12),[0:40]);
n = cumsum(n)/sum(n);
plot([0:40],n,'r')
n = hist(p(p(:,7)>5&p(:,6)<.11 & p(:,9)>500 ,12),[0:40]);
n = cumsum(n)/sum(n);
plot([0:40],n,'b')


figure(3)
clf(3)
hold on
n = hist(p(p(:,7)>5&p(:,6)<.11 & p(:,9)<350 ,14),[0:40]);
n = cumsum(n)/sum(n);
plot([0:40],n,'r')
n = hist(p(p(:,7)>5&p(:,6)<.11 & p(:,9)>500 ,14),[0:40]);
n = cumsum(n)/sum(n);
plot([0:40],n,'b')



firingrate_vs_depth(p,'extra');

figure(2)
clf(2)
hold on
dependent_var = p(:,15);
independent_var = p(:,14)./p(:,12);

x_var = dependent_var(p(:,7)>5&p(:,6)<.11 & p(:,9)>500);
y_var = independent_var(p(:,7)>5&p(:,6)<.11 & p(:,9)>500);

scatter(x_var,y_var);

set(gca,'yscale','log')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SETUP CLUSTERING
clear all
close all
drawnow
cd('/Users/sofroniewn/Documents/DATA/ephys_summary');
d = [];
all_anm_id = {'235585','237723','245918','249872','246702','250492','250494','250495','247871','250496','256043','252776'};
for ih = 1:numel(all_anm_id)
  anm_id = all_anm_id{ih};
  all_anm{ih} = load(['./' anm_id '_d'],'d');
end

p_labels = all_anm{1}.d.p_labels;
p = [];
for ih = 1:numel(all_anm_id)
p = cat(1,p,all_anm{ih}.d.p_nj);
end

%p(isnan(p(:,13)),13) = 0;
%p(isinf(p(:,13)),13) = 100;

total_order = [];
for ih = 1:numel(all_anm)
  for ij = 1:numel(all_anm{ih}.d.summarized_cluster)
    s_ind = find(strcmp(all_anm{ih}.d.p_labels,'layer_4_dist'));
    layer_4_dist = all_anm{ih}.d.p_nj(ij,s_ind);
    total_order = cat(1,total_order,[ih ij layer_4_dist]);
  end
end


 s_ind = find(strcmp(p_labels,'spike_tau'));
 spike_tau = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'isi_violations'));
 isi_viol = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'waveform_SNR'));
 wave_snr = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'peak_rate'));
 peak_rate = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'baseline_rate'));
 base_rate = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'running_modulation'));
 run_mod = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'isi_peak'));
 isi_peak = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'layer_4_dist'));
 layer_4_dist = p(:,s_ind);
 s_ind = find(strcmp(p_labels,'spk_amplitude'));
 spike_amp = p(:,s_ind);


keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;

order_sort = total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,3));
order_sort = order_sort(ind,:);


	order = order_sort(:,:);

	outputDir = ['Fast_spikers_sum'];
	cd('/Users/sofroniewn/Documents/DATA/ephys_summary');
	publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;


start_ind = 1;
iter = 1;
while start_ind <= size(order_sort,1);
	end_ind = min(size(order_sort,1),start_ind+55);
	order = order_sort(start_ind:end_ind,:);
	outputDir = ['Regular_spikers_sum_' num2str(iter)];
	cd('/Users/sofroniewn/Documents/DATA/ephys_summary');
	publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;
	start_ind = end_ind+1;
	iter = iter+1;
end

%order = order_sort(109:end,:);

%plot_clusters(all_anm,order);

num2clip(p)


% histogram by depth - all units
figure;
edges= [-550:50:550];
hist(layer_4_dist,edges)

% isi_viol wave_snr - all units
figure;
plot(isi_viol,wave_snr,'.k')

% spike_amp wave_snr - all units
figure;
plot(spike_amp,wave_snr,'.k')

% isi_viol wave_snr - all units
figure;
plot(spike_tau,isi_viol,'.k')

% peak rate
figure;
hist(peak_rate,[0:100])
xlim([0 100])
% spike amp hist - all units

% histogram by depth - high quality units
figure;
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60;
edges= [100:50:900];
hist(spike_tau(keep_spikes),edges)

% From now on hq units only
% tau histogram - split into RS and FS
figure;
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60;
edges= [-550:50:550];
hist(layer_4_dist(keep_spikes),edges)

% histogram by depth rs, fs
figure;
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau < 350;
edges= [-550:50:550];
hist(layer_4_dist(keep_spikes),edges)

% histogram by depth rs, fs
figure;
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
edges= [-550:50:550];
hist(layer_4_dist(keep_spikes),edges)


% isi_viol wave_snr - all units
figure;
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500 & layer_4_dist >= -50;
plot(spike_tau(keep_spikes),isi_peak(keep_spikes),'.k')
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500 & layer_4_dist < -50;
plot(spike_tau(keep_spikes),isi_peak(keep_spikes),'.g')


% cdf firing rate rs, fs (base_line / peak)

figure;
hold on
keep_spikes = wave_snr > 5 & isi_viol < 10 & spike_amp >= 60 & spike_tau > 500;
n = hist(base_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'b')
keep_spikes = wave_snr > 5 & isi_viol < 10 & spike_amp >= 60 & spike_tau < 350;
n = hist(base_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'r')

figure;
hold on
keep_spikes = wave_snr > 5 & isi_viol < 10 & spike_amp >= 60 & spike_tau > 500;
n = hist(peak_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'b')
keep_spikes = wave_snr > 5 & isi_viol < 10 & spike_amp >= 60 & spike_tau < 350;
n = hist(peak_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'r')

run_rate = base_rate.*run_mod;
figure;
hold on
keep_spikes = wave_snr > 5 & isi_viol < 10 & spike_amp >= 60 & spike_tau > 500;
n = hist(run_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'b')
keep_spikes = wave_snr > 5 & isi_viol < 10 & spike_amp >= 60 & spike_tau < 350;
n = hist(run_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'r')




firingrate_vs_depth(p,p_labels,'baseline');
firingrate_vs_depth(p,p_labels,'peak');
firingrate_vs_depth(p,p_labels,'peak');



firingrate_vs_depth(p,p_labels,'peak_isi');








% histogram by depth rs, fs
figure;
hold on
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 10 & spike_amp >= 60 & spike_tau > 500;
edges= [-550:50:550];
n = hist(layer_4_dist(keep_spikes),edges);
n1 = hist(layer_4_dist(keep_spikes & add_vec > 1),edges)./n;
n2 = hist(layer_4_dist(keep_spikes & add_vec < -1),edges)./n;

h = bar(edges,n1);
set(h,'FaceColor','b')
set(h,'EdgeColor','b')
h = bar(edges,-n2);
set(h,'FaceColor','r')
set(h,'EdgeColor','r')
xlim([-600 600])
ylim([-1 1])










add_vec = [];
for ih = 1:numel(all_anm)
  for ij = 1:numel(all_anm{ih}.d.summarized_cluster)
    tune_curve = all_anm{ih}.d.summarized_cluster{ij}.TOUCH_TUNING.model_fit.curve;

[val ind] = max(tune_curve);
[valm indm] = min(tune_curve);

    val_1 = nanmean(tune_curve(1:25));
    val_2 = nanmean(tune_curve(45:61));
    add_vec = cat(1,add_vec,[val_1 val_2]);
  end
end
add_vec(add_vec<=0.01) = 0.01;
p(:,16) = add_vec(:,1)./add_vec(:,2);


add_vec = [];
for ih = 1:numel(all_anm)
  for ij = 1:numel(all_anm{ih}.d.summarized_cluster)
    tune_curve = all_anm{ih}.d.summarized_cluster{ij}.TOUCH_TUNING.model_fit.curve;
    x_vals = all_anm{ih}.d.summarized_cluster{ij}.TOUCH_TUNING.regressor_obj.x_fit_vals;

    [val ind] = max(tune_curve);
    [valm indm] = min(tune_curve);
    valm(valm<=0.01) = 0.01;
    valbase = nanmean(tune_curve(45:61));
    valbase(valbase<=0.01) = 0.01;

    tmp = val/valbase;
    tmpm = valm/valbase;

    ind_tmp = ind;
    if 1/tmpm > tmp
      tmp = tmpm;
      ind_tmp = indm;
    end

    add_vec = cat(1,add_vec,[tmp x_vals(ind_tmp)]);
  end
end
add_vec(isinf(add_vec(:,1)),1) = 100;
add_vec(isnan(add_vec(:,1)),1) = 1;

add_vec = log(add_vec(:,1));
%p = cat(2,p,add_vec);
p(:,17) = add_vec(:,:);

firingrate_vs_depth(p,'extra');



dependent_var = p(:,16);
figure(2)
clf(2)
set(gcf,'position',[74         520        1316         278])
subplot(1,2,1)
hold on

depth = p(p(:,7)>5 & p(:,6)<.11 & p(:,9)>500 & p(:,16)<=5 & p(:,16)>=.5,4);
edges= [-550:50:550];
[bincounts_0 inds] = histc(depth,edges);


depth = p(p(:,7)>5 & p(:,6)<.11 & p(:,9)>500 & p(:,16)>2,4);
edges= [-550:50:550];
[bincounts_1 inds] = histc(depth,edges);


depth = p(p(:,7)>5 & p(:,6)<.11 & p(:,9)>500 & p(:,16) < .5,4);
edges= [-550:50:550];
[bincounts_2 inds] = histc(depth,edges);


bincounts = bincounts_1./(bincounts_1+bincounts_0+bincounts_2);
bincounts(isinf(bincounts)) = 0;
h = bar(edges,bincounts);
set(h,'FaceColor','b')
set(h,'EdgeColor','b')

bincounts = -bincounts_2./(bincounts_1+bincounts_0+bincounts_2);
bincounts(isinf(bincounts)) = 0;
h = bar(edges,bincounts);
set(h,'FaceColor','r')
set(h,'EdgeColor','r')
xlim(x_lim)
ylim([-1 1])


subplot(1,2,2)
bincounts = (bincounts_1+bincounts_0+bincounts_2);
h = bar(edges,bincounts);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
xlim(x_lim)
ylim([0 80])


figure(2)
clf(2)
set(gcf,'position',[74         520        1316         278])
subplot(1,2,1)
hold on
x_range = diff(x_lim);
y_range = diff(y_lim_ex);
cur_pos = get(gca,'Position');
scale = y_range/x_range*cur_pos(4)/cur_pos(3);

spike_rate = dependent_var(p(:,7)>5&p(:,6)<.11 & p(:,9)>500 & p(:,16)>1);
depth = p(p(:,7)>5 & p(:,6)<.11 & p(:,9)>500 & p(:,16)>1,4);
edges= [-575:50:575];
[bincounts inds] = histc(depth,edges);
vals = accumarray(inds,spike_rate,[length(edges) 1],@prod);
vals = vals.^(1./bincounts);
h = bar(edges+mean(diff(edges))/2,vals);
set(h,'FaceColor','b')
set(h,'EdgeColor','b')

if type_log
  h = plot(depth,spike_rate,'.k');
  set(h,'MarkerEdgeColor', [0.5 0.5 0.5]);
else
  h = transparentScatter(depth,spike_rate,5,scale,0.5,[0 0 0]);
end

spike_rate = dependent_var(p(:,7)>5&p(:,6)<.11 & p(:,9)>500 & p(:,16)<1);
depth = p(p(:,7)>5 & p(:,6)<.11 & p(:,9)>500 & p(:,16) < 1,4);
edges= [-575:50:575];
[bincounts inds] = histc(depth,edges);
vals = accumarray(inds,spike_rate,[length(edges) 1],@prod);
vals = vals.^(1./bincounts);
h = bar(edges+mean(diff(edges))/2,vals);
set(h,'FaceColor','r')
set(h,'EdgeColor','r')

if type_log
  h = plot(depth,spike_rate,'.k');
  set(h,'MarkerEdgeColor', [0.5 0.5 0.5]);
else
  h = transparentScatter(depth,spike_rate,5,scale,0.5,[0 0 0]);
end

xlim(x_lim)
ylim(y_lim_ex)
if type_log
  set(gca,'yscale','log')
end


















