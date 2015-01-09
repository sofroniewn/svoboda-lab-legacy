%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MERGE EPHYS & BEHAVIOUR
clear all
close all
drawnow
all_anm_id = {'235585','237723','245918','249872','246702','250492','250494','250495','247871','250496','256043','252776'};

local_save_path = '/Users/sofroniewn/Documents/DATA/ephys_summary_rev8';
merge_ephys_behaviour(all_anm_id,local_save_path);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

summarize_name = 'summarize_cluster_new_wall_dist'; % 'publish_ephys.m' or 'publish_ephys_new.m'
create_publish_ephys(summarize_name);
outputDir = ['anm_' anm_id '_summary_A'];

cd('/Users/sofroniewn/Documents/DATA/ephys_summary_rev3');
publish('publish_ephys.m','showCode',false,'outputDir',outputDir); close all;
num2clip(d.p_nj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SETUP CLUSTERING
clear all
close all
drawnow
cd('/Users/sofroniewn/Documents/DATA/ephys_summary_rev7');
d = [];
all_anm_id = {'235585','237723','245918','249872','246702','250492','250494','250495','247871','250496','256043','252776'};
for ih = 1:numel(all_anm_id)
  anm_id = all_anm_id{ih}
  all_anm.data{ih} = load(['./' anm_id '_d'],'d');

  spike_times_cluster = load(['./' anm_id '_spk'],'spike_times_cluster');
  all_anm.data{ih}.d.spike_times_cluster = spike_times_cluster;
end
all_anm.names = all_anm_id;
x_fit_vals = all_anm.data{1}.d.summarized_cluster{1}.TOUCH_TUNING.regressor_obj.x_fit_vals;

global ps;
[ps p p_labels curves data] = extract_additional_ephys_vars(all_anm.data); all_anm.data = data;
load('/Users/sofroniewn/Documents/DATA/ephys_summary_rev4/resamp_curves.mat');
[ps mean_tuning_curves std_tuning_curves] = get_tuning_curve_SNR(ps,curves.resamp,x_fit_vals);
total_order = [ps.anm_id, ps.clust_id, [1:length(ps.anm_id)]', ps.layer_4_dist];
[time_vect norm_waves mean_waves] = get_mean_waveforms(all_anm.data);


ps.SNR = ps.touch_mean_rate./ps.ste;

% % PUBLISH ALL ANIMALS one by one
% for ij = 1:numel(all_anm_id)
% 	  anm_id = all_anm.names{ij}
% 	  anm_num = str2num(anm_id);
% 	  keep_spikes = ps.anm_id == anm_num & ~clean_clusters;
% 	  order_sort = total_order(keep_spikes,:);
% 	  [val ind] = sort(order_sort(:,2));
% 	  order = order_sort(ind,:);
% 	  outputDir = ['D_' anm_id];
% 	  dir_name = '/Users/sofroniewn/Documents/DATA/ephys_summary_rev5';
% 	  if exist(dir_name)~=7
% 	  	mkdir(dir_name);
% 	  end
% 	  cd(dir_name);
% 	  publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clean up spikes
stable_spikes = abs(ps.stab_amp)<1.5 & abs(ps.stab_fr)<1.75;
clean_isi = ps.isi_violations < 1;
good_snr = ps.waveform_SNR > 6;
good_tuning = ps.SNR > 20;
good_waveform = norm_waves(:,end)>-.4 & max(norm_waves,[],2) < .7;
clean_clusters = good_tuning & stable_spikes & clean_isi & good_snr & good_waveform;

% Spike waveforms
regular_spikes_slow = ps.spike_tau >= 700;
regular_spikes_fast = ps.spike_tau >= 500 & ps.spike_tau < 700;
fast_spikes = ps.spike_tau < 350;
intermediate_spikes =ps.spike_tau >= 350 & ps.spike_tau < 500;
regular_spikes = (regular_spikes_slow | regular_spikes_fast);

%
barrel_inds = {'C1','C2','C3','C4','D1','D2','B1','V1'};
layer_6 = ps.layer_id == 6;
layer_5b = ps.layer_id == 5;
layer_5a = ps.layer_id == 4;
layer_4 = ps.layer_id == 3;
layer_23 = ps.layer_id == 2;


c1c2 = ismember(ps.barrel_loc,[1:2]);
d1 = ismember(ps.barrel_loc,5);
c_row = ismember(ps.barrel_loc,[1:4]);
d_row = ismember(ps.barrel_loc,[5:6]);
b_row =  ismember(ps.barrel_loc,[7]);
v1 = ismember(ps.barrel_loc,[8]);
barrel_id = c_row + b_row+ 2*d_row + 3*v1;
%%


figure
keep_spikes = (layer_4|layer_23) & clean_clusters & ps.touch_peak_rate>2 & ps.mod_down < 1;
tc = mean_tuning_curves(keep_spikes,:);
[max_val ind_max] = max(tc');
max_loc = ps.touch_max_loc(keep_spikes);
[ord ind] = sort(ind_max');
max_val = max(tc')';
tc = bsxfun(@rdivide,tc,max_val);
%plot(ps.touch_max_loc(keep_spikes),ps.touch_peak_rate(keep_spikes),'.k')
imagesc(tc(ind,:))

figure
keep_spikes = clean_clusters & ps.touch_peak_rate>2 & ps.mod_down < 1;
tc = mean_tuning_curves(keep_spikes,:);
[max_val ind_max] = max(tc');
max_loc = ps.touch_max_loc(keep_spikes);
[ord ind] = sort(ind_max');
max_val = max(tc')';
%max_val = bsxfun(@max,max_val,2);
tc = zscore(tc')';
%tc = bsxfun(@rdivide,tc,max_val);
%plot(ps.touch_max_loc(keep_spikes),ps.touch_peak_rate(keep_spikes),'.k')
imagesc(tc(ind,:),[-2.5 2.5])

figure
keep_spikes = clean_clusters & ps.touch_peak_rate>2 & ps.mod_down >= 1;
tc = mean_tuning_curves(keep_spikes,:);
[max_val ind_max] = min(tc');
[ord ind] = sort(ind_max');
max_val = max(tc')';
%max_val = bsxfun(@max,max_val,2);
%tc = zscore(tc);
%tc = bsxfun(@rdivide,tc,max_val);
tc = zscore(tc')';

%plot(ps.touch_max_loc(keep_spikes),ps.touch_peak_rate(keep_spikes),'.k')
imagesc(tc(ind,:))


figure
keep_spikes = clean_clusters & ps.touch_peak_rate>2 & ps.mod_down < 1;
% tc = mean_tuning_curves(keep_spikes,:);
% [max_val ind_max] = min(tc');
% [ord ind] = sort(ind_max');
% max_val = max(tc')';
% %max_val = bsxfun(@max,max_val,2);
% %tc = zscore(tc);
% %tc = bsxfun(@rdivide,tc,max_val);
% tc = zscore(tc')';

half_width = zeros(size(mean_tuning_curves,1),1);
max_loc = zeros(size(mean_tuning_curves,1),1);
for ij = 1:size(mean_tuning_curves,1)
    tc = mean_tuning_curves(ij,:);
    tc = tc - mean(tc(40:end));
    [max_val_i ind_max] = max(tc);
    ind_2 = find(tc(ind_max:end)<max_val_i/2,1,'first')+ind_max-1;
    ind_1 = find(tc(1:ind_max)<max_val_i/2,1,'last');
    if ~isempty(ind_1) & ~isempty(ind_2)
        half_width(ij) = ind_2 - ind_1;
    else
        half_width(ij) = NaN;
    end
    max_loc(ij) = ind_max;
end
keep_spikes = keep_spikes & ~isnan(half_width);
scatter(max_loc(keep_spikes)/2,half_width(keep_spikes)/2,[],ps.mod_up(keep_spikes))
%imagesc(tc(ind,:))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Publish all stability violations
keep_spikes = ~stable_spikes;
order_sort = total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order_sort = order_sort(ind,:);
order = order_sort;
outputDir = ['B_stability_violators'];
cd('/Users/sofroniewn/Documents/DATA/ephys_summary_rev4');
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;

% PUBLISH ALL SNR VIOLATORS
keep_spikes = ~good_snr & stable_spikes;
order_sort = total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order_sort = order_sort(ind,:);
order = order_sort;
outputDir = ['B_SNR_violators'];
cd('/Users/sofroniewn/Documents/DATA/ephys_summary_rev4');
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;


% PUBLISH ALL ISI VIOLATORS
keep_spikes = layer_23 & good_snr & stable_spikes & good_tuning & all_viol(:,1) >= 1 & all_viol(:,4) < 1;
keep_spikes = layer_23 & ~type_on & ~layer_6 & regular_spikes & (c_row | b_row) & ps.touch_peak_rate > 2 & clean_clusters;

keep_spikes = (layer_23 | layer_4) & type_on & ~layer_6 & regular_spikes & (c_row | b_row) & ps.touch_peak_rate > 2 & clean_clusters;


order_sort = total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order_sort = order_sort(ind,:);
order = order_sort;

start_ind = 1;
iter = 1;
type_on
while start_ind <= size(order_sort,1);
	end_ind = min(size(order_sort,1),start_ind+51);
	order = order_sort(start_ind:end_ind,:);
	outputDir = ['G_type_on' num2str(iter)];
	cd('/Users/sofroniewn/Documents/DATA/ephys_summary_rev4');
	publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;
	start_ind = end_ind+1;
	iter = iter+1;
end

% PUBLISH ALL TUNING VIOLATORS
keep_spikes = ~good_tuning & stable_spikes;
sum(keep_spikes)
order_sort = total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order_sort = order_sort(ind,:);
order = order_sort;
outputDir = ['B_TUNING_SNR_violators'];
cd('/Users/sofroniewn/Documents/DATA/ephys_summary_rev4');
publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Spike tau
keep_spikes = clean_clusters;
figure(1)
clf(1)
hist(ps.spike_tau(keep_spikes),[0:20:900])
xlabel('Spike tau (us)')
xlim([0 900])

figure(1)
clf(1)
hold on
keep_spikes = clean_clusters & fast_spikes;
plot(time_vect,norm_waves(keep_spikes,:),'r')
keep_spikes = clean_clusters & intermediate_spikes;
plot(time_vect,norm_waves(keep_spikes,:),'k')
keep_spikes = clean_clusters & regular_spikes_fast;
plot(time_vect,norm_waves(keep_spikes,:),'g')
keep_spikes = clean_clusters & regular_spikes_slow;
plot(time_vect,norm_waves(keep_spikes,:),'b')
xlabel('Time (us)')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DISTANCE FROM LAYER 4 OF RECORDINGS
keep_spikes = clean_clusters;
figure(1)
clf(1)
edges = [-600:50:600];
n = histc(ps.layer_4_dist(keep_spikes),edges);
h = bar(edges,n);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
xlabel('Distance from layer 4 (mm)')
xlim([-600 600])

% LAYER ID OF RECORDINGS
keep_spikes = clean_clusters & c1_close;
figure(34)
clf(34)
edges = unique(ps.layer_id);
n = histc(ps.layer_id(keep_spikes),edges);
h = bar(edges,n);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
xlim([1 7])
set(gca,'xtick',[2:6])
set(gca,'xticklabel',{'L2/3', 'L4', 'L5a', 'L5b', 'L6'})

% INSIDE BARREL vs OUTSIDE BARREL
keep_spikes = clean_clusters;
figure(34)
clf(34)
insideC1C2 = ismember(ps.barrel_loc,[1 2]);
surround = ismember(ps.barrel_loc,[3:7]);
outside = ismember(ps.barrel_loc,[8]);
h = bar([2 3 4],[sum(insideC1C2(keep_spikes)) sum(surround(keep_spikes)) sum(outside(keep_spikes))]);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
xlim([1 5])
set(gca,'xtick',[2:4])
set(gca,'xticklabel',{'C1/C2', 'surround', 'outside'})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% number of units by depth
y_mat = [ones(length(ps.anm_id),1) ones(length(ps.anm_id),1) ones(length(ps.anm_id),1)];
keep_mat = [regular_spikes_slow, regular_spikes_fast, fast_spikes];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & clean_clusters,0,1)






% log running and touch modulation
run_mod = ps.no_walls_run_rate./ps.no_walls_still_rate;
run_mod(isinf(run_mod) | isnan(run_mod)) = 10;
touch_mod = ps.touch_peak_rate./ps.no_walls_run_rate;
touch_mod(isinf(touch_mod) | isnan(touch_mod)) = 10;


% log running and touch modulation by barrel
y_mat = log([run_mod touch_mod]);
y_mat(isinf(y_mat)) = 0;
keep_mat = [];
x_labels = {'B/C row', 'D row', 'V1'};
x_vec = barrel_id+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & clean_clusters,1,0)

% log running and touch modulation by layer
y_mat = log([run_mod touch_mod]);
y_mat(isinf(y_mat) | isnan(y_mat)) = 0;
keep_mat = [regular_spikes & (c_row | b_row | d_row), regular_spikes & (c_row | b_row | d_row)];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & clean_clusters,1,0)



% touch distance preference by arc
y_mat = [ps.touch_max_loc];
keep_mat = [];
x_labels = {'C1', 'C2', 'C3', 'C4'};
x_vec = ps.barrel_loc+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & c_row & ps.mod_up > 3 & clean_clusters,1,0)



% log running and touch modulation by layer
y_mat = [ps.no_walls_still_rate ps.no_walls_run_rate];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & (c_row | b_row | d_row) & clean_clusters,1,0)


% log running and touch modulation by layer
y_mat = [ps.touch_min_rate ps.touch_baseline_rate ps.touch_peak_rate];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & (c_row | b_row | d_row) & clean_clusters,1,0)


y_mat = [ps.spk_amplitude];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat, clean_clusters,1,0)


% log running and touch modulation by layer
y_mat = [ps.mod_up > 1 & ps.mod_down <= 1, ps.mod_up > 1 & ps.mod_down > 1, ps.mod_up <= 1 & ps.mod_down > 1, ps.mod_up <= 1 & ps.mod_down <= 1];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & c1_close & regular_spikes & clean_clusters,1,0)

y_mat = [ps.mod_up > .5 & ps.mod_down <= .5, ps.mod_up > .5 & ps.mod_down > .5, ps.mod_up <= .5 & ps.mod_down > .5, ps.mod_up <= .5 & ps.mod_down <= .5];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & ~c1_close & regular_spikes & clean_clusters,1,0)


stable_spikes = abs(ps.stab_amp)<1.5 & abs(ps.stab_fr)<1.75;
clean_isi = ps.isi_violations < 1;
good_snr = ps.waveform_SNR > 6;
good_tuning = ps.SNR > 20;

clean_clusters = good_tuning & stable_spikes & clean_isi & good_snr;



% log running and touch modulation by layer
y_mat = ~clean_clusters;
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,true(length(clean_clusters),1),1,0)




y_mat = [choice_prob_all];
keep_mat = [];
x_labels = {'L2/3', 'L4', 'L5a', 'L5b', 'L6'};
x_vec = ps.layer_id;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & (c_row | b_row | d_row) & clean_clusters,1,0)

y_mat = [choice_prob_all];
keep_mat = [];
x_labels = {'C1', 'C2', 'C3', 'C4'};
x_vec = ps.barrel_loc+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & regular_spikes & c_row & clean_clusters,1,0)

% log running and touch modulation by barrel
y_mat = choice_prob_all;
keep_mat = [];
x_labels = {'B/C row', 'D row', 'V1'};
x_vec = barrel_id+1;
firingrate_vs_layer(x_vec,x_labels,y_mat,keep_mat,~layer_6 & clean_clusters,1,0)



% figure(1)
% clf(1)
% hold on
% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==1 & ps.mod_up > 3 ;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'b');
% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==2 & ps.mod_up > 3 ;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'g');
% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==3 & ps.mod_up > 3 ;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'r');
% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==4 & ps.mod_up > 3;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'c');


figure(1)
clf(1)
hold on
keep_spikes = clean_clusters ;
tc = mean(mean_tuning_curves(keep_spikes,:));
plot(x_fit_vals,tc,'k');
keep_spikes = ~layer_6 & clean_clusters & ~v1 & ps.mod_up > 3 ;
tc = mean(mean_tuning_curves(keep_spikes,:));
plot(x_fit_vals,tc,'b');
keep_spikes = ~layer_6 & clean_clusters & ~v1 & ps.mod_down > 1 & ps.mod_up < 1;
tc = mean(mean_tuning_curves(keep_spikes,:));
plot(x_fit_vals,tc,'r');


% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==2 & ps.mod_up > 3 ;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'g');
% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==3 & ps.mod_up > 3 ;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'r');
% keep_spikes = ~layer_6 & clean_clusters & ps.barrel_loc==4 & ps.mod_up > 3;
% tc = mean(mean_tuning_curves(keep_spikes,:));
% plot(x_fit_vals,tc/max(tc),'c');

