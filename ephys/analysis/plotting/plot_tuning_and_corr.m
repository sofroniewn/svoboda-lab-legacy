gap = [0.08 0.06];
marg_h = [0.07 0.02];
marg_w = [0.03 0.02];

figure(141);
clf(141)
set(gcf,'Position',[198   360   4/3*717   2*223])
subtightplot(2,4,1,gap,marg_h,marg_w);
keep_name = 'not_running';%'running_no_wall';
SPK_CORR = get_full_trial_spk_corr(clust_id1,clust_id2,spike_times_cluster,d,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
plot_spk_corr([],SPK_CORR{1,1});
keep_name = 'running';
text(0.02,.07,sprintf('no running'),'Units','Normalized','FontSize',12,'Color',[0 0 0],'Background','w')

subtightplot(2,4,5,gap,marg_h,marg_w);
SPK_CORR = get_full_trial_spk_corr(clust_id1,clust_id2,spike_times_cluster,d,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
plot_spk_corr([],SPK_CORR{1,1});
text(0.02,.1,sprintf('+ blue -> black\n- black -> blue'),'Units','Normalized','FontSize',12,'Color',[0 0 0],'Background','w')


subtightplot(2,4,3,gap,marg_h,marg_w);
tuning_curve = get_tuning_curve_ephys(clust_id1,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
curve1 = tuning_curve.model_fit.curve;
plot_tuning_curve_ephys([],tuning_curve)
text(.81,.95,sprintf('Id %d',clust_id1),'Units','Normalized','FontSize',18,'Color',[0 0 0],'Background','w')
subtightplot(2,4,4,gap,marg_h,marg_w);
tuning_curve = get_tuning_curve_ephys(clust_id2,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
curve2 = tuning_curve.model_fit.curve;
plot_tuning_curve_ephys([],tuning_curve)
text(.81,.95,sprintf('Id %d',clust_id2),'Units','Normalized','FontSize',18,'Color',[0 0 .6],'Background','w')
subtightplot(2,4,2,gap,marg_h,marg_w);
hold on
plot(zscore(curve1),zscore(curve2),'Color',[0 0 .6],'LineWidth',2)
%plot(x_fit_vals,zscore(curve1),'Color',[0 0 0],'LineWidth',2)
%plot(x_fit_vals,zscore(curve2),'Color',[0 0 .6],'LineWidth',2)
%xlim([tuning_curve.regressor_obj.x_range])
%xlabel(tuning_curve.regressor_obj.x_label)
%ylabel('z-score firing rate')
%set(gca,'xtick',tuning_curve.regressor_obj.x_tick)

subtightplot(2,4,7,gap,marg_h,marg_w);
WAVEFORMS = d.summarized_cluster{clust_id1}.WAVEFORMS;
plot_spk_waveforms([],WAVEFORMS,0,[0 0 0]);
ylim([-150 50])
subtightplot(2,4,8,gap,marg_h,marg_w);
WAVEFORMS = d.summarized_cluster{clust_id2}.WAVEFORMS;
plot_spk_waveforms([],WAVEFORMS,0,[0 0 .6]);
ylim([-150 50])

subtightplot(2,4,6,gap,marg_h,marg_w);
hold on
layer_4_dist_vals = (layer_4 - [1:1/10:32])*20;
AMPLITUDES = spike_times_cluster{clust_id1}.interp_amp;
max1 = max(AMPLITUDES/10)*10;
plot(AMPLITUDES, layer_4_dist_vals,'Color',[0 0 0],'LineWidth',2);
AMPLITUDES = spike_times_cluster{clust_id2}.interp_amp;
max2 = max(AMPLITUDES/10)*10;
plot(AMPLITUDES, layer_4_dist_vals,'Color',[0 0 .6],'LineWidth',2);
ylabel('Layer 4 distance (um)')
set(gca,'ydir','rev')
xlim([0 max(max1,max2)])
text(.52,.94,sprintf('ANM %d',d.p_nj(1,1)),'Units','Normalized','FontSize',14,'Color',[1 0 0],'Background','w')


