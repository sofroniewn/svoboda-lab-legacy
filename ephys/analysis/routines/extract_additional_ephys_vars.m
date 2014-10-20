function [ps p p_labels curves all_anm] = extract_additional_ephys_vars(all_anm)

barrel_inds = {'C1','C2','C3','C4','D1','D2','B1','V1'};

p_labels = all_anm{1}.d.p_labels;
p = [];
for ih = 1:numel(all_anm)
    p = cat(1,p,all_anm{ih}.d.p_nj);
end

p_labels = [p_labels;'clust_num'];
p = cat(2,p,[1:size(p,1)]');

time_range = [0 4];
stim_name = 'corPos';
keep_name = 'ol_running';
id_type = 'olR';

add_labels = {'no_walls_still_rate';'no_walls_run_rate';'walls_run_rate';'touch_baseline_rate';'touch_peak_rate';'touch_min_rate';'touch_mean_rate';'touch_max_loc';'touch_min_loc';'num_trials';'layer_id';'mod_up';'mod_down';'stab_fr';'stab_amp';'layer_4_dist_CSD';'AP';'ML';'barrel_loc'};
add_vec = zeros(size(p,1),numel(add_labels));
ik = 0
for ih = 1:numel(all_anm)
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
    
    all_anm{ih}.d.u_ck = cat(1,all_anm{ih}.d.u_ck(1:6,:),add_u_vec);
    all_anm{ih}.d.u_labels = [all_anm{ih}.d.u_labels(1:6);add_u_labels];
    
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
         %mid_fr = mean(AMPLITUDES.trial_firing_rate(first_third:end-first_third));
         end_fr = mean(AMPLITUDES.trial_firing_rate(end-first_third:end));
         tot_fr = mean(AMPLITUDES.trial_firing_rate(:));
         %[val ind] = max([abs(start_fr - end_fr),abs(start_fr - mid_fr),abs(mid_fr - end_fr)]);

        stab_fr = (start_fr - end_fr)/tot_fr;

         %if ind == 1
         % stab_fr = (start_fr - end_fr)/tot_fr;
          %elseif ind == 2
          %  stab_fr = (start_fr - mid_fr)/tot_fr;
           %elseif ind == 3
           %stab_fr = (mid_fr - end_fr)/tot_fr;
        %end

        first_third = round(length(AMPLITUDES.trial_firing_rate)/3);
        start_amp = mean(AMPLITUDES.norm_vals(AMPLITUDES.trial_spks<first_third + AMPLITUDES.trial_range(1)));
        end_amp = mean(AMPLITUDES.norm_vals(AMPLITUDES.trial_spks>2*first_third + AMPLITUDES.trial_range(1)));
        full_amp = mean(AMPLITUDES.norm_vals);
        if ~isnan(start_amp) && ~isnan(end_amp)
            stab_amp = (start_amp - end_amp)/full_amp;
        else
            stab_amp = 2;
        end


        full_x = [];
        full_y = [];
        for ip = 1:length(tuning_curve.regressor_obj.x_vals)
            full_x = [full_x;repmat(tuning_curve.regressor_obj.x_vals(ip),length(tuning_curve.data{ip}),1)];
            full_y = [full_y;tuning_curve.data{ip}];
        end
        
        
        param = 10^-5;
        tuning_curve.model_fit.curve = csaps(full_x,full_y,param,tuning_curve.regressor_obj.x_fit_vals);
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
        mean_rate = mean(tuning_curve.model_fit.curve);
        loc = tuning_curve.regressor_obj.x_fit_vals(loc);
        locm = tuning_curve.regressor_obj.x_fit_vals(locm);
        
        walls_run_rate = mean(full_y(full_x<18));

        trial_range = [trial_range_start(clust_id):min(trial_range_end(clust_id),4000)];
        
        constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
        keep_trials = apply_trial_constraints(all_anm{ih}.d.u_ck,all_anm{ih}.d.u_labels,constrain_trials);
             
        add_vec(ik,3:end) = [walls_run_rate baseline pks pksm mean_rate loc locm sum(keep_trials) layer_id (pks - baseline) (baseline - pksm) stab_fr stab_amp layer_4_dist_CSD AP ML barrel_id];
        
    end
end

p_labels = all_anm{1}.d.p_labels;
p = [];
for ih = 1:numel(all_anm)
    p = cat(1,p,all_anm{ih}.d.p_nj);
end

p_labels = [p_labels;'clust_num'];
p = cat(2,p,[1:size(p,1)]');


p = cat(2,p,add_vec);
p_labels = [p_labels;add_labels];


add_labels = {'adapt';'SNR'};
add_vec = zeros(size(p,1),numel(add_labels));
curves.onset = zeros(size(p,1),length(tuning_curve.model_fit.curve));
curves.offset = zeros(size(p,1),length(tuning_curve.model_fit.curve));
curves.resamp = zeros(size(p,1),length(tuning_curve.model_fit.curve),100);
ik = 0;
for ih = 1:numel(all_anm)
    anm_id = num2str(all_anm{ih}.d.p_nj(1,1));
    [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
    run_thresh = anm_params.run_thresh;
    trial_range_start = anm_params.trial_range_start;
    trial_range_end = anm_params.trial_range_end;
    cell_reject = anm_params.cell_reject;
    exp_type = anm_params.exp_type;
    layer_4 = anm_params.layer_4;
    boundaries = anm_params.boundaries;
    boundary_labels = anm_params.boundary_labels;
    for ij = 1:numel(all_anm{ih}.d.summarized_cluster)
        
        s_ind = find(strcmp(p_labels,'clust_id'));
        clust_id = all_anm{ih}.d.p_nj(ij,s_ind);
        trial_range = [trial_range_start(clust_id):min(trial_range_end(clust_id),4000)];
        
        
        [ih numel(all_anm) ij numel(all_anm{ih}.d.summarized_cluster)]
        ik = ik+1;
        time_range = [0 1.5];
        tune_curve = get_tuning_curve_ephys(ij+2,all_anm{ih}.d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
        curves.onset(ik,:) = tune_curve.model_fit.curve;
        time_range = [1.5 3];
        tune_curve = get_tuning_curve_ephys(ij+2,all_anm{ih}.d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
        curves.offset(ik,:) = tune_curve.model_fit.curve;

        %time_range = [0 3];
        %tune_curve = get_tuning_curve_resample_ephys(ij+2,all_anm{ih}.d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
        %curves.resamp(ik,:,:) = tune_curve.model_fit.resamp_tuning_curve';

        SNR_val = 10;
        add_vec(ik,:) = [mean(curves.onset(ik,:) - curves.offset(ik,:)) SNR_val];
    end
end


p = cat(2,p,add_vec);
p_labels = [p_labels;add_labels];


ps = [];
for ij = 1:numel(p_labels)
    ps.(p_labels{ij}) = p(:,ij);
end



% figure(12)
% clf(12)
% hold on
% plot(tune_curve.regressor_obj.x_fit_vals,tune_curve.model_fit.resamp_tuning_curve,'r')
% plot(tune_curve.regressor_obj.x_fit_vals,tune_curve.model_fit.curve,'linewidth',2)
% plot(tune_curve.regressor_obj.x_fit_vals,mean(tune_curve.model_fit.resamp_tuning_curve),'k','linewidth',2)


% xy = mean(var_tune,2);
% xx = mean(mean_tune,2);
% SNR = xx./sqrt(xy);

% figure
% plot(xx,SNR,'.r')


% %%
%     stim_name = 'corPos';
%     keep_name = 'ol_running';
%     id_type = 'olR';

% %var_tune = [];
% %mean_tune = [];
% onset_curve = [];
% offset_curve = [];

% num_trials = []
% for ih = 1:numel(all_anm)
% anm_id = num2str(all_anm{ih}.d.p_nj(1,1));
% [base_dir trial_range_start exp_type layer_4] = ephys_anm_id_database(anm_id,0);
%   for ij = 1:numel(all_anm{ih}.d.summarized_cluster)
% 	[ih numel(all_anm) ij numel(all_anm{ih}.d.summarized_cluster)]
% 	time_range = [0 2];
% 	tune_curve = get_tuning_curve_ephys(ij+2,all_anm{ih}.d,stim_name,keep_name,exp_type,id_type,time_range);
% 	onset_curve = cat(1,onset_curve,tune_curve.model_fit.curve);
% 	time_range = [2 4];
% 	tune_curve = get_tuning_curve_ephys(ij+2,all_anm{ih}.d,stim_name,keep_name,exp_type,id_type,time_range);
% 	offset_curve = cat(1,offset_curve,tune_curve.model_fit.curve);
%   end
% end

