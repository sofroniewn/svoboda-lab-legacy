function plot_clusters_tuning_only(all_anm,ps,order,full)

boundary_labels = {'Pia', 'L1', 'L2/3', 'L4', 'L5A', 'L5B', 'L6'};
barrel_inds = {'C1','C2','C3','C4','D1','D2','B1','V1'};


for ij = 1:size(order,1)
    anm_num = order(ij,1);
    anm_index = find(ismember(all_anm.names,num2str(anm_num)));
    clust_num = order(ij,2);
    d = all_anm.data{anm_index}.d;
    
    s_ind = find(strcmp(d.p_labels,'clust_id'));
    clust_id = d.p_nj(clust_num,s_ind);
    
    s_ind = find(strcmp(d.p_labels,'anm_id'));
    anm_id = d.p_nj(clust_num,s_ind);
    
    figure(120+ij)
    clf(120+ij)
    fig_props = [];
    set(gcf,'Color',[1 1 1])

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
    
    tot_ind = order(ij,3);
    layer_id = ps.layer_id(tot_ind)+1;
    layer_str = boundary_labels{layer_id};
    text(.04,.55,sprintf('%s',layer_str),'Units','Normalized','FontSize',18,'Color','r','Background','w')
    

    barrel_id = ps.barrel_loc(tot_ind);
    barrel_str = barrel_inds{barrel_id};
    text(.04,.45,sprintf('%s',barrel_str),'Units','Normalized','FontSize',18,'Color','r','Background','w')
    
    text(.04,.35,sprintf('AP %.2f',ps.AP(tot_ind)),'Units','Normalized','Color','r','Background','w')
    text(.04,.28,sprintf('ML %.2f',ps.ML(tot_ind)),'Units','Normalized','Color','r','Background','w')
    

    clean_ind = ps.clean_clusters(tot_ind);
    if clean_ind
        text(.725,.82,sprintf('CLEAN'),'Units','Normalized','Color','r','Background','w')
     else
        text(.725,.82,sprintf('NOT CLEAN'),'Units','Normalized','Color','r','Background','w')
    end

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
    plot_spk_waveforms(fig_props,WAVEFORMS,1,[0 0 0]);
    
    
    
    % Make stability plot
    AMPLITUDES = d.summarized_cluster{clust_num}.AMPLITUDES;
    subtightplot(num_plots_h,num_plots_w,[3 4],gap,marg_h,marg_w)
    plot_stability(fig_props,AMPLITUDES)
    set(gca,'xticklabel',[])
    xlabel('')
    text(.02,.91,sprintf('Stable %.2f',ps.stab_fr(tot_ind)),'Units','Normalized','Color','r','Background','w')
    text(.02,.75,sprintf('AMP %.2f',ps.stab_amp(tot_ind)),'Units','Normalized','Color','r','Background','w')

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
    
    [raster_mat raster_mat_full raster_mat_rescale_full raster_col_mat rescale_time] = get_raster_col_mat(d);

    %plot_spk_raster(fig_props,RASTER,[],[],[])
    plot_spk_raster_col([],RASTER,[],[],raster_mat_full);
    set(gca,'xticklabel',[])
    xlabel('')
    subtightplot(num_plots_h,num_plots_w,[14 15],gap,marg_h,marg_w)
    plot_spk_psth(fig_props,RASTER);
    text(.02,.93,sprintf('%s','olR run'),'Units','Normalized','Color','r','Background','w')
   
    text(.73,.9,sprintf('ON  ADAPT %.2f',ps.on_adapt(tot_ind)),'Units','Normalized','Color','r','Background','w')
    text(.73,.73,sprintf('OFF ADAPT %.2f',ps.off_adapt(tot_ind)),'Units','Normalized','Color','r','Background','w')
 
    % Make touch tuning
    tuning_curve = d.summarized_cluster{clust_num}.TOUCH_TUNING;
    
    full_x = [];
    full_y = [];
    for ij = 1:length(tuning_curve.regressor_obj.x_vals)
        full_x = [full_x;repmat(tuning_curve.regressor_obj.x_vals(ij),length(tuning_curve.data{ij}),1)];
        full_y = [full_y;tuning_curve.data{ij}];
    end
    
    
    p = 10^-5;
    tuning_curve.model_fit.curve = csaps(full_x,full_y,p,tuning_curve.regressor_obj.x_fit_vals);
    [pks loc] = max(tuning_curve.model_fit.curve);
    tuning_curve.model_fit.estPrs = tuning_curve.regressor_obj.x_fit_vals(loc);
    tuning_curve.model_fit.r2 = 0;
    if tuning_curve.num_pts(1) == 0;
        ind = find(tuning_curve.num_pts>0,1,'first');
        val = tuning_curve.regressor_obj.x_vals(ind-1);
        ind = find(tuning_curve.regressor_obj.x_fit_vals<=val,1,'last');
        tuning_curve.model_fit.curve(1:ind) = tuning_curve.model_fit.curve(ind+1);
    end
    if tuning_curve.num_pts(end) == 0;
        ind = find(tuning_curve.num_pts>0,1,'last');
        val = tuning_curve.regressor_obj.x_vals(ind+1);
        ind = find(tuning_curve.regressor_obj.x_fit_vals<=val,1,'last');
        tuning_curve.model_fit.curve(ind+1:end) = tuning_curve.model_fit.curve(ind);
    end
    
    baseline = mean(tuning_curve.model_fit.curve(50:end));
    [pks loc] = max(tuning_curve.model_fit.curve);
    [pksm locm] = min(tuning_curve.model_fit.curve);
    
    %[pks loc] = findpeaks(tuning_curve.model_fit.curve);
    %[pksm locm] = findpeaks(-tuning_curve.model_fit.curve);
    % figure(22)
    % clf(22)
    % plot_tuning_curve_ephys([],tuning_curve)
    
    % baseline = prctile(tuning_curve.means,10);
    % weight = tuning_curve.means - baseline;
    % mod_depth = max(weight);
    % %weight = abs(weight);
    % weight = weight/sum(weight);
    % tuned_val = sum(weight.*tuning_curve.regressor_obj.x_vals);
    
    %         initPrs = [tuned_val, 1, mod_depth, tuned_val, 1, 0 baseline];
    %         tuning_curve.model_fit = fitDoubleGauss(full_x,full_y,initPrs);
    %         tuning_curve.model_fit.curve = fitDoubleGauss_modelFun(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit.estPrs);
    
    
    
    subtightplot(num_plots_h,num_plots_w,[8 16],gap,marg_h,marg_w)
    s_ind = find(strcmp(d.p_labels,'peak_rate'));
    peak_rate = d.p_nj(clust_num,s_ind);
    s_ind = find(strcmp(d.p_labels,'peak_distance'));
    peak_dist = d.p_nj(clust_num,s_ind);