%
keep_spikes = clean_clusters;
figure(19)
clf(19)
subplot(4,1,1)
hist(ps.spk_amplitude(clean_clusters & layer_23),[0:20:600])
subplot(4,1,2)
hist(ps.spk_amplitude(clean_clusters & layer_4),[0:20:600])
subplot(4,1,3)
hist(ps.spk_amplitude(clean_clusters & layer_5a),[0:20:600])
subplot(4,1,4)
hist(ps.spk_amplitude(clean_clusters & layer_5b),[0:20:600])




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% SPIKE FIRING RATE STABILITY METRIC
figure(1)
clf(1)
hist(abs(ps.stab_fr),[0:.1:3])
xlabel('stability metric')
xlim([0 3])

% WAVEFORM SNR
figure(1)
clf(1)
hist(ps.waveform_SNR,[0:.3:30])
xlabel('waveform SNR')
xlim([0 30])

% ISI VIOLATIONS
figure(1)
clf(1)
hist(ps.isi_violations,[0:.1:5])
xlabel('% isi violations')
xlim([-0.1 5])

% waveform SNR vs ISI
figure(1)
clf(1)
plot(ps.isi_violations,ps.waveform_SNR,'.k')
xlabel('% isi violations')
ylabel('waveform SNR')
xlim([0 70])
ylim([0 30])


% Spike amplitude
figure(1)
clf(1)
hist(ps.spk_amplitude,[0:10:300])
xlabel('spike amplitude (uV)')
xlim([0 300])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%












% PUBLISH ALL CLEAN LAYER 2/3
keep_spikes = clean_clusters & ps.layer_id == 2;
sum(keep_spikes)
order_sort = total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order_sort = order_sort(ind,:);
order = order_sort;

start_ind = 1;
iter = 1;
while start_ind <= size(order_sort,1);
	end_ind = min(size(order_sort,1),start_ind+51);
	order = order_sort(start_ind:end_ind,:);
	outputDir = ['C_layer23_' num2str(iter)];
	cd('/Users/sofroniewn/Documents/DATA/ephys_summary_rev4');
	publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;
	start_ind = end_ind+1;
	iter = iter+1;
end

% PUBLISH ALL CLEAN LAYER 4
keep_spikes = clean_clusters & ps.layer_id == 3;
sum(keep_spikes)
order_sort = total_order(keep_spikes,:);
[val ind] = sort(order_sort(:,4));
order_sort = order_sort(ind,:);
order = order_sort;

start_ind = 1;
iter = 1;
while start_ind <= size(order_sort,1);
	end_ind = min(size(order_sort,1),start_ind+51);
	order = order_sort(start_ind:end_ind,:);
	outputDir = ['C_layer4' num2str(iter)];
	cd('/Users/sofroniewn/Documents/DATA/ephys_summary_rev4');
	publish('publish_all_ephys.m','showCode',false,'outputDir',outputDir); close all;
	start_ind = end_ind+1;
	iter = iter+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%










figure(1)
clf(1)
hist(ps.num_spikes,[0:100:10000])
xlabel('tuning SNR')
xlim([0 10000])

figure(1)
clf(1)
plot(ps.isi_violations,ps.waveform_SNR,'.k')
xlabel('% isi violations')
ylabel('waveform SNR')
xlim([0 70])
ylim([0 30])

figure(1)
clf(1)
plot(ps.spk_amplitude,ps.waveform_SNR,'.k')
xlabel('spike amplitude')
ylabel('waveform SNR')
xlim([0 300])
ylim([0 30])

figure(1)
clf(1)
plot(ps.SNR,ps.num_spikes,'.k')




figure(1)
clf(1)
hist(abs(ps.stab_fr),[0:.1:3])
xlabel('% stability')
xlim([0 3])

figure(1)
clf(1)
plot(abs(ps.stab_fr),abs(ps.stab_amp),'.k')

figure(1)
clf(1)
plot(ps.touch_mean_rate,ps.ste./ps.touch_mean_rate,'.k')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%order = order_sort(109:end,:);

%plot_clusters(all_anm,order);

%num2clip(p)

% q = [ps.touch_baseline_rate, log(ps.touch_peak_rate - ps.touch_baseline_rate), log(ps.touch_baseline_rate - ps.touch_min_rate)];

% %q = curves.onset;

% keep_spikes = ps.spike_tau>500 & ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & SNR > 2.5;
% q = q(keep_spikes,:);
% %q = zscore(q);

