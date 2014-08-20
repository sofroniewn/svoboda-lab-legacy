%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SETUP CLUSTERING
clear all
close all
drawnow
 
%base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_245918/2014_06_21/run_02';
%base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_235585/2014_06_04/run_03';
%base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_235585/2014_06_04/run_06'; % laser data
%base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_246702/2014_08_14/run_03';
%base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_237723/2014_06_17/run_03';

base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_250492/2014_08_15/run_02';

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PUBLISH PLOTS OF CLUSTERS
global trial_range; trial_range = [50:980];
global exp_type; exp_type = 'bilateral_ol_cl'; % 'classic_ol_cl' or 'bilateral_ol_cl';
global id_type; id_type = 'olR';

publish_file_name = 'publish_ephys_new.m'; % 'publish_ephys.m' or 'publish_ephys_new.m'
outputDir = 'test_cl';

publish(publish_file_name,'showCode',false,'outputDir',outputDir); close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOAD summary data without plotting
global id_type; id_type = 'olR';
all_clust_ids = 3 %[3:numel(sorted_spikes)];
plot_on = 1;
d = summarize_cluster_new(all_clust_ids,sorted_spikes,session,exp_type,id_type,trial_range,plot_on);
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


wall_pos = flipdim(squeeze(d.s_ctk(1,:,:))',1);
for_vel = flipdim(squeeze(d.s_ctk(2,:,:))',1);
lat_vel = flipdim(squeeze(d.s_ctk(3,:,:))',1);

fil = triang(100)';
figure(114)
clf(114)
subplot(4,3,1)
imagesc(wall_pos)
subplot(4,3,2)
imagesc(for_vel)
subplot(4,3,3)
imagesc(lat_vel)
subplot(4,3,4)
imagesc(conv2(flipdim(squeeze(d.r_ntk(26,:,:))',1),fil,'same'));
subplot(4,3,5)
imagesc(conv2(flipdim(squeeze(d.r_ntk(13,:,:))',1),fil,'same'));
subplot(4,3,6)
imagesc(conv2(flipdim(squeeze(d.r_ntk(1,:,:))',1),fil,'same'));
subplot(4,3,7)
imagesc(conv2(flipdim(squeeze(d.r_ntk(6,:,:))',1),fil,'same'));
subplot(4,3,8)
imagesc(conv2(flipdim(squeeze(d.r_ntk(11,:,:))',1),fil,'same'));
subplot(4,3,9)
imagesc(conv2(flipdim(squeeze(d.r_ntk(17,:,:))',1),fil,'same'));
subplot(4,3,10)
imagesc(conv2(flipdim(squeeze(d.r_ntk(12,:,:))',1),fil,'same'));
subplot(4,3,11)
imagesc(conv2(flipdim(squeeze(d.r_ntk(25,:,:))',1),fil,'same'));
subplot(4,3,12)
imagesc(conv2(flipdim(squeeze(d.r_ntk(22,:,:))',1),fil,'same'));






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CSD

trial_range = [1:20];
[laser_data] = func_extract_laser_power(base_dir, trial_range, 'laser_data_short', 1);

power_values = round(laser_data.max_power*10);
power_range = unique(power_values);
keep_powers = power_range;

CSD = get_CSD(laser_data,trial_range,power_values,keep_powers);
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









mean_lat = nanmean(lat_vel(trial_plt_range,:));
mean_wall = nanmean(wall_pos(trial_plt_range,:));
mean_for = nanmean(for_vel(trial_plt_range,:));
mean_angle = atan2(mean_lat,mean_for)*180/pi;
mean_angle = mean_angle - mean_angle(1);
mean_angle_sm = smooth(mean_angle,250,'sgolay',1);
diff_angle = 500*[0;diff(mean_angle_sm)];


mean_lat = mean_lat(100:end-100);
mean_wall = mean_wall(100:end-100);
mean_for = mean_for(100:end-100);
mean_angle = mean_angle(100:end-100);
diff_angle = diff_angle(100:end-100);

%diff_angle = abs(diff_angle);
%figure; hold on; plot(mean_angle_sm); plot(mean_angle,'r'); plot(diff_angle,'g');

mean_fr = zeros(size(r_ntk,1)-2,length(diff_angle));
pks = zeros(size(r_ntk,1)-2,6);
onset = zeros(size(r_ntk,1)-2,1);

for ij = 3:size(r_ntk,1)
	avg_fr = conv2(flipdim(squeeze(r_ntk(ij,:,:))',1),fil,'same');
	mean_curve = nanmean(avg_fr(trial_plt_range,100:end-100));
%	mean_fr(ij-2,:) = mean_curve/max(abs(mean_curve));
	mean_fr(ij-2,:) = zscore(mean_curve);
%	mean_fr(ij,:) = mean_fr(ij,:) - mean(mean_fr(ij,1:50));
	% [pk1 loc1] = max(abs(mean_fr(ij,200:end)));
	% [pk2 loc2] = max(-mean_fr(ij,200:end));
	% [pk3 loc3] = max(abs(mean_fr(ij,200:end)));
	% pks(ij,:) = [loc1 pk1 loc2 pk2 loc3 pk3];
	% if(loc1==loc2)
	% 	onset(ij) = loc2 + 10000;
	% 	3
	% else
	% 	onset(ij) = loc1;
	% end
	
	mean_curve = zscore(mean_curve);
	loc = find(mean_curve > 1.5,1,'first');
	if loc > 50
		onset(ij-2) = loc;
	else
		loc = find(mean_curve < .5,1,'first');
		onset(ij-2) = loc - 10000;
	end

	% loc = find(mean_fr(ij,:) > 2.2,1,'first');
	% if ~isempty(loc)
	% 	onset(ij) = loc;
	% 	[pk1 loc1] = max(abs(mean_fr(ij,:)));
	% 	if pk1<3
	% 		onset(ij) = onset(ij) + 20000;
	% 		23
	% 	end

	% 	if onset(ij) > 1000 && onset(ij) < 10000
	% 		onset(ij) = onset(ij) + 2000;
	% 	end

	% 	pk = mean(mean_fr(ij,800:1200))
	% 	if pk > 1
	% 		onset(ij) = onset(ij)-500;
	% 	end
	% else
	% 	loc = find(mean_fr(ij,:) < -1,1,'first');
	% 	onset(ij) = 10000 + loc;
	% end
end

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












%% RETIRED
plot_spike_pair_corr(32,11,17,sorted_spikes,trial_range,[0 1 0])
