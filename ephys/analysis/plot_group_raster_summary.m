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
tuning_curve.title = 'Corridor position tuning curve';
tuning_curve.x_label = 'Wall distance (mm)';
tuning_curve.y_label  = 'Firing rate (Hz)';

fit_model_on = 1;
if fit_model_on
    full_x = [];
    full_y = [];
	for ij = 1:length(tuning_curve.x_vals)
		full_x = [full_x;repmat(tuning_curve.x_vals(ij),length(tuning_curve.data{ij}),1)];
		full_y = [full_y;tuning_curve.data{ij}];
	end

	
	baseline = prctile(tuning_curve.means,10);
	weight = tuning_curve.means - baseline;
	mod_depth = max(weight);
    %weight = abs(weight);
	weight = weight/sum(weight);
   	tuned_val = sum(weight.*tuning_curve.x_vals);
    tuning_curve.x_fit_vals = [0:.1:30];
	
	p = .01;
	tuning_curve.model_fit.curve = csaps(full_x,full_y,p,tuning_curve.x_fit_vals);
	
	%tuning_curve.model_fit.curve = spline(tuning_curve.x_vals,tuning_curve.means,tuning_curve.x_fit_vals);
	[pks loc] = max(tuning_curve.model_fit.curve);
	tuning_curve.model_fit.estPrs = tuning_curve.x_fit_vals(loc);
	tuning_curve.model_fit.r2 = 0;

	%initPrs = [tuned_val, 1, mod_depth, baseline];
	%tuning_curve.model_fit = fitGauss(full_x,full_y,initPrs);
	%tuning_curve.model_fit.curve = fitGauss_modelFun(tuning_curve.x_fit_vals,tuning_curve.model_fit.estPrs);
end




plot_tuning_curves(123,tuning_curve,[0 0 1]);
set(gcf,'Position',[575    66   560   410])


time_range_isi = [.8 1.3];
%time_range_isi = [0 4];

groups_isi = groups;
groups_isi(groups_isi == 1) = 0;
groups_isi(groups_isi > 13) = 0;
groups_isi(ismember(groups_isi,[2:4])) = 1;
groups_isi(ismember(groups_isi,[5:10])) = 2;
groups_isi(ismember(groups_isi,[11:13])) = 3;
group_ids_isi = [1:3];
group_scale = [1 .5 1];

%plot_spike_isi_groups(1000*(dir_num-1)+11+8,11,sorted_spikes,keep_trials,groups_isi,group_ids_isi,col_mat,time_range_isi,mean_ds,group_scale);

%plot_spike_pair_corr_groups(1000*(dir_num-1)+21+8,11,17,sorted_spikes,keep_trials,groups_isi,group_ids_isi,col_mat,time_range_isi,mean_ds,group_scale);



% all_sensory_curves = zeros(length(group_ids),2001);
% all_psth_curves = zeros(length(group_ids),2001);
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
% 
% figure(329);
% clf(329)
% set(gcf,'Position',[573   549   560   257])
% colormap('jet')
% h_ax = imagesc([0 4],[0 1],flipud(all_psth_curves));
% set(gca,'ytick',[])
% set(gca,'xtick',[0:.5:4])
% 
% figure(325);
% clf(325)
% set(gcf,'Position',[891   549   560   257])
% 
% hold on
% for ij = 1:length(group_ids)
% 	plot(all_sensory_curves(ij,1:501),all_psth_curves(ij,1:501),'color',col_mat(ij,:));
% end
% edges = [0:.1:30];
% all_dat = NaN(length(group_ids),length(edges));
% for ij = 1:length(group_ids)
% 	subs = 1+ceil(10*all_sensory_curves(ij,1:501));
% 	vals = all_psth_curves(ij,1:501);
% 	all_dat(ij,:) = accumarray(subs',vals',[],@mean,NaN);
% 	%plot(edges,all_dat(ij,:),'color',col_mat(ij,:));
% end
% plot(edges,nanmean(all_dat),'color','k','LineWidth',2);
% xlim([0 30])