% %q = cat(2,q,H');
% idx = kmeans(zscore(q),3);

% gplotmatrix(q,q,idx);

% y_mat = [idx==1,idx==2,idx==3,idx==4,idx==5];
% keep_mat = [];
% firingrate_vs_depth(ps,y_mat,keep_mat,1);
%%



% base_rate
resp_type = p(:,17);
figure;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500 & num_trials > 40 & SNR > 2.5;
scatter(layer_4_dist(keep_spikes),spike_tau(keep_spikes),40*run_rate(keep_spikes).^(.2),isi_peak(keep_spikes),'fill')

figure
plot(log(run_rate(keep_spikes)),resp_type(keep_spikes),'.k')

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

figure;
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500 & spike_tau < 700;
edges= [-550:50:550];
m = hist(layer_4_dist(keep_spikes),edges)

% histogram by depth rs, fs
figure;
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 700;
edges= [-550:50:550];
n = hist(layer_4_dist(keep_spikes),edges);

figure
q = n./(n+m);
hold on
h = bar(edges,q);
set(h,'FaceColor','b')
set(h,'EdgeColor','b')
h = bar(edges,q-1);
set(h,'FaceColor','g')
set(h,'EdgeColor','g')

% isi_viol wave_snr - all units
figure;
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500 & layer_4_dist >= -50;
plot(spike_tau(keep_spikes),isi_peak(keep_spikes),'.k')
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500 & layer_4_dist < -50;
plot(spike_tau(keep_spikes),isi_peak(keep_spikes),'.g')


figure
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
plot(spike_amp(keep_spikes),spike_tau(keep_spikes),'.g')



% cdf firing rate rs, fs (base_line / peak)

figure;
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
n = hist(base_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'b')
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau < 350;
n = hist(base_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'r')

figure;
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
n = hist(peak_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'b')
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau < 350;
n = hist(peak_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'r')

run_rate = base_rate.*run_mod;
figure;
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
n = hist(run_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'b')
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau < 350;
n = hist(run_rate(keep_spikes),[0:40])
n = cumsum(n)/sum(n);
plot([0:40],n,'r')




firingrate_vs_depth(p,p_labels,'baseline');
firingrate_vs_depth(p,p_labels,'peak');
firingrate_vs_depth(p,p_labels,'run_rate');



firingrate_vs_depth(p,p_labels,'peak_isi');








% histogram by depth rs, fs
figure;
hold on
%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
edges= [-550:100:550];
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









ps.chan_depth

mod_up  = ps.touch_peak_rate - ps.touch_baseline_rate;
mod_down  = ps.touch_baseline_rate - ps.touch_min_rate;

figure(2)
clf(2)
set(gcf,'position',[74         520        1316         278])
subplot(1,2,1)
hold on

keep_spikes = ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spike_tau > 500 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & SNR > 2.5;

edges= [-550:100:550];

depth = ps.layer_4_dist(keep_spikes);
[bincounts_0 inds] = histc(depth,edges);


depth = ps.layer_4_dist(keep_spikes & mod_up > .5 & mod_down < .5);
[bincounts_1 inds] = histc(depth,edges);


depth = ps.layer_4_dist(keep_spikes & mod_down > .5);
[bincounts_2 inds] = histc(depth,edges);


bincounts = bincounts_1./(bincounts_0);
bincounts(isinf(bincounts)) = 0;
h = bar(edges,bincounts);
set(h,'FaceColor','b')
set(h,'EdgeColor','b')

bincounts = -bincounts_2./(bincounts_0);
bincounts(isinf(bincounts)) = 0;
h = bar(edges,bincounts);
set(h,'FaceColor','r')
set(h,'EdgeColor','r')
xlim([-550 550])


subplot(1,2,2)
bincounts = (bincounts_0);
h = bar(edges,bincounts);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
xlim([-550 550])
ylim([0 30])


ps.SNR = SNR;

mod_thresh = 0.5;
mod_thresh = 0.5;

y_mat = [ps.mod_up>mod_thresh & ps.mod_down<mod_thresh, ps.mod_down>mod_thresh];
firingrate_vs_layer(ps,y_mat,[],0)

y_mat = [mod_up>mod_thresh & mod_down <= mod_thresh,  mod_up > mod_thresh & mod_down > mod_thresh, mod_up <= mod_thresh & mod_down > mod_thresh];

y_mat = cp;
keep_mat = ~isnan(cp);
firingrate_vs_layer(ps,y_mat,keep_mat,1);


y_mat = [ps.touch_max_loc, ps.touch_min_loc];
keep_mat = [mod_up>mod_thresh, mod_down>mod_thresh];
firingrate_vs_layer(ps,y_mat,keep_mat,0);

y_mat = [ps.touch_max_loc - ps.touch_min_loc];
keep_mat = [mod_up>mod_thresh & mod_down>mod_thresh];
firingrate_vs_layer(ps,y_mat,keep_mat,0);

%%
keep_spikes = ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spike_tau > 500 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & SNR > 2.5;


y_mat = [ps.no_walls_still_rate, ps.no_walls_run_rate];
firingrate_vs_layer(ps,y_mat,[],1);


y_mat = [ps.touch_peak_rate, ps.touch_baseline_rate, ps.touch_min_rate];
firingrate_vs_layer(ps,y_mat,[],1);

y_mat = [mod_up, mod_down];
keep_mat = [];
firingrate_vs_layer(ps,y_mat,keep_mat,1);


run_mod = ps.no_walls_run_rate - ps.no_walls_still_rate;
y_up = run_mod>0.5;
y_down = run_mod<-0.5;
firingrate_vs_depth(ps,y_up,y_down,[],[]);


ps.adapt = 2*nanmean(curves.onset,2)./(nanmean(curves.onset,2) + nanmean(curves.offset,2))-1;
ps.adapt(isnan(ps.adapt)) = 0;



y_mat = [ps.adapt];
keep_mat = [];
firingrate_vs_layer(ps,y_mat,keep_mat,1)

y_mat = [ps.adapt ps.adapt ps.adapt];
keep_mat = [mod_up>mod_thresh & mod_down <= mod_thresh,  mod_up > mod_thresh & mod_down > mod_thresh, mod_up <= mod_thresh & mod_down > mod_thresh];
firingrate_vs_layer(ps,y_mat,keep_mat,1)




y_mat = [ps.adapt, ps.adapt];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);





y_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
keep_mat = [ps.spike_tau > 500, ps.spike_tau > 500];
firingrate_vs_layer(ps,y_mat,keep_mat,0);

y_mat = [ps.spike_tau>700,  ps.spike_tau<=500, ps.spike_tau>500 & ps.spike_tau<=700];
keep_mat = [];
firingrate_vs_depth(ps,y_mat,keep_mat,0);


y_mat = [ps.no_walls_still_rate, ps.no_walls_still_rate];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);

y_mat = [ps.no_walls_run_rate, ps.no_walls_run_rate];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);

y_mat = [ps.no_walls_run_rate - ps.no_walls_still_rate, ps.no_walls_run_rate - ps.no_walls_still_rate];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);


y_mat = [ps.touch_peak_rate, ps.touch_peak_rate];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);

y_mat = [ps.touch_peak_rate - ps.touch_baseline_rate, ps.touch_peak_rate - ps.touch_baseline_rate];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);

