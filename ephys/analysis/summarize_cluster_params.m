function d = summarize_cluster_params(d,ephys_summary,all_clust_ids,sorted_spikes,session,exp_type,trial_range_start,trial_range_end,layer_4,run_thresh,plot_on)


trial_range_full = [min(trial_range_start):min(max(trial_range_end),numel(session.data))];

ephys_sampling_rate = 20833.33;
num_chan = 32;


trial_inds = session.trial_info.inds;
id_type_base = 'base';
[group_ids groups] = define_group_ids(exp_type,id_type_base,trial_inds);

max_length_trial = 2001;
if isempty(d)
    d = convert_rsu_format(sorted_spikes,session,trial_range_full,group_ids,groups,max_length_trial);
end

d.p_labels = {'anm_id';'clust_id';'chan_depth';'layer_4_dist';'num_spikes';'isi_peak';'isi_violations';'waveform_SNR';'spk_amplitude';'spike_tau';'spike_tau1';'spike_tau2';'baseline_rate';'running_modulation';'peak_rate';'peak_distance'};

d.p_nj = NaN(length(all_clust_ids),numel(d.p_labels));
d.summarized_cluster = cell(length(all_clust_ids),1);

for ij = 1:length(all_clust_ids)
    
    if plot_on
        figure(110+ij)
        clf(110+ij)
        set(gcf,'Position',[10 560 1400 480])
        fig_props = [];
        gap = [0.0355 0.0355];
        marg_h = [0.08 0.03];
        marg_w = [0.03 0.01];
    end
    
    s_ind = find(strcmp(d.p_labels,'anm_id'));
    d.p_nj(ij,s_ind) = str2num(session.basic_info.anm_str(5:end));
    
    
    % get cluster id information
    clust_id = all_clust_ids(ij);
    
    
    trial_range = [trial_range_start(clust_id):min(trial_range_end(clust_id),numel(session.data))];
    
    %fprintf('Cluster id %d\n',clust_id);
    s_ind = find(strcmp(d.p_labels,'clust_id'));
    d.p_nj(ij,s_ind) = clust_id;
    
    spike_times = sorted_spikes{clust_id}.session_time/ephys_sampling_rate;
    mean_spike_amp = sorted_spikes{clust_id}.mean_spike_amp(1:num_chan);
    spike_wave_detect = sorted_spikes{clust_id}.spike_waves;
    spike_trials = sorted_spikes{clust_id}.trial_num;
    spike_amps = sorted_spikes{clust_id}.spike_amp;
    trial_times = session.trial_info.time(min(trial_range):max(trial_range))';
    spike_times_ephys = sorted_spikes{clust_id}.ephys_time;
    
    spike_times(~ismember(spike_trials,trial_range)) = [];
    spike_amps(~ismember(spike_trials,trial_range)) = [];
    spike_times_ephys(~ismember(spike_trials,trial_range)) = [];
    spike_wave_detect(~ismember(spike_trials,trial_range),:) = [];
    spike_trials(~ismember(spike_trials,trial_range)) = [];
    
    
    d.summarized_cluster{ij}.spike_times = spike_times;
    d.summarized_cluster{ij}.spike_times_ephys = spike_times_ephys;
    d.summarized_cluster{ij}.spike_trials = spike_trials;
    
    [peak_channel interp_amp] = get_peak_channel(mean_spike_amp,[]);
    d.summarized_cluster{ij}.mean_spike_amp = mean_spike_amp;
    d.summarized_cluster{ij}.interp_amp = interp_amp;
    d.summarized_cluster{ij}.peak_channel = peak_channel;
    
    % get depth information
    s_ind = find(strcmp(d.p_labels,'chan_depth'));
    d.p_nj(ij,s_ind) = peak_channel;
    
    s_ind = find(strcmp(d.p_labels,'layer_4_dist'));
    d.p_nj(ij,s_ind) = (layer_4 - peak_channel)*20;
    
    s_ind = find(strcmp(d.p_labels,'num_spikes'));
    d.p_nj(ij,s_ind) = length(spike_amps);
    
    
    % get isi information
    ISI = get_isi(spike_times,[]);
    s_ind = find(strcmp(d.p_labels,'isi_peak'));
    d.p_nj(ij,s_ind) = ISI.peak(1);
    s_ind = find(strcmp(d.p_labels,'isi_violations'));
    d.p_nj(ij,s_ind) = ISI.violations;
    d.summarized_cluster{ij}.ISI = ISI;
    
    if plot_on
        subtightplot(4,8,[1 9],gap,marg_h,marg_w)
        plot_isi(fig_props,ISI);
        text(.04,.96,sprintf('Id %d',clust_id),'Units','Normalized','FontSize',18,'Color','r','FontWeight','Bold')
        text(.04,.87,sprintf('Chan %.1f',peak_channel),'Units','Normalized','Color','r')
        if ~isempty(ephys_summary)
            text(.725,.80,sprintf('ANM %.0f',ephys_summary.d(1,1)),'Units','Normalized','Color','r')
            ind = find(ephys_summary.d(:,2) == clust_id,1,'first');
            if ~isempty(ind)
                text(.04,.80,sprintf('Depth %.0f um',ephys_summary.d(ind,3)),'Units','Normalized','Color','r')
                if ephys_summary.d(ind,4)
                    text(.04,.73,sprintf('Fast spiking'),'Units','Normalized','Color','r')
                else
                    text(.04,.73,sprintf('Regular spiking'),'Units','Normalized','Color','r')
                end
            else
                text(.04,.80,sprintf('Rejected'),'Units','Normalized','Color','r')
            end
            if ~isempty(ephys_summary.layer_4)
                %s_ind = find(strcmp(d.p_labels,'layer_4_dist'));
                %layer_4_dist =  -20*(peak_channel-ephys_summary.layer_4);
                %d.p_nj(ij,s_ind) = layer_4_dist;
                text(.04,.66,sprintf('L4 %.0f um',layer_4_dist),'Units','Normalized','Color','r')
            end
        end
        xlabel('');
    end
    
    
    
    % get spike waveform information
    WAVEFORMS = get_spk_waveforms(spike_wave_detect,ephys_sampling_rate);
    s_ind = find(strcmp(d.p_labels,'spk_amplitude'));
    d.p_nj(ij,s_ind) = -WAVEFORMS.amp;
    s_ind = find(strcmp(d.p_labels,'spike_tau'));
    d.p_nj(ij,s_ind) = 1000*WAVEFORMS.tau_4;
    s_ind = find(strcmp(d.p_labels,'waveform_SNR'));
    d.p_nj(ij,s_ind) = WAVEFORMS.SNR;
    s_ind = find(strcmp(d.p_labels,'spike_tau1'));
    d.p_nj(ij,s_ind) = 1000*WAVEFORMS.tau_1;
    s_ind = find(strcmp(d.p_labels,'spike_tau2'));
    d.p_nj(ij,s_ind) = 1000*WAVEFORMS.tau_2;
    d.summarized_cluster{ij}.WAVEFORMS = WAVEFORMS;
    if plot_on
        subtightplot(4,8,[2 10],gap,marg_h,marg_w)
        plot_spk_waveforms(fig_props,WAVEFORMS);
    end
    
    
    
    % Make stability plot
    AMPLITUDES = get_spk_amplitude(spike_amps,spike_trials,trial_times,trial_range);
    d.summarized_cluster{ij}.AMPLITUDES = AMPLITUDES;
    if plot_on
        subtightplot(4,8,[3 4],gap,marg_h,marg_w)
        plot_stability(fig_props,AMPLITUDES)
        set(gca,'xticklabel',[])
        xlabel('')
    end
    BEHAVIOUR_VECT = get_behaviour_vect(session,'speed',trial_range);
    d.summarized_cluster{ij}.BEHAVIOUR_VECT = BEHAVIOUR_VECT;
    if plot_on
        subtightplot(4,8,[11 12],gap,marg_h,marg_w)
        plot_behaviour_vect(fig_props,BEHAVIOUR_VECT)
    end
    
    time_range = [0 4];
    % Make running tuning
    stim_name = 'running';
    keep_name = 'base';
    id_type_speed_tuning = 'outOfReach';
    tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type_speed_tuning,time_range,trial_range,run_thresh);
    running_modulation = tuning_curve.means(2)/tuning_curve.means(1);
    baseline_rate = tuning_curve.means(1);
    s_ind = find(strcmp(d.p_labels,'baseline_rate'));
    d.p_nj(ij,s_ind) = baseline_rate;
    s_ind = find(strcmp(d.p_labels,'running_modulation'));
    d.p_nj(ij,s_ind) = running_modulation;
    d.summarized_cluster{ij}.RUNNING_MOD = tuning_curve;
    if plot_on
        subtightplot(4,8,[5 13],gap,marg_h,marg_w)
        plot_tuning_curve_ephys(fig_props,tuning_curve)
        text(.05,.96,sprintf('Baseline %.2f Hz',baseline_rate),'Units','Normalized','Color','r')
        text(.05,.89,sprintf('Modulation %.2fx',running_modulation),'Units','Normalized','Color','r')
    end
    
    % Make trial Raster to running and contra touch
    id_type_wall_tuning = 'olR';
    keep_name = 'running';
    [group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type_wall_tuning,trial_inds);
    keep_trials = trial_range;
    keep_trials = keep_trials(ismember(keep_trials,find(session.trial_info.mean_speed > run_thresh & ismember(groups_RASTER,group_ids_RASTER))));
    mean_ds = 2;
    temp_smooth = 80;
    RASTER = get_spk_raster(spike_times_ephys,spike_trials,keep_trials,groups_RASTER,group_ids_RASTER,time_range,mean_ds,temp_smooth);
    d.summarized_cluster{ij}.RUNNING_RASTER = RASTER;
    if plot_on
        subtightplot(4,8,[6 7],gap,marg_h,marg_w)
        plot_spk_raster(fig_props,RASTER)
        set(gca,'xticklabel',[])
        xlabel('')
        subtightplot(4,8,[14 15],gap,marg_h,marg_w)
        plot_spk_psth(fig_props,RASTER);
        text(.02,.93,sprintf('%s',id_type_wall_tuning),'Units','Normalized','Color','r')
    end
    
    % Make touch tuning
    stim_name = 'corPos';
    keep_name = 'running';
    id_type_wall_tuning = 'olR';
    tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type_wall_tuning,time_range,trial_range,run_thresh);
    [peak_rate loc] = max(tuning_curve.model_fit.curve);
    peak_dist = tuning_curve.regressor_obj.x_fit_vals(loc);
    s_ind = find(strcmp(d.p_labels,'peak_rate'));
    d.p_nj(ij,s_ind) = peak_rate;
    s_ind = find(strcmp(d.p_labels,'peak_distance'));
    d.p_nj(ij,s_ind) = peak_dist;
    d.summarized_cluster{ij}.TOUCH_TUNING = tuning_curve;
    if plot_on
        subtightplot(4,8,[8 16],gap,marg_h,marg_w)
        plot_tuning_curve_ephys(fig_props,tuning_curve)
        text(.05,.95,sprintf('Peak rate %.2f Hz',peak_rate),'Units','Normalized','Color','r')
        text(.05,.89,sprintf('Peak distance %.1f mm',peak_dist),'Units','Normalized','Color','r')
    end
    
    % Make trial Raster to not running and contra touch
    id_type_wall_tuning = 'olR';
    stim_name = 'corPos';
    keep_name = 'not_running';
    [group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type_wall_tuning,trial_inds);
    keep_trials = trial_range;
    keep_trials = keep_trials(ismember(keep_trials,find(session.trial_info.mean_speed <= run_thresh & ismember(groups_RASTER,group_ids_RASTER))));
    time_range = [0 4];
    mean_ds = 2;
    temp_smooth = 80;
    RASTER = get_spk_raster(spike_times_ephys,spike_trials,keep_trials,groups_RASTER,group_ids_RASTER,time_range,mean_ds,temp_smooth);
    d.summarized_cluster{ij}.NO_RUNNING_RASTER = RASTER;
    if plot_on
        subtightplot(4,8,16+[6 7],gap,marg_h,marg_w)
        plot_spk_raster(fig_props,RASTER)
        set(gca,'xticklabel',[])
        xlabel('')
        subtightplot(4,8,16+[14 15],gap,marg_h,marg_w)
        plot_spk_psth(fig_props,RASTER);
        text(.02,.93,sprintf('%s',id_type_wall_tuning),'Units','Normalized','Color','r')
    end
    
    id_type_wall_tuning = 'olR';
    % Make touch tuning when not running
    stim_name = 'corPos';
    keep_name = 'not_running';
    id_type_wall_tuning = 'olR';
    tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type_wall_tuning,time_range,trial_range,run_thresh);
    [peak_rate loc] = max(tuning_curve.model_fit.curve);
    peak_dist = tuning_curve.regressor_obj.x_fit_vals(loc);
    d.summarized_cluster{ij}.NO_RUNNING_TOUCH_TUNING = tuning_curve;
    if plot_on
        subtightplot(4,8,[24 32],gap,marg_h,marg_w)
        plot_tuning_curve_ephys(fig_props,tuning_curve)
        text(.05,.96,sprintf('Peak rate %.2f Hz',peak_rate),'Units','Normalized','Color','r')
        text(.05,.89,sprintf('Peak distance %.1f mm',peak_dist),'Units','Normalized','Color','r')
    end
    
    % Make touch tuning when wall moving
    keep_name = 'running';
    stim_name = 'wall_direction';
    stim_name2 = 'corPos';
    tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type_wall_tuning,time_range,trial_range,run_thresh);
    d.summarized_cluster{ij}.WALL_DIRECTION_TUNING = tuning_curve;
    if plot_on
        subtightplot(4,8,[17 25],gap,marg_h,marg_w)
        plot_tuning_curve_multi_ephys(fig_props,tuning_curve)
    end
    
    % Make touch tuning when running left/right
    keep_name = 'running';
    stim_name = 'run_direction';
    stim_name2 = 'corPos';
    tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type_wall_tuning,time_range,trial_range,run_thresh);
    d.summarized_cluster{ij}.RUN_DIRECTION_TUNING = tuning_curve;
    if plot_on
        subtightplot(4,8,[20 28],gap,marg_h,marg_w)
        plot_tuning_curve_multi_ephys(fig_props,tuning_curve)
    end
    
    
    if plot_on
        subtightplot(4,8,[18 26],gap,marg_h,marg_w)
        cur_pos = get(gca,'Position');
        cur_fig_pos = get(gcf,'Position');
        cur_pos(4) = cur_pos(3)*cur_fig_pos(3)/cur_fig_pos(4);
        set(gca,'Position',cur_pos)
        hold on
        plot([0 5*ceil([1 1]/5*max(max(tuning_curve.model_fit{1}.curve),max(tuning_curve.model_fit{2}.curve)))],[0 5*ceil([1 1]/5*max(max(tuning_curve.model_fit{1}.curve),max(tuning_curve.model_fit{2}.curve)))],'LineWidth',2,'Color','k')
        plot(tuning_curve.model_fit{2}.curve,tuning_curve.model_fit{1}.curve,'.b')
        xlim([0 5*ceil(1/5*max(max(tuning_curve.model_fit{1}.curve),max(tuning_curve.model_fit{2}.curve)))])
        ylim([0 5*ceil(1/5*max(max(tuning_curve.model_fit{1}.curve),max(tuning_curve.model_fit{2}.curve)))])
    end
    
    % Make touch tuning when running slow / fast
    keep_name = 'base';
    stim_name = 'running_grouped';
    stim_name2 = 'corPos';
    tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type_wall_tuning,time_range,trial_range,run_thresh);
    d.summarized_cluster{ij}.RUN_SPEED_TUNING = tuning_curve;
    if plot_on
        subtightplot(4,8,[19 27],gap,marg_h,marg_w)
        plot_tuning_curve_multi_ephys(fig_props,tuning_curve)
    end
    
    
    
    % Make trial Raster to running and contra touch
    if strcmp(exp_type,'laser_ol') || strcmp(exp_type,'laser_ol_new')
        id_type_wall_tuning = 'olLP';
        keep_name = 'running';
        [group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type_wall_tuning,trial_inds);
        keep_trials = trial_range;
        keep_trials = keep_trials(ismember(keep_trials,find(session.trial_info.mean_speed > run_thresh & ismember(groups_RASTER,group_ids_RASTER))));
        mean_ds = 2;
        temp_smooth = 80;
        RASTER = get_spk_raster(spike_times_ephys,spike_trials,keep_trials,groups_RASTER,group_ids_RASTER,time_range,mean_ds,temp_smooth);
        d.summarized_cluster{ij}.LASER_RUNNING_RASTER = RASTER;
        if plot_on
            subtightplot(4,8,[6 7],gap,marg_h,marg_w)
            plot_spk_raster(fig_props,RASTER)
            set(gca,'xticklabel',[])
            xlabel('')
            subtightplot(4,8,[14 15],gap,marg_h,marg_w)
            plot_spk_psth(fig_props,RASTER);
            text(.02,.93,sprintf('%s',id_type_wall_tuning),'Units','Normalized','Color','r')
        end
        
        % Make touch tuning
        stim_name = 'laser_power';
        keep_name = 'running';
        id_type_wall_tuning = 'olLP';
        tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type_wall_tuning,time_range,trial_range,run_thresh);
        [peak_rate loc] = max(tuning_curve.model_fit.curve);
        peak_dist = tuning_curve.regressor_obj.x_fit_vals(loc);
        s_ind = find(strcmp(d.p_labels,'peak_rate'));
        d.p_nj(ij,s_ind) = peak_rate;
        s_ind = find(strcmp(d.p_labels,'peak_distance'));
        d.p_nj(ij,s_ind) = peak_dist;
        d.summarized_cluster{ij}.LASER_RUNNING_TOUCH_TUNING = tuning_curve;
        if plot_on
            subtightplot(4,8,[8 16],gap,marg_h,marg_w)
            plot_tuning_curve_ephys(fig_props,tuning_curve)
            text(.05,.95,sprintf('Peak rate %.2f Hz',peak_rate),'Units','Normalized','Color','r')
            text(.05,.89,sprintf('Peak distance %.1f mm',peak_dist),'Units','Normalized','Color','r')
        end
        
        % Make trial Raster to running and contra touch
        id_type_wall_tuning = 'olLP';
        keep_name = 'not_running';
        [group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type_wall_tuning,trial_inds);
        keep_trials = trial_range;
        keep_trials = keep_trials(ismember(keep_trials,find(session.trial_info.mean_speed > run_thresh & ismember(groups_RASTER,group_ids_RASTER))));
        mean_ds = 2;
        temp_smooth = 80;
        RASTER = get_spk_raster(spike_times_ephys,spike_trials,keep_trials,groups_RASTER,group_ids_RASTER,time_range,mean_ds,temp_smooth);
        d.summarized_cluster{ij}.LASER_NOT_RUNNING_RASTER = RASTER;
        if plot_on
            subtightplot(4,8,[6 7],gap,marg_h,marg_w)
            plot_spk_raster(fig_props,RASTER)
            set(gca,'xticklabel',[])
            xlabel('')
            subtightplot(4,8,[14 15],gap,marg_h,marg_w)
            plot_spk_psth(fig_props,RASTER);
            text(.02,.93,sprintf('%s',id_type_wall_tuning),'Units','Normalized','Color','r')
        end
        
        % Make touch tuning
        stim_name = 'laser_power';
        keep_name = 'not_running';
        id_type_wall_tuning = 'olLP';
        tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type_wall_tuning,time_range,trial_range,run_thresh);
        [peak_rate loc] = max(tuning_curve.model_fit.curve);
        peak_dist = tuning_curve.regressor_obj.x_fit_vals(loc);
        s_ind = find(strcmp(d.p_labels,'peak_rate'));
        d.p_nj(ij,s_ind) = peak_rate;
        s_ind = find(strcmp(d.p_labels,'peak_distance'));
        d.p_nj(ij,s_ind) = peak_dist;
        d.summarized_cluster{ij}.LASER_NOT_RUNNING_TOUCH_TUNING = tuning_curve;
        if plot_on
            subtightplot(4,8,[8 16],gap,marg_h,marg_w)
            plot_tuning_curve_ephys(fig_props,tuning_curve)
            text(.05,.95,sprintf('Peak rate %.2f Hz',peak_rate),'Units','Normalized','Color','r')
            text(.05,.89,sprintf('Peak distance %.1f mm',peak_dist),'Units','Normalized','Color','r')
        end
    end
    
    
end