%    plot_tuning_curve_ephys(fig_props,tuning_curve)
    plot_tuning_curve_ephys_col(fig_props,tuning_curve)

    text(.05,.95,sprintf('Peak rate %.2f Hz',peak_rate),'Units','Normalized','Color','r','Background','w')
    text(.05,.89,sprintf('Peak distance %.1f mm',peak_dist),'Units','Normalized','Color','r','Background','w')
    
   % plot([0 30],[baseline baseline],'r','linewidth',3)
   % plot(tuning_curve.regressor_obj.x_fit_vals(loc),tuning_curve.model_fit.curve(loc),'.g','MarkerSize',30)
   % plot(tuning_curve.regressor_obj.x_fit_vals(locm),tuning_curve.model_fit.curve(locm),'.r','MarkerSize',30)
    
    tmp = (pks-baseline);
    tmpm = (baseline-pksm);
    % ind_tmp = ind;
    % if 1/tmpm > tmp
    %   tmp = tmpm;
    %   ind_tmp = indm;
    % end
    text(.05,.80,sprintf('On  %.2f',tmp),'Units','Normalized','Color','r','Background','w')
    text(.05,.73,sprintf('Off %.2f',tmpm),'Units','Normalized','Color','r','Background','w')
    
    %    text(.05,.64,sprintf('SNR %.1f',extra_var(order(ij,3))),'Units','Normalized','Color','r','Background','w')
    
    
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

%c_map = cbrewer('seq','Blues',64);
%c_map = cbrewer('seq','PuBu',64);
%c_map = jet(64);
%96c6fd
c_map = zeros(64,3);
%c_map(:,1) = linspace(253,144,64)/256;
%c_map(:,2) = linspace(174,185,64)/256;
%c_map(:,3) = linspace(107,247,64)/256;
c_map(1:20,1) = linspace(253,(253+144)/2,20)/256;
c_map(1:20,2) = linspace(174,(174+185)/2,20)/256;
c_map(1:20,3) = linspace(107,(107+247)/2,20)/256;
c_map(21:64,1) = linspace((253+144)/2,144,44)/256;
c_map(21:64,2) = linspace((174+185)/2,185,44)/256;
c_map(21:64,3) = linspace((107+247)/2,247,44)/256;

%c_map(:,2) = 1;
set(gcf,'colormap',c_map)

end