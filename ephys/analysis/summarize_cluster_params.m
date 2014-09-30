function d = summarize_cluster_params(d,ephys_summary,all_clust_ids,sorted_spikes,session,exp_type,trial_range,layer_4)

trial_range(trial_range>numel(session.data)) = [];

ephys_sampling_rate = 20833.33;
num_chan = 32;


trial_inds = session.trial_info.inds;
id_type_base = 'base';
[group_ids groups] = define_group_ids(exp_type,id_type_base,trial_inds);

max_length_trial = 2001;
if isempty(d)
    d = convert_rsu_format(sorted_spikes,session,trial_range,group_ids,groups,max_length_trial);
end

d.p_labels = {'anm_id';'clust_id';'chan_depth';'layer_4_dist';'num_spikes';'isi_peak';'isi_violations';'waveform_SNR';'spk_amplitude';'spike_tau';'spike_tau1';'spike_tau2';'baseline_rate';'running_modulation';'peak_rate';'peak_distance'};

d.p_nj = NaN(length(all_clust_ids),numel(d.p_labels));
d.summarized_cluster = cell(length(all_clust_ids),1);

for ij = 1:length(all_clust_ids)
    
    s_ind = find(strcmp(d.p_labels,'anm_id'));
    d.p_nj(ij,s_ind) = str2num(session.basic_info.anm_str(5:end));
    
    
    % get cluster id information
    clust_id = all_clust_ids(ij);
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
    
    % get depth information
    peak_channel = get_peak_channel(mean_spike_amp,[]);
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
    
    
    
    % Make stability plot
    AMPLITUDES = get_spk_amplitude(spike_amps,spike_trials,trial_times,trial_range);
    d.summarized_cluster{ij}.AMPLITUDES = AMPLITUDES;
    BEHAVIOUR_VECT = get_behaviour_vect(session,'speed',trial_range);
    d.summarized_cluster{ij}.BEHAVIOUR_VECT = BEHAVIOUR_VECT;
    
    
    time_range = [0 4];
    % Make running tuning
    stim_name = 'running';
    keep_name = 'ol_base';
    id_type_speed_tuning = 'outOfReach';
    tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type_speed_tuning,time_range);
    running_modulation = tuning_curve.means(2)/tuning_curve.means(1);
    baseline_rate = tuning_curve.means(1);
    s_ind = find(strcmp(d.p_labels,'baseline_rate'));
    d.p_nj(ij,s_ind) = baseline_rate;
    s_ind = find(strcmp(d.p_labels,'running_modulation'));
    d.p_nj(ij,s_ind) = running_modulation;
    d.summarized_cluster{ij}.RUNNING_MOD = tuning_curve;
    
    
    % Make trial Raster to running and contra touch
    id_type_wall_tuning = 'olR';
    keep_name = 'ol_running';
    [group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type_wall_tuning,trial_inds);
    keep_trials = trial_range;
    keep_trials = keep_trials(ismember(keep_trials,find(session.trial_info.mean_speed > 5 & ismember(groups_RASTER,group_ids_RASTER))));
    mean_ds = 2;
    temp_smooth = 80;
    RASTER = get_spk_raster(spike_times_ephys,spike_trials,keep_trials,groups_RASTER,group_ids_RASTER,time_range,mean_ds,temp_smooth);
    d.summarized_cluster{ij}.RUNNING_RASTER = RASTER;
    
    
    % Make touch tuning
    stim_name = 'corPos';
    keep_name = 'ol_running';
    id_type_wall_tuning = 'olR';
    tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type_wall_tuning,time_range);
    [peak_rate loc] = max(tuning_curve.model_fit.curve);
    peak_dist = tuning_curve.regressor_obj.x_fit_vals(loc);
    s_ind = find(strcmp(d.p_labels,'peak_rate'));
    d.p_nj(ij,s_ind) = peak_rate;
    s_ind = find(strcmp(d.p_labels,'peak_distance'));
    d.p_nj(ij,s_ind) = peak_dist;
    d.summarized_cluster{ij}.TOUCH_TUNING = tuning_curve;
    
    % Make trial Raster to not running and contra touch
    id_type_wall_tuning = 'olR';
    stim_name = 'corPos';
    keep_name = 'ol_not_running';
    [group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type_wall_tuning,trial_inds);
    keep_trials = trial_range;
    keep_trials = keep_trials(ismember(keep_trials,find(session.trial_info.mean_speed <= 5 & ismember(groups_RASTER,group_ids_RASTER))));
    time_range = [0 4];
    mean_ds = 2;
    temp_smooth = 80;
    RASTER = get_spk_raster(spike_times_ephys,spike_trials,keep_trials,groups_RASTER,group_ids_RASTER,time_range,mean_ds,temp_smooth);
    d.summarized_cluster{ij}.NO_RUNNING_RASTER = RASTER;
    
    id_type_wall_tuning = 'olR';
    % Make touch tuning when not running
    stim_name = 'corPos';
    keep_name = 'ol_not_running';
    id_type_wall_tuning = 'olR';
    tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type_wall_tuning,time_range);
    [peak_rate loc] = max(tuning_curve.model_fit.curve);
    peak_dist = tuning_curve.regressor_obj.x_fit_vals(loc);
    d.summarized_cluster{ij}.NO_RUNNING_TOUCH_TUNING = tuning_curve;
    
    
    % Make touch tuning when wall moving
    keep_name = 'ol_running';
    stim_name = 'wall_direction';
    stim_name2 = 'corPos';
    tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type_wall_tuning,time_range);
    d.summarized_cluster{ij}.WALL_DIRECTION_TUNING = tuning_curve;
    
    % Make touch tuning when running left/right
    keep_name = 'ol_running';
    stim_name = 'run_direction';
    stim_name2 = 'corPos';
    tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type_wall_tuning,time_range);
    d.summarized_cluster{ij}.RUN_DIRECTION_TUNING = tuning_curve;
    
    
    % Make touch tuning when running slow / fast
    keep_name = 'ol_base';
    stim_name = 'running_grouped';
    stim_name2 = 'corPos';
    tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type_wall_tuning,time_range);
    d.summarized_cluster{ij}.RUN_SPEED_TUNING = tuning_curve;
end