y_mat = [ps.touch_baseline_rate - ps.touch_min_rate, ps.touch_baseline_rate - ps.touch_min_rate];
keep_mat = [ps.spike_tau>700, ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_layer(ps,y_mat,keep_mat,1);


%mod_up>mod_thresh & mod_down>mod_thresh

y_mat = [mod_up>mod_thresh & mod_down>mod_thresh, mod_up>mod_thresh & mod_down>mod_thresh];
keep_mat = [ps.spike_tau>700 , ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_depth(ps,y_mat,keep_mat,1);

y_mat = [mod_up<=mod_thresh & mod_down>mod_thresh, mod_up<=mod_thresh & mod_down>mod_thresh];
keep_mat = [ps.spike_tau>700 , ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_depth(ps,y_mat,keep_mat,1);

y_mat = [mod_up>mod_thresh & mod_down<=mod_thresh, mod_up>mod_thresh & mod_down<=mod_thresh];
keep_mat = [ps.spike_tau>700 , ps.spike_tau>500 & ps.spike_tau<=700];
firingrate_vs_depth(ps,y_mat,keep_mat,1);



y_mat = [ps.touch_max_loc, ps.touch_max_loc];
keep_mat = [ps.spike_tau>700 & mod_up>mod_thresh, ps.spike_tau>500 & ps.spike_tau<=700 & mod_up>mod_thresh];
firingrate_vs_depth(ps,y_mat,keep_mat,1);



y_mat = [ps.touch_min_loc, ps.touch_min_loc];
keep_mat = [ps.spike_tau>700 & mod_down>mod_thresh, ps.spike_tau>500 & ps.spike_tau<=700 & mod_down>mod_thresh];
firingrate_vs_depth(ps,y_mat,keep_mat,1);


%%
ps.touch_baseline_rate(ps.touch_baseline_rate<0) = 0;
ps.touch_min_rate(ps.touch_min_rate<0) = 0;

mod_up_new = (ps.touch_peak_rate - ps.touch_baseline_rate)./(ps.touch_peak_rate + ps.touch_baseline_rate);
mod_up_new(isnan(mod_up_new) | isinf(mod_up_new)) = 0;

mod_down_new = (ps.touch_baseline_rate - ps.touch_min_rate)./(ps.touch_min_rate + ps.touch_baseline_rate);
mod_down_new(isnan(mod_down_new) | isinf(mod_down_new)) = 0;

figure(5);
clf(5)
hold on
keep_spikes = ~layer_6 & regular_spikes & clean_clusters & (c_row | b_row);
%plot([0 25],[1 1],'r')
%plot([1 1],[0 25],'r')
%plot([0 25],[0 25],'r')
plot(mod_up_new(keep_spikes),mod_down_new(keep_spikes),'.k')
xlabel('Peak - Baseline')
ylabel('Baseline - Min')
%set(gca,'yscale','log')
%set(gca,'xscale','log')
set(gca,'FontSize',16)

%%

figure(5);
clf(5)
hold on

keep_spikes = clean_clusters & c1_close;

plot([0 25],[.5 .5],'k')
plot([.5 .5],[0 25],'k')
plot([0 25],[0 25],'k')

scatter(ps.mod_up(keep_spikes),ps.mod_down(keep_spikes),[],'r','fill')
xlabel('Peak - Baseline')
ylabel('Baseline - Min')
%set(gca,'yscale','log')
%set(gca,'xscale','log')
xlim([0 25])

%%

figure(5);
clf(5)
hold on

keep_spikes = ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spike_tau > 500 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & SNR > 2.5;

plot([0 25],[.5 .5],'k')
plot([.5 .5],[0 25],'k')
plot([0 25],[0 25],'k')

scatter(mod_up(keep_spikes),mod_down(keep_spikes),[],ps.adapt(keep_spikes),'fill')
xlabel('Peak - Baseline')
ylabel('Baseline - Min')
%set(gca,'yscale','log')
%set(gca,'xscale','log')
xlim([0 25])


%%%%%%%%%%%%%%%%%%%%%%%%
adapt_curve = curves.onset - curves.offset;

figure
plot(adapt_curve(3,:)')

figure
hold on
plot(curves.onset(1,:),'b')
plot(curves.offset(1,:),'r')


ps.adapt = 2*nanmean(curves.onset,2)./(nanmean(curves.onset,2) + nanmean(curves.offset,2))-1;
ps.adapt(isnan(ps.adapt)) = 0;




%%
mod_thresh = 1;

figure(5);
clf(5)
hold on

keep_spikes = ps.waveform_SNR > 5 & ps.isi_violations < 1 & ps.spike_tau < 350 & ps.spk_amplitude >= 60 & ps.num_trials > 40 & ps.touch_peak_rate > 2 & SNR > 2.5;

plot([0 50],[mod_thresh mod_thresh],'k')
plot([mod_thresh mod_thresh],[0 50],'k')
plot([0 50],[0 50],'k')

plot(mod_up(keep_spikes & mod_up <= mod_thresh & mod_down <= mod_thresh),mod_down(keep_spikes & mod_up <= mod_thresh & mod_down <= mod_thresh),'.k','MarkerSize',20)
plot(mod_up(keep_spikes & mod_up > mod_thresh & mod_down <= mod_thresh),mod_down(keep_spikes & mod_up > mod_thresh & mod_down <= mod_thresh),'.b','MarkerSize',20)
plot(mod_up(keep_spikes & mod_up <= mod_thresh & mod_down > mod_thresh),mod_down(keep_spikes & mod_up <= mod_thresh & mod_down > mod_thresh),'.r','MarkerSize',20)
plot(mod_up(keep_spikes & mod_up > mod_thresh & mod_down > mod_thresh),mod_down(keep_spikes & mod_up > mod_thresh & mod_down > mod_thresh),'.g','MarkerSize',20)

xlabel('Peak - Baseline')
ylabel('Baseline - Min')
%set(gca,'yscale','log')
%set(gca,'xscale','log')
xlim([0 50])
ylim([0 50])



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


%%
figure(3);
clf(3)
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau > 500 & peak_rate > 2 & spike_amp >= 60 & num_trials > 40 & SNR > 2.5;
plot3([0:.1:30],[0:.1:30],[0:.1:30],'k','linewidth',2)
plot3(add_vec_new(keep_spikes,2),add_vec_new(keep_spikes,1),add_vec_new(keep_spikes,3),'.r')
xlabel('Baseline')
ylabel('Peak')
zlabel('Min')
xlim([0 30])
ylim([0 30])
zlim([0 30])


%%
figure(4);
clf(4)
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau > 500 & peak_rate > 2 & spike_amp >= 60 & num_trials > 40 & SNR > 2.5;
plot3([0:.1:30],[0:.1:30],[0:.1:30],'k','linewidth',2)
plot3(add_vec_new(keep_spikes,1)-add_vec_new(keep_spikes,2),add_vec_new(keep_spikes,2)-add_vec_new(keep_spikes,3),add_vec_new(keep_spikes,2),'.r')
xlabel('Peak - Baseline')
ylabel('Baseline - Min')
zlabel('Baseline')
xlim([0 30])
ylim([0 30])
zlim([0 30])

%

mod_up = add_vec_new(:,1)-add_vec_new(:,2);
mod_down = add_vec_new(:,2)-add_vec_new(:,3);

%mod_down(mod_down<.5) = 0;
%mod_up(mod_up<.5) = 0;

%%
figure(5);
clf(5)
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau > 500 & peak_rate > 2 & spike_amp >= 60 & num_trials > 40 & SNR > 2.5;
plot([0 5],[.5 .5],'k')
plot([.5 .5],[0 5],'k')

plot(mod_up(keep_spikes),mod_down(keep_spikes),'.r')
xlabel('Peak - Baseline')
ylabel('Baseline - Min')
xlim([0 5])
ylim([0 5])



figure(5);
clf(5)
hold on


keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau > 500 & peak_rate > 2 & spike_amp >= 60 & num_trials > 40 & SNR > 2.5;
plot((add_vec_new(keep_spikes,1)-add_vec_new(keep_spikes,2))./add_vec_new(keep_spikes,4),(add_vec_new(keep_spikes,2)-add_vec_new(keep_spikes,3))./add_vec_new(keep_spikes,4),'.r')

plot((add_vec_new(keep_spikes,1)-add_vec_new(keep_spikes,2))./add_vec_new(keep_spikes,4),(add_vec_new(keep_spikes,2)-add_vec_new(keep_spikes,3))./add_vec_new(keep_spikes,4),'.r')
xlabel('Peak - Baseline')
ylabel('Baseline - Min')
xlim([0 5])
ylim([0 5])


%%
figure
hist(add_vec_new(keep_spikes,1)-add_vec_new(keep_spikes,2),[0:.2:30])

figure
hist(add_vec_new(keep_spikes,2)-add_vec_new(keep_spikes,3),[0:.2:30])


%scatter(mod_vec(keep_spikes,1),mod_vec(keep_spikes,2),[],add_vec_new(keep_spikes,2),'fill')
%plot(add_vec_new(keep_spikes,3),add_vec_new(keep_spikes,1),'.b')





figure(10)
clf(10)
hold on
keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau > 700 & peak_rate > 2 & spike_amp >= 60;
plot(time_vect,norm_waves(keep_spikes,:)','b')

keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau <= 700 & spike_tau >= 500 & peak_rate > 2 & spike_amp >= 60;
plot(time_vect,norm_waves(keep_spikes,:)','g')

keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau <= 500 & spike_tau >= 350 & peak_rate > 2 & spike_amp >= 60;
plot(time_vect,norm_waves(keep_spikes,:)','k')

keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_tau < 350 & peak_rate > 2 & spike_amp >= 60;
plot(time_vect,norm_waves(keep_spikes,:)','r')


% NEW TAU DIST.
figure(11)
clf(11)
hist(1000*tau_new,[0:50:900])


x = time_vect(20:30)';
y = -norm_waves(1,20:30)';
f = fit(x,y,'exp1');

x = time_vect(:)';
y = norm_waves(1,:)';


yy = smooth(y,5,'sgolay',1);

figure;
hold on
plot(x,y,'b','LineWidth',2)
plot(x,yy,'r','LineWidth',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NNMF on tuning curves


%keep_spikes = wave_snr > 5 & isi_viol < 1 & spike_amp >= 60 & spike_tau > 500;
keep_index = find(keep_spikes);

order_sort = total_order(keep_spikes,4);
[val ind] = sort(order_sort);
keep_index = keep_index(ind,:);

num_keep_neurons = sum(keep_spikes);
length_tuning_curve = length(all_anm{1}.d.summarized_cluster{1}.TOUCH_TUNING.regressor_obj.x_fit_vals);

X = zeros(num_keep_neurons,length_tuning_curve);
y = zeros(num_keep_neurons,1);

anm_num = p(:,1);
[a b c] = unique(anm_num);

% for ij = 1:num_keep_neurons
% 	neuron_num = keep_index(ij);
% 	anm_num = total_order(neuron_num,1);
% 	clust_num = total_order(neuron_num,2);
% 	layer_4_dist(neuron_num)
% 	tuning = all_anm{anm_num}.d.summarized_cluster{clust_num}.TOUCH_TUNING;
%     tune_curve = tuning.model_fit.curve;
% 	X(ij,:) = tune_curve;
% end

 for ij = 1:num_keep_neurons
 	neuron_num = keep_index(ij);
 	layer_4_dist(neuron_num)
 	X(ij,:) = [curves.onset(neuron_num,:)];
 end


X(X<0) = 0;
remove = sum(isnan(X),2);
keep_index(remove>0) = [];
X(remove>0,:) = [];

Y = bsxfun(@rdivide,X,sum(X,2));

figure
imagesc(X)

figure
plot(X')

[W,H] = nnmf(X',3);

figure;
plot(W)


figure
plot3(H(1,:),H(2,:),H(3,:),'.r')


[coeff,score] = pca(X);


figure;
plot(coeff(:,1:4))

figure
plot3(score(:,1),score(:,2),score(:,3),'.r')


figure;
hold on
plot(layer_4_dist(keep_index),H(1,:),'.b')
plot(layer_4_dist(keep_index),H(2,:),'.g')
plot(layer_4_dist(keep_index),H(3,:),'.r')

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stability analysis


ih = 2;

figure;
hold on
for ij = 1:numel(all_anm.data{ih}.d.summarized_cluster)
	trial_range = [all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_range(1):all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_range(2)];
	plot(trial_range,all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_firing_rate)
first_third = round(length(all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_firing_rate)/3);
start_fr = mean(all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_firing_rate(1:first_third))
end_fr = mean(all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_firing_rate(end-first_third:end))
tot_fr = mean(all_anm.data{ih}.d.summarized_cluster{ij}.AMPLITUDES.trial_firing_rate(:))
mod_fr = (start_fr - end_fr)/tot_fr
end







%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Choice prob
choice_prob_all = choice_probabilities(ps,all_anm.data,[],[],12);

figure
hold on
keep_spikes_out = clean_clusters & ismember(ps.barrel_loc,[3 4 6 7]) & ~v1;
keep_spikes = clean_clusters & ismember(ps.barrel_loc,[1 2 5]) & ~v1;
n_out = hist(choice_prob_all(keep_spikes_out,1),[0:.05:1])
n = hist(choice_prob_all(keep_spikes,1),[0:.05:1])
h = bar([0:.05:1],n/sum(n));
set(h,'FaceColor','g')
set(h,'EdgeColor','g')
h = bar([0:.05:1],n_out/sum(n_out));
plot([0.5 0.5],[0 .1],'r')
nanmean(choice_prob_all(keep_spikes_out,:))
nanstd(choice_prob_all(keep_spikes_out,:))/sqrt(sum(keep_spikes_out))
nanmean(choice_prob_all(keep_spikes,:))
nanstd(choice_prob_all(keep_spikes,:))/sqrt(sum(keep_spikes))


figure
hold on
keep_spikes_out = clean_clusters & ismember(ps.barrel_loc,[3 4 6 7]) & ~v1;
keep_spikes = clean_clusters & ismember(ps.barrel_loc,[1 2 5]) & ~v1;
n_out = hist(choice_prob_all(keep_spikes_out,1),[0:.1:1])
n = hist(choice_prob_all(keep_spikes,1),[0:.1:1])
h = bar([0:.1:1],n/sum(n));
set(h,'FaceColor','g')
set(h,'EdgeColor','g')
h = bar([0:.1:1],n_out/sum(n_out),.5);
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
aa = nanmean(choice_prob_all(keep_spikes_out,:))
plot([aa(1) aa(1)],[0 .35],'c','linewidth',2)
nanstd(choice_prob_all(keep_spikes_out,:))/sqrt(sum(keep_spikes_out))
aa = nanmean(choice_prob_all(keep_spikes,:))
plot([aa(1) aa(1)],[0 .35],'m','linewidth',2)
nanstd(choice_prob_all(keep_spikes,:))/sqrt(sum(keep_spikes))
xlabel('Choice probability','FontSize',16)
set(gca,'FontSize',16)

figure
hold on
keep_spikes_out = clean_clusters & ismember(ps.barrel_loc,[8]);
keep_spikes = clean_clusters & ismember(ps.barrel_loc,[3 4 6 7 1 2 5]);
n_out = hist(choice_prob_all(keep_spikes_out,1),[0:.1:1])
n = hist(choice_prob_all(keep_spikes,1),[0:.1:1])
h = bar([0:.1:1],n/sum(n));
set(h,'FaceColor','g')
set(h,'EdgeColor','g')
h = bar([0:.1:1],n_out/sum(n_out),.3);
plot([0.5 0.5],[0 .1],'r')
nanmean(choice_prob_all(keep_spikes_out,:))
nanstd(choice_prob_all(keep_spikes_out,:))/sqrt(sum(keep_spikes_out))
nanmean(choice_prob_all(keep_spikes,:))
nanstd(choice_prob_all(keep_spikes,:))/sqrt(sum(keep_spikes))




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

refPeriods = [2.5 2.25 2.0 1.75 1.5];
all_viol = []
for ih = 1:numel(all_anm.data)
	for ij = 1:numel(all_anm.data{ih}.d.spike_times_cluster.spike_times_cluster)
		viols = zeros(1,length(refPeriods));
		for ik = 1:length(refPeriods)
			ISI = get_isi(all_anm.data{ih}.d.spike_times_cluster.spike_times_cluster{ij},refPeriods(ik)/1000);
			viols(ik) = ISI.violations;
		end
		all_viol = [all_viol;viols];
	end
end


figure;
hold on
plot(all_viol(:,1),all_viol(:,3),'.k')
plot(all_viol(examine==2,1),all_viol(examine==2,4),'.r')
xlabel('2.5 ms ISI')
ylabel('2.25 ms ISI')

all_viol(examine==2,4)

keep_spikes = examine==2 & all_viol(:,4) < 1.5;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
hold on
for ik = [0:2:10]

keep = all_anm.data{1}.d.u_ck(10,:)' == ik & all_anm.data{1}.d.u_ck(1,:)' <= 12;

r_t = mean(squeeze(all_anm.data{1}.d.r_ntk(1,:,keep)),2);
plot(r_t);

end



figure(1);
clf(1);
hold on
keep = all_anm.data{1}.d.u_ck(10,:)' <= 30 & all_anm.data{1}.d.u_ck(1,:)' <= 12;
r_t = mean(squeeze(all_anm.data{1}.d.r_ntk(13,:,keep)),2);
r_t = zscore(smooth(r_t,50,'sgolay',2));
plot(r_t)

Cxy = mscohere(r_t,s_t);
figure
plot(Cxy)



figure(1);
clf(1);
hold on
keep = all_anm.data{1}.d.u_ck(10,:)' <= 30 & all_anm.data{1}.d.u_ck(1,:)' <= 12;
r_t = mean(squeeze(all_anm.data{1}.d.r_ntk(11,:,keep)),2);
r_t = zscore(smooth(r_t,50,'sgolay',2));
plot(r_t)
s_t = mean(squeeze(all_anm.data{1}.d.s_ctk(6,:,keep)),2);
s_t = zscore(smooth(s_t,50,'sgolay',2));
plot(s_t,'r')
r_t = mean(squeeze(all_anm.data{1}.d.r_ntk(13,:,keep)),2);
r_t = zscore(smooth(r_t,50,'sgolay',2));
plot(r_t,'k')




figure(1);
clf(1);
hold on
ind = 12;
anm_name = total_order(ind,1);
clust_id = total_order(ind,2)-2;
anm_ind = find(ismember(all_anm.names,num2str(anm_name)));
target_dist = round(ps.touch_max_loc(ind)/2)*2
keep = ismember(all_anm.data{anm_ind}.d.u_ck(10,:)',target_dist-2:2:target_dist+2) & all_anm.data{anm_ind}.d.u_ck(1,:)' <= 12;
r_t = mean(squeeze(all_anm.data{anm_ind}.d.r_ntk(clust_id+2,:,keep)),2)*500;
r_t = smooth(r_t,25,'sgolay',1);
baseline = mean(r_t(150:250));
peak = mean(r_t(450:550));
adpat_val = mean(r_t(1300:1400));
(peak-adpat_val)./(peak+adpat_val)


plot(r_t)
target_dist = round(ps.touch_min_loc(ind)/2)*2
keep = ismember(all_anm.data{anm_ind}.d.u_ck(10,:)',target_dist-2:2:target_dist+2) & all_anm.data{anm_ind}.d.u_ck(1,:)' <= 12;
r_t = mean(squeeze(all_anm.data{anm_ind}.d.r_ntk(clust_id+2,:,keep)),2)*500;
r_t = smooth(r_t,25,'sgolay',1);
plot(r_t,'r')
baseline = mean(r_t(150:250));
peak = mean(r_t(450:550));
adpat_val = mean(r_t(1300:1400));
(peak-adpat_val)./(peak+adpat_val)


xlim([0 2000])

figure(3)
clf(3)
plot_tuning_curve_ephys([],all_anm.data{anm_ind}.d.summarized_cluster{clust_id}.TOUCH_TUNING)

figure(4)
clf(4)
plot_spk_raster([],all_anm.data{anm_ind}.d.summarized_cluster{clust_id}.RUNNING_RASTER)



%%%%%%%%%%%%%%%%%%%%
on_adapt = zeros(304,1);
off_adapt = zeros(304,1);

for ind = 1:304
anm_name = total_order(ind,1);
clust_id = total_order(ind,2)-2;
anm_ind = find(ismember(all_anm.names,num2str(anm_name)));
target_dist = round(ps.touch_max_loc(ind)/2)*2;
keep = ismember(all_anm.data{anm_ind}.d.u_ck(10,:)',target_dist-2:2:target_dist+2) & all_anm.data{anm_ind}.d.u_ck(1,:)' <= 12;
r_t = mean(squeeze(all_anm.data{anm_ind}.d.r_ntk(clust_id+2,:,keep)),2)*500;
r_t = smooth(r_t,100,'sgolay',1);

baseline = mean(r_t(150:250));
peak = mean(r_t(450:550));
adpat_val = mean(r_t(1300:1400));
on_adapt(ind) = (peak-adpat_val)./(peak+adpat_val);


target_dist = round(ps.touch_min_loc(ind)/2)*2;
keep = ismember(all_anm.data{anm_ind}.d.u_ck(10,:)',target_dist-2:2:target_dist+2) & all_anm.data{anm_ind}.d.u_ck(1,:)' <= 12;
r_t = mean(squeeze(all_anm.data{anm_ind}.d.r_ntk(clust_id+2,:,keep)),2)*500;
r_t = smooth(r_t,100,'sgolay',1);

baseline = mean(r_t(150:250));
peak = mean(r_t(450:550));
adpat_val = mean(r_t(1300:1400));
off_adapt(ind) = -(peak-adpat_val)./(peak+adpat_val);

end

off_adapt(isnan(off_adapt)) = 0;
on_adapt(isnan(on_adapt)) = 0;
on_adapt(on_adapt<0) = 0;
off_adapt(off_adapt<0) = 0;


ps.on_adapt = on_adapt;
ps.off_adapt = off_adapt;



%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RASTER PLOT

[raster_mat raster_mat_full raster_mat_rescale_full raster_col_mat rescale_time] = get_raster_col_mat(d,exp_type);
RASTER = d.summarized_cluster{13}.RUNNING_RASTER;
tuning_curve = d.summarized_cluster{13}.TOUCH_TUNING;

figure(25);
clf(25) 
set(gcf,'Position',[115   601   635   197])
        gap = [0.04 0.06];
        marg_h = [0.15 0.04];
        marg_w = [0.02 0.02];
subtightplot(1,3,1:2,gap,marg_h,marg_w)
plot_spk_raster_col([],RASTER,[],[],raster_mat_full);
subtightplot(1,3,3,gap,marg_h,marg_w)
plot_tuning_curve_ephys_col([],tuning_curve)


%subplot(1,2,1)
%plot_spk_raster_col([],RASTER,[],rescale_time,raster_mat_rescale_full);
%subplot(1,2,2)
%plot_spk_raster_col([],RASTER,[],[],raster_mat_full);

%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANALYSIS IN PCA SPACE

d = all_anm.data{1}.d; 
anm_id = all_anm.names{1};
spike_times_cluster = d.spike_times_cluster.spike_times_cluster;
    [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
    run_thresh = anm_params.run_thresh;
    trial_range_start = anm_params.trial_range_start;
    trial_range_end = anm_params.trial_range_end;
    cell_reject = anm_params.cell_reject;
    exp_type = anm_params.exp_type;
    layer_4_CSD = anm_params.layer_4;
    boundaries = anm_params.boundaries;
    boundary_labels = anm_params.boundary_labels;
    layer_4 = anm_params.layer_4_corr;
trial_range = trial_range_start(1):min(4000,trial_range_end(1));

time_range = [0 4];

  


id_type = 'olR';
keep_name = 'running';
constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials_tmp = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
u_ind = find(strcmp(d.u_labels,'trial_num'));
raw_trial_nums = d.u_ck(u_ind,:);
keep_trials = raw_trial_nums(keep_trials_tmp);
[group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type,[]);
groups_RASTER = d.u_ck(1,keep_trials_tmp);
g_tmp = zeros(4000,1);
g_tmp(keep_trials) = groups_RASTER;
groups_RASTER = g_tmp;

mean_ds = 1;
temp_smooth = 80;

all_psth = [];
%tmp = []
for clust_id = 1:numel(spike_times_cluster)
    RASTER = get_spk_raster(spike_times_cluster{clust_id}.spike_times_ephys,spike_times_cluster{clust_id}.spike_trials,keep_trials,groups_RASTER,group_ids_RASTER,time_range,mean_ds,temp_smooth);
    tmpP = RASTER.psth(:,50:end-50);
    all_psth = cat(3,all_psth,tmpP);
%    tmp = cat(2,tmp,tmpP(:));
end

time = RASTER.time(:,50:end-50);

id_type = 'olR';
keep_name = 'running';
constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials_tmp = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
groups = d.u_ck(1,keep_trials_tmp);
group_ids = unique(groups);
inds = d.u_ck(1,:);

avg_s = zeros(size(d.s_ctk,1),size(d.s_ctk,2),length(group_ids));
avg_r = zeros(size(d.r_ntk,1),size(d.r_ntk,2),length(group_ids));
for ij = 1:length(group_ids)
    sum(inds == ij & keep_trials_tmp)
    avg_s(:,:,ij) = squeeze(mean(d.s_ctk(:,:,inds == group_ids(ij) & keep_trials_tmp),3));
    avg_r(:,:,ij) = squeeze(mean(d.r_ntk(:,:,inds == group_ids(ij) & keep_trials_tmp),3));
end


% avg_s = zeros(size(d.s_ctk,1),size(d.s_ctk,2),length(group_ids));
% avg_r = zeros(size(d.r_ntk,1),size(d.r_ntk,2),length(group_ids));
avg_s = d.s_ctk(:,:,keep_trials_tmp);
avg_r = d.r_ntk(:,:,keep_trials_tmp);

avg_r = convn(avg_r,ones(1,temp_smooth,1)/temp_smooth,'same');

avg_r = avg_r(:,50:end-50,:);
avg_s = avg_s(:,50:end-50,:);
avg_r = permute(avg_r,[3 2 1]);
avg_s = permute(avg_s,[3 2 1]);

%avg_r = avg_r(:,:,d.p_nj(:,4)>50);

%avg_r = avg_r(:,:,8:9);

%%%%avg_r = squeeze(mean(avg_r,1));
 % X = reshape(avg_r,[size(avg_r,1)*size(avg_r,2), size(avg_r,3)]);
 % X = zscore(X,1);
 %X = bsxfun(@minus,X,mean(X,2));
 % [coeff,score,latent] = pca(X);

 % Y = reshape(score,[size(avg_r,1), size(avg_r,2), size(avg_r,3)]);

X = reshape(avg_r,[size(avg_r,1)*size(avg_r,2), size(avg_r,3)]);
X = bsxfun(@minus,X,mean(X,2));
X = bsxfun(@minus,X,mean(X,1));
[coeff,score,latent] = pca(X);
%score = X*coeff;
Z = reshape(score,[size(avg_r,1), size(avg_r,2), size(avg_r,3)]);


figure
hold on
set(gca,'visible','off')
set(gcf,'Color',[1 1 1])
keep_ij = find(avg_s(:,600,1)>-2 & avg_s(:,600,1)<200);
for ijk =  1:length(keep_ij) %% 3:size(avg_s,1)-3
    ij = keep_ij(ijk);
   %  traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
   %  norm_traj_x = traj(120,1);
   %  norm_traj_y = traj(120,2);
   %  rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
   %  traj = traj*rot;

   %  tmp = traj(:,2);
   %  tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
   % tmp = filtfilt(b,a,tmp);
   %  tmp = tmp(501:end-1000);
   %  tmp = diff(tmp);
   %  tmp = -[0;tmp];
       
        theta = atan2(Z(ij,:,2),Z(ij,:,1));
        theta = 2*pi - mod(theta+pi/2,2*pi);
        %theta = unwrap(theta)*180/pi;
        % inds = 1:length(theta);
        % theta(inds>400&theta<1) = theta(inds>400&theta<1)+2*pi;
t_shift = 0;
    %    dist = sqrt(Z(ij,:,1).^2+Z(ij,:,2).^2);
  %      scatter3([1:1300],Z(ij,1:1300,1),Z(ij,1:1300,2),[],avg_s(ij,1:1300,1))
        scatter(Z(ij,1:1300,1),Z(ij,1:1300,2),[],30-avg_s(ij,1:1300,1))
     %  scatter3([1:1300]-t_shift,Z(ij,1:1300,8),Z(ij,1:1300,9),[],time(1:1300))
        %scatter3([1:1902]-t_shift,Z(ij,1:1902,1),Z(ij,1:1902,2),[],avg_s(ij,1:1902,3))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
    %     scatter3([1:1300],avg_s(ij,1:1300,2),theta(1:1300),[],avg_s(ij,1:1300,2))
%        col_vec = -[diff(Y(ij,:,3)) 0];
  %      col_vec = Y(ij,:,8);

    %  scatter3([1:1300]-t_shift,Y(ij,1:1300,1),repmat(0,1300,1),[],'k')
    %  scatter3([1:1300]-t_shift,Y(ij,1:1300,2),repmat(1,1300,1),[],'b')
    % scatter3(avg_s(ij,1:1300,6),avg_s(ij,1:1300,1),theta(1:1300),[],avg_s(ij,1:1300,6))
    %  scatter3(avg_s(ij,1:1902,1),theta(1:1902),dist(1:1902),[],avg_s(ij,1:1902,3))
      %  scatter3([1:1300]-t_shift,theta(1:1300),avg_s(ij,1:1300,1),[],avg_s(ij,1:1300,1))
end  
xlim([-0.2 0.2])
ylim([-0.2 0.2])

avg_all = squeeze(mean(Z(:,800:1300,:),2));

avg_1 = mean(Z(:,800:1300,1),2);
avg_2 = mean(Z(:,800:1300,2),2);
theta = atan2(avg_2,avg_1);
%theta = unwrap(theta)*180/pi;
dist = sqrt(avg_1.^2+avg_2.^2);
%plot3(repmat(2000,12,1),theta,dist,'k','linewidth',2)
plot3(repmat(1300,12,1),avg_1,avg_2,'k','linewidth',2)
plot3(1300,0,0,'.k','MarkerSize',50)


wall_vals = squeeze(avg_s(:,700,1))

figure
hold on
plot(wall_vals,avg_all(:,1),'Color','b','LineWidth',2)
plot(wall_vals,avg_all(:,2),'Color','k','LineWidth',2)
plot(wall_vals,avg_all(:,3),'Color','r','LineWidth',2)


p = 10^-1;
curve1 = csaps(wall_vals,avg_1,p,x_fit_vals);
curve2 = csaps(wall_vals,avg_2,p,x_fit_vals);
curve3 = csaps(wall_vals,avg_all(:,3),p,x_fit_vals);
plot(x_fit_vals,curve1,'Color','b','LineWidth',2)
plot(x_fit_vals,curve2,'Color','k','LineWidth',2)
plot(x_fit_vals,curve3,'Color','r','LineWidth',2)


           
figure
hold on
plot(curve1,curve2,'Color','b','LineWidth',2)
plot(avg_1,avg_2,'Color','k','LineWidth',2)



figure
subplot(1,3,1)
hold on
plot(x_fit_vals,curve1,'Color','b','LineWidth',2)
subplot(1,3,2)
hold on
plot(x_fit_vals,curve2,'Color','b','LineWidth',2)
plot(x_fit_vals,[diff(curve1) 0]*10,'Color','k','LineWidth',2)
subplot(1,3,3)
hold on
plot(x_fit_vals,zscore(curve3),'Color','b','LineWidth',2)
plot(x_fit_vals,-zscore([diff(curve2) 0]),'Color','k','LineWidth',2)


coeff_mod = coeff;

coeff_mod(abs(coeff_mod)<.4) = 0;
figure
hold on
plot(coeff(:,1),coeff(:,2),'.k')
plot(coeff_mod(:,1),coeff_mod(:,2),'.b')


find(coeff_mod(:,1))
coeff_mod(abs(coeff_mod(:,1))>0,1)
find(coeff_mod(:,2))
coeff_mod(abs(coeff_mod(:,2))>0,2)











figure
hold on
for ij = 1:size(avg_s,1)
        traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;
%    scatter3(Y(ij,:,1),Y(ij,:,2),Y(ij,:,3),[],traj(:,2))
    scatter3(Y(ij,:,1),Y(ij,:,2),Y(ij,:,3),[],avg_s(ij,:,1))
end

figure
hold on
for ij = 1:12
scatter3([1:1802],avg_s(ij,:,5) - mean(avg_s(ij,1:100,5)),avg_s(ij,:,1),[],avg_s(ij,:,4))
end

figure
hold on
for ij = 1:12
plot(avg_s(ij,:,1),avg_s(ij,:,5),[],avg_s(ij,:,5))
end


norm_traj_x = sum(avg_s(12,:,4))/500;
norm_traj_y = sum(avg_s(12,:,5))/500;

rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
figure
hold on
for ij = 1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(200,1);
    norm_traj_y = traj(200,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;
    %traj = bsxfun(@minus,traj,mean(traj(1:50,:)));
    scatter3(traj(:,1),traj(:,2),avg_s(ij,:,1),[],Y(ij,:,1))
    plot3(traj(200,1),traj(200,2),avg_s(ij,200,1),'.','MarkerEdgeColor','k','MarkerSize',20)
end



d_F = fdesign.lowpass('N,Fc',4,1,500);
H_bp = design(d_F,'butter');
[b a] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);
    

figure
hold on
for ij = 1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
   tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = [0;tmp];
    t_shift = find(Y(ij,:,1)>.01,1,'first');
    if isempty(t_shift) || t_shift > 600
        t_shift = 500;
    else
        avg_s(ij,t_shift,1)
        tmp(t_shift)
        scatter3([1:size(traj,1)]-t_shift,tmp,Y(ij,:,2),[],avg_s(ij,:,1))
    end
end


figure
hold on
for ij = 1:1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
   tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = -[0;tmp];
    t_shift = find(tmp>.002,1,'first');
    if isempty(t_shift) || t_shift > 300
        t_shift = 500;
    else
        theta = atan2(Z(ij,:,2),Z(ij,:,1));
        theta = 2*pi - mod(theta+pi/2,2*pi);
        %theta = unwrap(theta)*180/pi;
        inds = 1:length(theta);
        theta(inds>400&theta<1) = theta(inds>400&theta<1)+2*pi;

        dist = sqrt(Z(ij,:,1).^2+Z(ij,:,2).^2);
      %  scatter3([1:1300]-t_shift,Y(ij,1:1300,1),Y(ij,1:1300,2),[],avg_s(ij,1:1300,1))
    %    scatter3([1:1902]-t_shift,Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
        %scatter3([1:1300]-t_shift,theta(1:1300),dist(1:1300),[],avg_s(ij,1:1300,1))
%        col_vec = -[diff(Y(ij,:,3)) 0];
        col_vec = avg_s(ij,1:1300,1);

   %    scatter3([1:t_shift+250] - t_shift,Y(ij,1:t_shift+250,3),Y(ij,1:t_shift+250,6),[],tmp(1:t_shift+250)-mean(tmp(1:t_shift)))
       scatter3([1:t_shift+250] - t_shift,tmp(1:t_shift+250)-mean(tmp(1:t_shift)),col_vec(1:t_shift+250),[],col_vec(1:t_shift+250))
    %    scatter3(avg_s(ij,1:1300,1),theta(1:1300),tmp(1:1300),[],avg_s(ij,1:1300,1))
  %      scatter3([1:1300]-t_shift,dist(1:1300),avg_s(ij,1:1300,1),[],avg_s(ij,1:1300,6))
    end
end   



figure
hold on
for ij = 1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
   tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = -[0;tmp];
    t_shift = find(Y(ij,:,1)>.01,1,'first');
    if isempty(t_shift) || t_shift > 600
        t_shift = 500;
    else
        theta = atan2(Y(ij,:,2),Y(ij,:,1));
        theta = 2*pi - mod(theta+pi/2,2*pi);
        %theta = unwrap(theta)*180/pi;
        inds = 1:length(theta);
        theta(inds>400&theta<1) = theta(inds>400&theta<1)+2*pi;

        dist = sqrt(Y(ij,:,1).^2+Y(ij,:,2).^2);
    %    scatter3([1:1300]-t_shift,Y(ij,1:1300,1),Y(ij,1:1300,2),[],avg_s(ij,1:1300,1))
    %    scatter3([1:1902]-t_shift,Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
       % scatter3([1:1300],avg_s(ij,1:1300,2),dist(1:1300),[],avg_s(ij,1:1300,2))
%        col_vec = -[diff(Y(ij,:,3)) 0];
  %      col_vec = Y(ij,:,8);

     %  scatter3([1:1300]-t_shift,Y(ij,1:1300,1),repmat(0,1300,1),[],'k')
     %  scatter3([1:1300]-t_shift,Y(ij,1:1300,2),repmat(1,1300,1),[],'b')
  %      scatter3(avg_s(ij,1:1300,1),theta(1:1300),tmp(1:1300),[],avg_s(ij,1:1300,1))
        scatter3([1:1300]-t_shift,theta(1:1300),avg_s(ij,1:1300,1),[],avg_s(ij,1:1300,1))
    end
end  

d_F = fdesign.lowpass('N,Fc',4,1,500);
H_bp = design(d_F,'butter');
[b a] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);
  
for ij = 1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
    tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = -[0;tmp];

    avg_s(ij,:,6) = tmp;
end


figure
hold on
y = zeros(size(avg_s,1),1);
w = zeros(32,1);
w(1) = 1;
keep_ij = find(avg_s(:,600,1)>-2 & avg_s(:,600,1)<200);
for ijk =  1:length(keep_ij) %% 3:size(avg_s,1)-3
    ij = keep_ij(ijk);
    
    y(ij) = mean(tmp(300:400));
    t_shift = find(Z(ij,:,1)>.01,1,'first');
    if isempty(t_shift) || t_shift > 600
        t_shift = 500;
    else
        theta = atan2(Z(ij,:,2),Z(ij,:,1));
        theta = 2*pi - mod(theta+pi/2,2*pi);
        %theta = unwrap(theta)*180/pi;
        inds = 1:length(theta);
        theta(inds>400&theta<1) = theta(inds>400&theta<1)+2*pi;

        dist = sqrt(Z(ij,:,1).^2+Z(ij,:,2).^2);
      %  scatter3([1:1300]-t_shift,Y(ij,1:1300,1),Y(ij,1:1300,2),[],avg_s(ij,1:1300,1))
    %    scatter3([1:1902]-t_shift,Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
        %scatter3([1:1300]-t_shift,theta(1:1300),dist(1:1300),[],avg_s(ij,1:1300,1))
%        col_vec = -[diff(Y(ij,:,3)) 0];
        %col_vec = Z(ij,:,1);
        col_vec = squeeze(Z(ij,:,:))*w;
        col_vec = avg_s(ij,1:700,1);
        %col_vec = theta;
        %col_vec = -squeeze(avg_r(ij,:,:))*w;
%col_vec(col_vec<-0.1) = -.1;
%col_vec(col_vec>0.1) = 0.1;
   %    scatter3([1:1300],avg_s(ij,1:1300,1),tmp(1:1300),[],col_vec(1:1300))
        scatter([1:700],avg_s(ij,1:700,6),[],col_vec(1:700))
    %   scatter3(avg_s(ij,1:1300,1),theta(1:1300),tmp(1:1300),[],avg_s(ij,1:1300,1))
  %     scatter3([1:1300]-t_shift,dist(1:1300),avg_s(ij,1:1300,1),[],avg_s(ij,1:1300,6))
    end
end   










d_F = fdesign.lowpass('N,Fc',4,1,500);
H_bp = design(d_F,'butter');
[b a] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);
  

for ij = 1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)/500));
    norm_traj_x = traj(250,1);
    norm_traj_y = traj(250,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
    tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = -[0;tmp];
    
    avg_s(ij,:,6) = tmp;
end



traj = squeeze(cumsum(avg_s(:,:,4:5),2))/500;

figure
plot(traj(:,700,1),traj(:,700,2),'.k')

figure
hold on
y = zeros(size(avg_s,1),1);
w = zeros(size(avg_r,3),1);
w(1) = 1;
keep_ij = find(avg_s(:,600,1)>2 & avg_s(:,600,1)<20 & traj(:,700,1)>15);
for ijk =  1:length(keep_ij) %% 3:size(avg_s,1)-3
    ij = keep_ij(ijk);
    

        theta = atan2(Z(ij,:,2),Z(ij,:,1));
        theta = 2*pi - mod(theta+pi/2,2*pi);
        %theta = unwrap(theta)*180/pi;
        inds = 1:length(theta);
        theta(inds>400&theta<1) = theta(inds>400&theta<1)+2*pi;

      %  dist = sqrt(Z(ij,:,1).^2+Z(ij,:,2).^2);
      %  scatter3([1:1300]-t_shift,Y(ij,1:1300,1),Y(ij,1:1300,2),[],avg_s(ij,1:1300,1))
    %    scatter3([1:1902]-t_shift,Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
      %  scatter3(Y(ij,1:1902,3),Y(ij,1:1902,1),Y(ij,1:1902,2),[],avg_s(ij,1:1902,2))
        %scatter3([1:1300]-t_shift,theta(1:1300),dist(1:1300),[],avg_s(ij,1:1300,1))
%        col_vec = -[diff(Y(ij,:,3)) 0];
        col_vec = Z(ij,:,2);
        %col_vec = squeeze(Z(ij,:,:))*w;
        %col_vec = avg_s(ij,1:700,1);
        %col_vec = theta;
        %col_vec = -squeeze(avg_r(ij,:,:))*w;
%col_vec(col_vec<-0.1) = -.1;
%col_vec(col_vec>0.1) = 0.1;
       scatter3([1:5:1300],avg_s(ij,1:5:1300,6),avg_s(ij,1:5:1300,1),[],col_vec(1:5:1300))
    %    scatter([1:700],avg_s(ij,1:700,6),[],col_vec(1:700))
   %     scatter(traj(1:700,1)+ij,traj(1:700,2),[],col_vec(1:700))

    %   scatter3(avg_s(ij,1:1300,1),theta(1:1300),tmp(1:1300),[],avg_s(ij,1:1300,1))
  %     scatter3([1:1300]-t_shift,dist(1:1300),avg_s(ij,1:1300,1),[],avg_s(ij,1:1300,6))
end   






run_angle = mean(avg_s(:,690:700,6),2);
wall_pos = mean(avg_s(:,600:700,1),2);
%col_vec = squeeze(mean(Z(:,100:700,1:2),2));
%col_vec = atan2(col_vec(:,2),col_vec(:,1));
%col_vec = 2*pi - mod(col_vec+pi/2,2*pi);

col_vec = squeeze(mean(mean(avg_r(:,100:700,abs(d.p_nj(:,4))<100),3),2));

%col_vec(col_vec<pi) = col_vec(col_vec<pi)+2*pi;
        %theta(inds>400&theta<1) = theta(inds>400&theta<1)+2*pi;

%col_vec = sqrt(col_vec(:,1).^2+col_vec(:,2).^2);

%col_vec = squeeze(mean(Z(:,100:700,1),2));
    traj = squeeze(cumsum(avg_s(:,:,4:5),2))/500;

wall_pos(wall_pos>20) = 20;
col_vec = col_vec(wall_pos>0&wall_pos<=20 & traj(:,700,1)>15);
run_angle = run_angle(wall_pos>0&wall_pos<=20 & traj(:,700,1)>15);
wall_pos_n = wall_pos(wall_pos>0&wall_pos<=20 & traj(:,700,1)>15);


[wall_vals b inds] = unique(wall_pos_n);
vals = accumarray(inds,run_angle,[length(wall_vals) 1],@mean,nan);
      
mdl = LinearModel.fit(wall_pos_n,run_angle);
%vals = feval(mdl,wall_vals);
mean_run_angle = vals(inds);

vals = accumarray(inds,col_vec,[length(wall_vals) 1],@mean,nan);
mdl = LinearModel.fit(wall_pos_n,col_vec)
%vals = feval(mdl,wall_vals);
mean_col_vec = vals(inds);


norm_act = squeeze(mean(avg_r(:,100:700,:),2));
norm_act_mod = [];
for ij = 1:size(norm_act,2)
    tmp = norm_act(:,ij);
    tmp = tmp(wall_pos>0&wall_pos<=20 & traj(:,700,1)>15);
    vals = accumarray(inds,tmp,[length(wall_vals) 1],@mean,nan);
    tmp_n = vals(inds);
    norm_act_mod(:,ij) = tmp; % - tmp_n;
end
%w = regress(run_angle-mean_run_angle,norm_act_mod);
w = regress(run_angle,norm_act_mod);

col_vec = norm_act_mod*w;
%col_vec = col_vec(wall_pos>0&wall_pos<=20 & traj(:,700,1)>15);
wall_pos = wall_pos_n;

vals = accumarray(inds,col_vec,[length(wall_vals) 1],@mean,nan);
mean_col_vec = vals(inds);



figure(16)
clf(16)
subplot(1,4,1)
scatter(wall_pos,run_angle,[],col_vec)
subplot(1,4,2)
plot(col_vec-mean_col_vec,run_angle-mean_run_angle,'.k')
subplot(1,4,3)
plot(wall_pos,col_vec,'.k')
subplot(1,4,4)
plot(col_vec,run_angle,'.k')


mdl = LinearModel.fit(wall_pos,run_angle)

mdl = LinearModel.fit(wall_pos,col_vec)

mdl = LinearModel.fit(col_vec,run_angle)

mdl = LinearModel.fit(col_vec-mean_col_vec,run_angle-mean_run_angle)


w_run = regress(run_angle,norm_act_mod);
w_wall = regress(wall_pos,norm_act_mod);


figure(16)
clf(16)
subplot(1,4,1)
col_vec = norm_act_mod*w_run;
scatter(wall_pos,run_angle,[],col_vec)
subplot(1,4,2)
col_vec = norm_act_mod*w_wall;
scatter(wall_pos,run_angle,[],col_vec)
subplot(1,4,3)
col_vec = norm_act_mod*w_wall;
plot(wall_pos,col_vec,'.k')
mdl = LinearModel.fit(wall_pos,col_vec)
subplot(1,4,4)
col_vec = norm_act_mod*w_run;
plot(col_vec,run_angle,'.k')
mdl = LinearModel.fit(col_vec,run_angle)



figure
plot(w_run,w_wall,'.k')


%A = squeeze(mean(Z(:,800:1300,:),2));
A = squeeze(mean(avg_r(:,300:400,:),2));
%y = squeeze(mean(avg_s(:,800:1300,1),2));
w = regress(y,A);

figure;
plot(A*w,y,'.k')

avg_1 = mean(Y(:,300:400,1),2);
avg_2 = mean(Y(:,800:400,2),2);
theta = atan2(avg_2,avg_1);
%theta = unwrap(theta)*180/pi;
dist = sqrt(avg_1.^2+avg_2.^2);
%plot3(repmat(2000,12,1),theta,dist,'k','linewidth',2)
plot3(repmat(1300,12,1),avg_1,avg_2,'k','linewidth',2)
plot3(1300,0,0,'.k','MarkerSize',50)


wall_vals = squeeze(avg_s(:,700,1))

figure
hold on
plot(wall_vals,avg_1,'Color','b','LineWidth',2)
plot(wall_vals,avg_2,'Color','k','LineWidth',2)




figure
hold on
for ij = 2:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
   tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = [0;tmp];
%    t_shift = find(Y(ij,:,1)>.01,1,'first');
    shift_vec = Y(ij,1:1750,1);
    t_shift = find(shift_vec>0,1,'last')
    if isempty(t_shift) %|| t_shift > 600
        t_shift = 500;
    else
        theta = atan2(Y(ij,:,2),Y(ij,:,1));
        theta = 2*pi - mod(theta+pi/2,2*pi);
        %theta = unwrap(theta)*180/pi;
        inds = 1:length(theta);
        theta(inds<1500&theta<1) = theta(inds<1500&theta<1)+2*pi;
        
        dist = sqrt(Y(ij,:,1).^2+Y(ij,:,2).^2);
     %   scatter3([1:1902]-t_shift,Y(ij,1:end,1),Y(ij,1:end,2),[],avg_s(ij,1:end,1))
        %scatter3([1:1300]-t_shift,theta(1:1300),dist(1:1300),[],avg_s(ij,1:1300,1))
        scatter3([1301:1902]-t_shift,theta(1301:1902),avg_s(ij,1301:1902,1),[],avg_s(ij,1301:1902,1))
  %      scatter3([1:1300]-t_shift,theta(1:1300),tmp(1:1300),[],avg_s(ij,1:1300,1))
  %      scatter3([1:1300]-t_shift,dist(1:1300),avg_s(ij,1:1300,1),[],avg_s(ij,1:1300,6))
    end
end
     



avg_1 = mean(Y(:,800:1300,1),2);
avg_2 = mean(Y(:,800:1300,2),2);

theta = atan2(avg_2,avg_1);
theta = unwrap(theta)*180/pi
dist = sqrt(avg_1.^2+avg_2.^2)

figure
hold on
%plot(avg_1,avg_2)
plot(theta)








figure
hold on
for ij = 1:12
    traj = squeeze(cumsum(avg_s(ij,:,4:5)))/500;
    norm_traj_x = traj(120,1);
    norm_traj_y = traj(120,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;
    %traj = bsxfun(@minus,traj,mean(traj(1:50,:)));
    plot(traj(:,2),Y(ij,:,2),'r')
end





figure;
plot(squeeze(BV(3,:,:)))

time = RASTER.time(:,50:end-50);
row_psth = squeeze(mean(all_psth,3));
X = reshape(all_psth,[size(all_psth,1)*size(all_psth,2), size(all_psth,3)]);
X = bsxfun(@minus,X,mean(X,2));
[coeff,score,latent] = pca(X);

Y = reshape(score,[size(all_psth,1), size(all_psth,2), size(all_psth,3)]);

wall_mat = zeros(length(group_ids_RASTER),4000);
for ij = 1:length(group_ids_RASTER)
    ind = find(d.u_ck(1,:) == ij,1,'first');
    wall_val = d.u_ck(11,ind);
    wall_mat(ij,1:1000) = linspace(30,wall_val,1000);
    wall_mat(ij,1001:3000) = wall_val;
    wall_mat(ij,3001:4000) = linspace(wall_val,30,1000);
end
wall_mat = wall_mat(:,time(1)*1000:time(1)*1000+length(time)-1);
wall_vel = diff(wall_mat,[],2);
wall_vel = cat(2,wall_vel(:,1),wall_vel);

col_mat = zeros(12,3);
col_mat(:,3) = linspace(1,0,12);
figure
hold on
for ij = 1:12
plot3(Y(ij,:,1),Y(ij,:,2),Y(ij,:,3),'Color',col_mat(ij,:))
end

figure
hold on
for ij = 1:12
scatter3(Y(ij,:,1),Y(ij,:,2),Y(ij,:,3),[],time)
end

figure
hold on
for ij = [1 12]
scatter3(Y(ij,:,1),Y(ij,:,2),Y(ij,:,3),[],wall_mat(ij,:))
time_ind = find(time==1);
plot3(Y(ij,time_ind,1),Y(ij,time_ind,2),Y(ij,time_ind,3),'.','MarkerEdgeColor','k','MarkerSize',20)
time_ind = find(time==3);
plot3(Y(ij,time_ind,1),Y(ij,time_ind,2),Y(ij,time_ind,3),'.','MarkerEdgeColor','k','MarkerSize',20)
end

figure
hold on
for ij = 1:12
scatter3(Y(ij,:,1),Y(ij,:,2),Y(ij,:,3),[],wall_vel(ij,:))
end


scatter3(Y(3,:,1),Y(3,:,2),Y(3,:,3),[],time)


figure
plot_spk_raster([],RASTER)
figure
plot_spk_psth([],RASTER);


order = d.p_nj(d.p_nj(:,10)>500,4);
[ind val] = sort(order);

id_type = 'olR';
time_range = [0 1];
%SPK_CORR_ALL = get_full_trial_spk_corr(1:numel(spike_times_cluster),1:numel(spike_times_cluster),spike_times_cluster,d,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
SPK_CORR_ALL = get_full_trial_spk_corr(val,val,spike_times_cluster,d,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
stim_name = 'corPos';

figure; plot_spk_corr([],SPK_CORR_ALL);


clust_id1 = 9;
clust_id2 = 21;
plot_tuning_and_corr;

plot_depth_all(d,spike_times_cluster)


spike_times = cat(1,spike_times_cluster{10}.spike_times,spike_times_cluster{11}.spike_times);
spike_times = sort(spike_times);
ISI = get_isi(spike_times,[]);
figure; plot_isi([],ISI)



AMPLITUDES = spike_times_cluster{1}.interp_amp;
figure; plot_depth_amp([],AMPLITUDES)











%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
keep_name = 'base';
spike_times_cluster = get_all_LFP_hist(spike_times_cluster,lfp_data,d,keep_name,exp_type,id_type,time_range,trial_range,run_thresh)


clust_id = 9;
figure;
hold on
edges = linspace(-pi,pi,16);
curve = histc(spike_times_cluster{clust_id}.spike_phase,edges);
curve = curve(1:end-1);
edges = edges(1:end-1) + mean(diff(edges))/2;
curve = curve/sum(curve);
h = bar(edges,curve)
set(h,'FaceColor','k')
set(h,'EdgeColor','k')
p = 10^-.5;
edges_int = linspace(-pi,pi,40);
model_fit_curve = csaps(edges,curve,p,edges_int);
plot(edges_int,model_fit_curve,'linewidth',2,'color','b')
xlim([-pi pi])

figure;
for clust_id = [8 9];
hold on
edges = linspace(-pi,pi,16);
curve = histc(spike_times_cluster{clust_id}.spike_phase,edges);
curve = curve(1:end-1);
edges = edges(1:end-1) + mean(diff(edges))/2;
curve = curve/sum(curve);
%h = bar(edges,curve)
plot(edges,curve,'linewidth',2,'color','k')
xlim([-pi pi])
end


p = 10^-.5;
edges_int = linspace(-pi,pi,40);
model_fit_curve = csaps(edges,curve,p,edges_int);
           
figure
hold on
plot(edges,curve,'linewidth',2,'color','r')
plot(edges_int,model_fit_curve,'linewidth',2,'color','k')





figure;
for clust_id = [8 9 21 26];
hold on
edges = linspace(-pi,pi,16);
curve = histc(spike_times_cluster{clust_id}.spike_phase,edges);
curve = curve(1:end-1);
edges = edges(1:end-1) + mean(diff(edges))/2;
curve = curve/sum(curve);
curve = zscore(curve);
%h = bar(edges,curve)
p = 10^-.5;
edges_int = linspace(-pi,pi,40);
model_fit_curve = csaps(edges,curve,p,edges_int);
plot(edges_int,model_fit_curve,'linewidth',2,'color','b')
xlim([-pi pi])
end
for clust_id = [2 5 15 18 25 27];
hold on
edges = linspace(-pi,pi,16);
curve = histc(spike_times_cluster{clust_id}.spike_phase,edges);
curve = curve(1:end-1);
edges = edges(1:end-1) + mean(diff(edges))/2;
curve = curve/sum(curve);
curve = zscore(curve);
%h = bar(edges,curve)
p = 10^-.5;
edges_int = linspace(-pi,pi,40);
model_fit_curve = csaps(edges,curve,p,edges_int);
plot(edges_int,model_fit_curve,'linewidth',2,'color','k')
xlim([-pi pi])
end

[l_ctk l_labels] = get_behaviour_LFP(d,lfp_data)

%%
figure
hold on
plot(zscore(lfp_data.flt_vlt_ephys{1}))
plot(angle(hilbert(lfp_data.flt_vlt_ephys{1})),'r')


figure;
hold on
plot(zscore(l_ctk(1,:,17)))
plot(zscore(l_ctk(2,:,17)),'r')
plot(zscore(ex_ctk(4,:,17)),'g')

aa = squeeze(l_ctk(4,:,:));
bb = squeeze(ex_ctk(3,:,:));
cc = squeeze(d.s_ctk(3,:,:));
X = [aa(:) bb(:)];
y = cc(:);

n2 = hist3(X(y>5,:),[20 20]);
figure
imagesc(n2)


             freq = 500;
             d_F = fdesign.bandpass('N,Fc1,Fc2',4,2,8,freq);
             H_bp = design(d_F,'butter');
             [b a] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);
             d_F2 = fdesign.bandpass('N,Fc1,Fc2',4,12,25,freq);
             H_bp2 = design(d_F2,'butter');
             [b2 a2] = sos2tf(H_bp2.sosMatrix,H_bp2.scaleValues);
        
      
      ex_ctk = zeros(4,size(d.s_ctk,2),size(d.s_ctk,3));
for ij = 1:size(d.s_ctk,3)
    x = d.s_ctk(3,:,ij);
    tmp = filtfilt(b,a,x);
    ex_ctk(1,:,ij) = tmp;
    tmp = filtfilt(b2,a2,x);
    ex_ctk(2,:,ij) = tmp;
    ex_ctk(3,:,ij) = angle(hilbert(ex_ctk(1,:,ij)));
    ex_ctk(4,:,ij) = angle(hilbert(ex_ctk(2,:,ij)));
end

Cxy_all = zeros(size(d.s_ctk,3),513);
for ij = 1:size(d.s_ctk,3)
    x = squeeze(d.s_ctk(3,:,ij));
    y = squeeze(l_ctk(1,:,ij));
    [Cxy F] = mscohere(x,y,hamming(500),450,1024,500);;
    Cxy_all(ij,:) = Cxy;
end

n = mean(Cxy_all(d.u_ck(2,:)>5,:));

figure
plot(F,n)


Cxy_all = zeros(size(d.s_ctk,3),513);
for ij = 1:size(d.s_ctk,3)-1
    x = squeeze(d.s_ctk(5,:,ij));
    y = squeeze(l_ctk(1,:,ij));
    [Cxy F] = mscohere(x,y,hamming(500),450,1024,500);
    Cxy_all(ij,:) = Cxy;
end

n = mean(Cxy_all(d.u_ck(2,:)>5,:));

figure
plot(F,n)
xlim([0 40])






figure
plot(sorted_spikes{1}.ephys_index,sorted_spikes{1}.ephys_time,'.k')


sorted_spikes{33}.clust_id = 34;
sorted_spikes{33}.detected_chan = sorted_spikes{10}.detected_chan;
sorted_spikes{33}.trial_num = cat(1,sorted_spikes{10}.trial_num,sorted_spikes{11}.trial_num);
sorted_spikes{33}.session_id_num = cat(1,sorted_spikes{10}.session_id_num,sorted_spikes{11}.session_id_num);
sorted_spikes{33}.ephys_index = cat(1,sorted_spikes{10}.ephys_index,sorted_spikes{11}.ephys_index);
sorted_spikes{33}.ephys_time = cat(1,sorted_spikes{10}.ephys_time,sorted_spikes{11}.ephys_time);
sorted_spikes{33}.bv_index = cat(1,sorted_spikes{10}.bv_index,sorted_spikes{11}.bv_index);
sorted_spikes{33}.laser_power = cat(1,sorted_spikes{10}.laser_power,sorted_spikes{11}.laser_power);
sorted_spikes{33}.spike_amp = cat(1,sorted_spikes{10}.spike_amp,sorted_spikes{11}.spike_amp);
sorted_spikes{33}.session_time = cat(1,sorted_spikes{10}.session_time,sorted_spikes{11}.session_time);
sorted_spikes{33}.spike_waves = cat(1,sorted_spikes{10}.spike_waves,sorted_spikes{11}.spike_waves);
sorted_spikes{33}.mean_spike_amp = (sorted_spikes{10}.mean_spike_amp+sorted_spikes{11}.mean_spike_amp)/2;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPEN / CLOSED LOOP COMPARISION

gap = [0.08 0.06];
marg_h = [0.07 0.02];
marg_w = [0.03 0.02];
2
clust_id = 23;
figure
set(gcf,'position',[38   594   962   204])
id_type = 'olR';
keep_name = 'running';
tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
curve1 = tuning_curve.model_fit.curve;
subtightplot(1,4,1,gap,marg_h,marg_w);
plot_tuning_curve_ephys([],tuning_curve)
id_type = 'clR';
keep_name = 'running';
subtightplot(1,4,2,gap,marg_h,marg_w);
tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
curve2 = tuning_curve.model_fit.curve;
plot_tuning_curve_ephys([],tuning_curve)
subtightplot(1,4,3,gap,marg_h,marg_w);
hold on
plot(x_fit_vals,curve1,'Color',[0 0 0],'LineWidth',2)
plot(x_fit_vals,curve2,'Color',[0 0 .6],'LineWidth',2)
xlim([tuning_curve.regressor_obj.x_range])
xlabel(tuning_curve.regressor_obj.x_label)
ylabel('firing rate')
set(gca,'xtick',tuning_curve.regressor_obj.x_tick)
subtightplot(1,4,4,gap,marg_h,marg_w);
hold on
plot(x_fit_vals,zscore(curve1),'Color',[0 0 0],'LineWidth',2)
plot(x_fit_vals,zscore(curve2),'Color',[0 0 .6],'LineWidth',2)
xlim([tuning_curve.regressor_obj.x_range])
xlabel(tuning_curve.regressor_obj.x_label)
ylabel('z-score firing rate')
set(gca,'xtick',tuning_curve.regressor_obj.x_tick)





%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike corr analysis
X_all = [];
for ikk = 1:numel(all_anm.data)
d = all_anm.data{ikk}.d; 
anm_id = all_anm.names{ikk};
spike_times_cluster = d.spike_times_cluster.spike_times_cluster;
    [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
    run_thresh = anm_params.run_thresh;
    trial_range_start = anm_params.trial_range_start;
    trial_range_end = anm_params.trial_range_end;
    cell_reject = anm_params.cell_reject;
    exp_type = anm_params.exp_type;
    layer_4_CSD = anm_params.layer_4;
    boundaries = anm_params.boundaries;
    boundary_labels = anm_params.boundary_labels;
    layer_4 = anm_params.layer_4_corr;
trial_range = trial_range_start(1):min(4000,trial_range_end(1));

time_range = [0 4];

  
id_type = 'olR';
keep_name = 'running';
constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials_tmp = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
groups = d.u_ck(1,keep_trials_tmp);
group_ids = unique(groups);
inds = d.u_ck(1,:);

avg_s = zeros(size(d.s_ctk,1),size(d.s_ctk,2),length(group_ids));
avg_r = zeros(size(d.r_ntk,1),size(d.r_ntk,2),length(group_ids));
for ij = 1:length(group_ids)
    sum(inds == ij & keep_trials_tmp)
    avg_s(:,:,ij) = squeeze(mean(d.s_ctk(:,:,inds == group_ids(ij) & keep_trials_tmp),3));
    avg_r(:,:,ij) = squeeze(mean(d.r_ntk(:,:,inds == group_ids(ij) & keep_trials_tmp),3));
end

% avg_s = zeros(size(d.s_ctk,1),size(d.s_ctk,2),length(group_ids));
% avg_r = zeros(size(d.r_ntk,1),size(d.r_ntk,2),length(group_ids));
% avg_s = d.s_ctk(:,:,keep_trials_tmp);
% avg_r = d.r_ntk(:,:,keep_trials_tmp);


avg_r = convn(avg_r,ones(1,temp_smooth,1)/temp_smooth,'same');

avg_r = avg_r(:,50:end-50,:);
avg_s = avg_s(:,50:end-50,:);
avg_r = permute(avg_r,[3 2 1]);
avg_s = permute(avg_s,[3 2 1]);

X = reshape(avg_r,[size(avg_r,1)*size(avg_r,2), size(avg_r,3)]);
X = bsxfun(@minus,X,mean(X,2));

X_all = cat(2,X_all,X);
end

[coeff,score,latent] = pca(X_all);

Y = reshape(score,[size(avg_r,1), size(avg_r,2), size(avg_r,3)]);





%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
% Dimensionality reduction simulation


norm_mat = zeros(200,300);
for ij = 1:200
    mu = rand*150;
    %mu = randn*70+150;                                %// Mean
    sigma = 50;                            %// Standard deviation
    %// Plot curve
    x = (-5 * sigma:0.01:5 * sigma) + mu;
    y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));

    x = round(x);
    ind = x>=1 & x <=300;
    norm_mat(ij,x(ind)) = y(ind);
end
figure; imagesc(norm_mat)

%[coeff,score,latent] = pca(norm_mat');
[W,H] = nnmf(norm_mat',2)
score = W;
score = bsxfun(@minus,score,mean(score));
figure
hold on
plot([1 size(norm_mat,2)],[0 0],'k','linewidth',2)
plot(score(:,1))
plot(score(:,2),'g')
%plot(score(:,3),'r')

figure
hold on
plot(0,0,'.k')
plot(score(:,1),score(:,2))



norm_mat = zeros(200,300);
for ij = 1:101
    mu = rand*150;
    %mu = randn*70+150;                                %// Mean
    sigma = 50;                            %// Standard deviation
    %// Plot curve
    x = (-5 * sigma:0.01:5 * sigma) + mu;
    y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));

    x = round(x);
    ind = x>=1 & x <=300;
    norm_mat(ij,x(ind)) = y(ind);
end
for ij = 101:200
    mu = rand*150;
    %mu = randn*70+150;                                %// Mean
    sigma = 50;                            %// Standard deviation
    %// Plot curve
    x = (-5 * sigma:0.01:5 * sigma) + mu;
    y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));

    x = round(x);
    ind = x>=1 & x <=300;
    norm_mat(ij,x(ind)) = max(y) - y(ind);
    norm_mat(ij,max(x(ind)):end) = max(y);
end
norm_mat(norm_mat<0) = 0;
figure; imagesc(norm_mat)

%[coeff,score,latent] = pca(norm_mat');
[W,H] = nnmf(norm_mat',2)
score = W;
score = bsxfun(@minus,score,mean(score));
figure
hold on
plot([1 size(norm_mat,2)],[0 0],'k','linewidth',2)
plot(score(:,1))
plot(score(:,2),'g')
%plot(score(:,3),'r')

figure
hold on
plot(0,0,'.k')
plot(score(:,1),score(:,2))


% figure
% hold on
% plot([1 size(norm_mat,2)],[0 0],'k','linewidth',2)
% plot(zscore(diff(score(:,1))))
% plot(zscore(score(:,2)),'g')

% figure
% hold on
% plot([1 size(norm_mat,2)],[0 0],'k','linewidth',2)
% plot(zscore(diff(score(:,2))))
% plot(-zscore(score(:,3)),'g')




















