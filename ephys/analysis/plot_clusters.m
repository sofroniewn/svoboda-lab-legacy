function plot_clusters(all_anm,order,full)

for ij = 1:size(order,1)
    anm_num = order(ij,1);
    clust_num = order(ij,2);
    d = all_anm{anm_num}.d;

    s_ind = find(strcmp(d.p_labels,'clust_id'));
    clust_id = d.p_nj(clust_num,s_ind);

    s_ind = find(strcmp(d.p_labels,'anm_id'));
    anm_id = d.p_nj(clust_num,s_ind);

        figure(110+ij)
        clf(110+ij)
        fig_props = [];
        if full
        set(gcf,'Position',[10 560 1400 480])
        gap = [0.0355 0.0355];
        marg_h = [0.08 0.03];
        marg_w = [0.03 0.01];
        num_plots_h = 4;
        num_plots_w = 8;
        else
        set(gcf,'Position',[10 560 1400 240])
        gap = 0.0355;
        marg_h = [0.14 0.03];
        marg_w = [0.03 0.01];
        num_plots_h = 2;
        num_plots_w = 8;
        end
    
    % get depth information
    s_ind = find(strcmp(d.p_labels,'chan_depth'));
	peak_channel = d.p_nj(clust_num,s_ind);

    s_ind = find(strcmp(d.p_labels,'num_spikes'));
    num_spikes = d.p_nj(clust_num,s_ind);

    s_ind = find(strcmp(d.p_labels,'layer_4_dist'));
    layer_4_dist = d.p_nj(clust_num,s_ind);

    s_ind = find(strcmp(d.p_labels,'spike_tau'));
    spike_tau = d.p_nj(clust_num,s_ind);


	% get isi information
    ISI = d.summarized_cluster{clust_num}.ISI;
        subtightplot(num_plots_h,num_plots_w,[1 9],gap,marg_h,marg_w)
        plot_isi(fig_props,ISI);
        text(.04,.80,sprintf('Id %d',clust_id),'Units','Normalized','Color','r','FontWeight','Bold','Background','w')
        text(.04,.66,sprintf('Chan %.1f',peak_channel),'Units','Normalized','Color','r','Background','w')
        text(.04,.87,sprintf('ANM %.0f',anm_id),'Units','Normalized','Color','r','Background','w')
        text(.04,.96,sprintf('%.0f um',layer_4_dist),'Units','Normalized','FontSize',18,'Color','r','Background','w')
                if spike_tau <= 350
                    text(.04,.73,sprintf('Fast spiking'),'Units','Normalized','Color','r','Background','w')
                elseif spike_tau > 500
                    text(.04,.73,sprintf('Regular spiking'),'Units','Normalized','Color','r','Background','w')
                else
                    text(.04,.73,sprintf('Intermediate spiking'),'Units','Normalized','Color','r','Background','w')
                end
    xlabel('');

    % get spike waveform information
    WAVEFORMS = d.summarized_cluster{clust_num}.WAVEFORMS;
        subtightplot(num_plots_h,num_plots_w,[2 10],gap,marg_h,marg_w)
        plot_spk_waveforms(fig_props,WAVEFORMS);
    


    % Make stability plot
    AMPLITUDES = d.summarized_cluster{clust_num}.AMPLITUDES;
        subtightplot(num_plots_h,num_plots_w,[3 4],gap,marg_h,marg_w)
        plot_stability(fig_props,AMPLITUDES)
        set(gca,'xticklabel',[])
        xlabel('')
    
    BEHAVIOUR_VECT = d.summarized_cluster{clust_num}.BEHAVIOUR_VECT;
        subtightplot(num_plots_h,num_plots_w,[11 12],gap,marg_h,marg_w)
        plot_behaviour_vect(fig_props,BEHAVIOUR_VECT)

    
    tuning_curve = d.summarized_cluster{clust_num}.RUNNING_MOD;
    s_ind = find(strcmp(d.p_labels,'baseline_rate'));
    baseline_rate = d.p_nj(clust_num,s_ind);
    s_ind = find(strcmp(d.p_labels,'running_modulation'));
    running_modulation = d.p_nj(clust_num,s_ind);
    subtightplot(num_plots_h,num_plots_w,[5 13],gap,marg_h,marg_w)
    plot_tuning_curve_ephys(fig_props,tuning_curve)
        text(.05,.96,sprintf('Baseline %.2f Hz',baseline_rate),'Units','Normalized','Color','r','Background','w')
        text(.05,.89,sprintf('Modulation %.2fx',running_modulation),'Units','Normalized','Color','r','Background','w')
   
    % Make trial Raster to running and contra touch
    RASTER = d.summarized_cluster{clust_num}.RUNNING_RASTER;
        subtightplot(num_plots_h,num_plots_w,[6 7],gap,marg_h,marg_w)
        plot_spk_raster(fig_props,RASTER)
        set(gca,'xticklabel',[])
        xlabel('')
        subtightplot(num_plots_h,num_plots_w,[14 15],gap,marg_h,marg_w)
        plot_spk_psth(fig_props,RASTER);
        text(.02,.93,sprintf('%s','olR run'),'Units','Normalized','Color','r','Background','w')
   
    % Make touch tuning    
    tuning_curve = d.summarized_cluster{clust_num}.TOUCH_TUNING;
    s_ind = find(strcmp(d.p_labels,'peak_rate'));
	peak_rate = d.p_nj(clust_num,s_ind);
    s_ind = find(strcmp(d.p_labels,'peak_distance'));
	peak_dist = d.p_nj(clust_num,s_ind);
    subtightplot(num_plots_h,num_plots_w,[8 16],gap,marg_h,marg_w)
    plot_tuning_curve_ephys(fig_props,tuning_curve)
    text(.05,.95,sprintf('Peak rate %.2f Hz',peak_rate),'Units','Normalized','Color','r','Background','w')
    text(.05,.89,sprintf('Peak distance %.1f mm',peak_dist),'Units','Normalized','Color','r','Background','w')


    tune_curve = d.summarized_cluster{clust_num}.TOUCH_TUNING.model_fit.curve;
    x_vals = d.summarized_cluster{clust_num}.TOUCH_TUNING.regressor_obj.x_fit_vals;
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
    text(.05,.80,sprintf('Type %.1f',log(tmp)),'Units','Normalized','Color','r','Background','w')


   if full
    % Make trial Raster to not running and contra touch
    RASTER = d.summarized_cluster{clust_num}.NO_RUNNING_RASTER;
    subtightplot(num_plots_h,num_plots_w,16+[6 7],gap,marg_h,marg_w)
        plot_spk_raster(fig_props,RASTER)
        set(gca,'xticklabel',[])
        xlabel('')
        subtightplot(num_plots_h,num_plots_w,16+[14 15],gap,marg_h,marg_w)
        plot_spk_psth(fig_props,RASTER);
        text(.02,.93,sprintf('%s','olR no run'),'Units','Normalized','Color','r','Background','w')
    
    % Make touch tuning when not running
    
    tuning_curve = d.summarized_cluster{clust_num}.NO_RUNNING_TOUCH_TUNING;
        subtightplot(num_plots_h,num_plots_w,[24 32],gap,marg_h,marg_w)
        plot_tuning_curve_ephys(fig_props,tuning_curve)
    
    % Make touch tuning when wall moving
    tuning_curve = d.summarized_cluster{clust_num}.WALL_DIRECTION_TUNING;
        subtightplot(num_plots_h,num_plots_w,[17 25],gap,marg_h,marg_w)
        plot_tuning_curve_multi_ephys(fig_props,tuning_curve)
   
    % Make touch tuning when running left/right
    tuning_curve = d.summarized_cluster{clust_num}.RUN_DIRECTION_TUNING;
        subtightplot(num_plots_h,num_plots_w,[20 28],gap,marg_h,marg_w)
        plot_tuning_curve_multi_ephys(fig_props,tuning_curve)
    
    % Make touch tuning when running slow / fast
    tuning_curve = d.summarized_cluster{clust_num}.RUN_SPEED_TUNING;
        subtightplot(num_plots_h,num_plots_w,[19 27],gap,marg_h,marg_w)
        plot_tuning_curve_multi_ephys(fig_props,tuning_curve)
    end

end