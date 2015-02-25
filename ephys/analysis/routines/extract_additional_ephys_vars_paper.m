function [ps curves rasters all_anm] = extract_additional_ephys_vars(all_anm,names)

% extract additional variables from raw data

x_fit_vals = all_anm{1}.d.summarized_cluster{1}.TOUCH_TUNING.regressor_obj.x_fit_vals;
barrel_inds = {'C1','C2','C3','C4','D1','D2','B1','V1'};

p_labels = all_anm{1}.d.p_labels;
p = [];
for ih = 1:numel(all_anm)
    p = cat(1,p,all_anm{ih}.d.p_nj);
end

p_labels = [p_labels;'clust_num'];
p = cat(2,p,[1:size(p,1)]');

% get current p_labels
ps = [];
for ij = 1:numel(p_labels)
    ps.(p_labels{ij}) = p(:,ij);
end


% extra variables to be added
add_labels = {'no_walls_still_rate';'no_walls_run_rate';'walls_run_rate'; ...
            'touch_baseline_rate';'touch_peak_rate';'touch_min_rate';'touch_mean_rate'; ...
            'touch_max_loc';'touch_min_loc';'num_trials';'layer_id';'mod_up';'mod_down'};
add_vec = zeros(size(p,1),numel(add_labels));


time_range = [0 4];
stim_name = 'corPos';
keep_name = 'running';
id_type = 'olR';
ik = 0


for ih = 1:numel(all_anm)
    
    % extract information about experiment from id database
    anm_id = num2str(all_anm{ih}.d.p_nj(1,1));
    [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
    run_thresh = anm_params.run_thresh;
    trial_range_start = anm_params.trial_range_start;
    trial_range_end = anm_params.trial_range_end;
    cell_reject = anm_params.cell_reject;
    exp_type = anm_params.exp_type;
    layer_4_CSD = anm_params.layer_4;
    boundaries = anm_params.boundaries;
    boundary_labels = anm_params.boundary_labels;
    layer_4_corr = anm_params.layer_4_corr;
    AP = anm_params.AP;
    ML = anm_params.ML;
    barrel_loc = anm_params.barrel_loc;
    barrel_id = find(ismember(barrel_inds,barrel_loc));
    if isempty(barrel_id)
        error('Could not find barrel id')
    end
    layer_4 = layer_4_corr;
    boundaries(isnan(boundaries)) = -Inf;
    
    
    % add some u labels
    add_u_labels = {'forward_dist';'lat_dist';'run_angle';'wall_dist'};
    add_u_vec = zeros(numel(add_u_labels),size(all_anm{ih}.d.u_ck,2));
    
    s_ind = find(strcmp(all_anm{ih}.d.s_labels,'forward_speed'));
    tmp = squeeze(all_anm{ih}.d.s_ctk(s_ind,:,:));
    tmp = sum(tmp)/all_anm{ih}.d.samp_rate;
    add_u_vec(2,:) = tmp;
    
    s_ind = find(strcmp(all_anm{ih}.d.s_labels,'lateral_speed'));
    tmp = squeeze(all_anm{ih}.d.s_ctk(s_ind,:,:));
    tmp = sum(tmp)/all_anm{ih}.d.samp_rate;
    add_u_vec(1,:) = tmp;
    
    add_u_vec(3,:) = 180/pi*atan2(add_u_vec(2,:),add_u_vec(1,:));
    
    s_ind = find(strcmp(all_anm{ih}.d.s_labels,'wall_pos'));
    tmp = squeeze(all_anm{ih}.d.s_ctk(s_ind,:,:));
    tmp = round(tmp/2)*2;
    tmp = mode(tmp);
    add_u_vec(4,:) = tmp;
    
    all_anm{ih}.d.u_ck = cat(1,all_anm{ih}.d.u_ck(1:7,:),add_u_vec);
    all_anm{ih}.d.u_labels = [all_anm{ih}.d.u_labels(1:7);add_u_labels];
    
    % go through each cluster
    for ij = 1:numel(all_anm{ih}.d.summarized_cluster)
        ik = ik+1;
        [ih numel(all_anm) ij numel(all_anm{ih}.d.summarized_cluster)]
        
        
        s_ind = find(strcmp(p_labels,'chan_depth'));
        peak_channel = all_anm{ih}.d.p_nj(ij,s_ind);
        
        s_ind = find(strcmp(p_labels,'layer_4_dist'));
        layer_4_dist = (layer_4 - peak_channel)*20;
        layer_4_dist_CSD = (layer_4_CSD - peak_channel)*20;
        all_anm{ih}.d.p_nj(ij,s_ind) = layer_4_dist;

        layer_id = find(boundaries<layer_4_dist,1,'last');
        
        s_ind = find(strcmp(p_labels,'clust_id'));
        clust_id = all_anm{ih}.d.p_nj(ij,s_ind);
        

        add_vec(ik,1:2) = all_anm{ih}.d.summarized_cluster{ij}.RUNNING_MOD.means;
        tuning_curve = all_anm{ih}.d.summarized_cluster{ij}.TOUCH_TUNING;        
        AMPLITUDES = all_anm{ih}.d.summarized_cluster{ij}.AMPLITUDES;
        first_third = round(length(AMPLITUDES.trial_firing_rate)/3);
        start_fr = mean(AMPLITUDES.trial_firing_rate(1:first_third));
         end_fr = mean(AMPLITUDES.trial_firing_rate(end-first_third:end));
         tot_fr = mean(AMPLITUDES.trial_firing_rate(:));
        stab_fr = (start_fr - end_fr)/tot_fr;
        first_third = round(length(AMPLITUDES.trial_firing_rate)/3);
        start_amp = mean(AMPLITUDES.norm_vals(AMPLITUDES.trial_spks<first_third + AMPLITUDES.trial_range(1)));
        end_amp = mean(AMPLITUDES.norm_vals(AMPLITUDES.trial_spks>2*first_third + AMPLITUDES.trial_range(1)));
        full_amp = mean(AMPLITUDES.norm_vals);
        if ~isnan(start_amp) && ~isnan(end_amp)
            stab_amp = (start_amp - end_amp)/full_amp;
        else
            stab_amp = 2;
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        output = summarize_tuning_sig(all_anm{ih}.d,ij);

    ps.r2(ik,1) = output.r2;
    ps.baseline(ik,1) = output.baseline;
    ps.act(ik,1) = output.act;
    ps.sup(ik,1) = output.sup;
    ps.act_loc(ik,1) = output.act_loc;
    ps.sup_loc(ik,1) = output.sup_loc;
    ps.tc_mod(ik,1) = output.tc_mod;
    ps.towards(ik,1) = output.towards;
    ps.away(ik,1) = output.away;
    ps.dir_mod(ik,1) = output.dir_mod;


    curves.tuning_curve(ik,:) = output.tc;
    curves.tuning_curve_x_vals = output.tc_xvals;

    curves.trace_towards(ik,:) = output.trace_on;
    curves.trace_away(ik,:) = output.trace_off;
    curves.trace_time(ik,:) = output.trace_t;

    rasters{ik} = output;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ps.stab_fr(ik,1) = stab_fr;
    ps.layer_id(ik,1) = layer_id;
    ps.stab_amp(ik,1) = stab_amp;
    ps.layer_4_dist_CSD(ik,1) = layer_4_dist_CSD;
    ps.AP(ik,1) = AP;
    ps.ML(ik,1) = ML;
    ps.barrel_loc(ik,1) = barrel_id;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ps.total_order = [ps.anm_id, ps.clust_id, [1:length(ps.anm_id)]', ps.layer_4_dist];
[time_vect norm_waves mean_waves] = get_mean_waveforms(all_anm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clean up spikes
ps.stable_spikes = abs(ps.stab_amp)<1.5 & abs(ps.stab_fr)<1.75;
ps.clean_isi = ps.isi_violations < 1;
ps.good_snr = ps.waveform_SNR > 6;
ps.good_tuning = ps.r2 > 0.3;
ps.good_waveform = norm_waves(:,end)>-.4 & max(norm_waves,[],2) < .7;
ps.clean_clusters = ps.stable_spikes & ps.clean_isi & ps.good_snr & ps.good_waveform;

% Spike waveforms
ps.regular_spikes_slow = ps.spike_tau >= 700;
ps.regular_spikes_fast = ps.spike_tau >= 500 & ps.spike_tau < 700;
ps.fast_spikes = ps.spike_tau < 350;
ps.intermediate_spikes = ps.spike_tau >= 350 & ps.spike_tau < 500;
ps.regular_spikes = (ps.regular_spikes_slow | ps.regular_spikes_fast);

% lamina position and depth
barrel_inds = {'C1','C2','C3','C4','D1','D2','B1','V1'};
ps.layer_id(ps.layer_id==6) = 5;
ps.layer_6 = ps.layer_id == 6;
ps.layer_5b = ps.layer_id == 5;
ps.layer_5a = ps.layer_id == 4;
ps.layer_4 = ps.layer_id == 3;
ps.layer_23 = ps.layer_id == 2;


ps.c1c2 = ismember(ps.barrel_loc,[1:2]);
ps.d1 = ismember(ps.barrel_loc,5);
ps.c_row = ismember(ps.barrel_loc,[1:4]);
ps.d_row = ismember(ps.barrel_loc,[5:6]);
ps.b_row =  ismember(ps.barrel_loc,[7]);
ps.v1 = ismember(ps.barrel_loc,[8]);
ps.barrel_id = ps.c_row + ps.b_row+ 2*ps.d_row + 3*ps.v1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
