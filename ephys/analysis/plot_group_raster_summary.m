function plot_group_raster_summary(clust_id,dir_num,sorted_spikes,session,trial_range,time_range)

group_ids = find(~session.trial_config.processed_dat.vals.trial_type);
%group_ids(end-2:end) = [];
groups = session.trial_info.inds;
col_mat = zeros(length(group_ids),3);
col_mat(:,3) = 1-linspace(0,1,length(group_ids));
%col_mat(1:2:end,1) = linspace(0,1,length(group_ids)/2);
%time_range = [2.5 3.5];
mean_ds = 1;
keep_trials = find(session.trial_info.mean_speed > 5);
keep_trials = keep_trials(ismember(keep_trials,trial_range));
[tuning_curve time_vec psth_all] = plot_spike_raster_groups(1000*(dir_num-1)+11,clust_id,sorted_spikes,keep_trials,groups,group_ids,col_mat,time_range,mean_ds);
xlim([0 4])

tuning_curve.x_vals = session.trial_config.processed_dat.vals.trial_ol_vals(group_ids,2);
tuning_curve.x_range = [-.5 30.5];
tuning_curve.model_fit = [];
tuning_curve.title = 'Corridor position tuning curve'
tuning_curve.x_label = 'Wall distance (mm)'
tuning_curve.y_label  = 'Firing rate (Hz)'
plot_tuning_curves(123,tuning_curve,[0 0 1])
set(gcf,'Position',[575    66   560   410])


all_sensory_curves = zeros(length(group_ids),2001);
all_psth_curves = zeros(length(group_ids),2001);
time_comb = session.data{1}.processed_matrix(1,501:end);

figure(323);
clf(323)
set(gcf,'Position',[13   549   560   257])

hold on
for ij = 1:length(group_ids)
	trial_id = find(groups == group_ids(ij),1,'first');
	plot(session.data{trial_id}.processed_matrix(1,:),session.data{trial_id}.trial_matrix(3,:),'color',col_mat(ij,:),'LineWidth',3)
end
xlim([0 4])


%figure(324);
%clf(324)
%hold on
for ij = 1:length(group_ids)
	trial_id = find(groups == group_ids(ij),1,'first');
	all_sensory_curves(ij,:) = session.data{trial_id}.trial_matrix(3,501:end);
	%plot(time_comb,all_sensory_curves(ij,:),'color',col_mat(ij,:),'LineWidth',3)
	all_psth_curves(ij,:) = interp1(time_vec,psth_all(ij,:),time_comb);
	%plot(time_comb,all_psth_curves(ij,:)/100,'color',col_mat(ij,:));
end
%xlim([0 4])

figure(325);
clf(325)
set(gcf,'Position',[573   549   560   257])

hold on
for ij = 1:length(group_ids)
	plot(all_sensory_curves(ij,1:501),all_psth_curves(ij,1:501),'color',col_mat(ij,:));
end
edges = [0:.1:30];
all_dat = NaN(length(group_ids),length(edges));
for ij = 1:length(group_ids)
	subs = 1+ceil(10*all_sensory_curves(ij,1:501));
	vals = all_psth_curves(ij,1:501);
	all_dat(ij,:) = accumarray(subs',vals',[],@mean,NaN);
	%plot(edges,all_dat(ij,:),'color',col_mat(ij,:));
end
plot(edges,nanmean(all_dat),'color','k','LineWidth',2);
xlim([0 30])