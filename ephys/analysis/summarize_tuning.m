function output = summarize_tuning(d,clust_num)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output.r2 = 0;

output.baseline = 0;

output.act = 0;
output.sup = 0;
output.tc_mod = 0;

output.towards = 0;
output.away = 0;
output.dir_mod = 0;

output.tc = zeros(1,61);
output.tc_xvals = 0; 

output.trace_on = zeros(1,500);
output.trace_off = zeros(1,500);
output.trace_t = zeros(1,500);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    s_ind = find(strcmp(d.p_labels,'clust_id'));
    clust_id = d.p_nj(clust_num,s_ind);
    
	exp_type = d.anm_params.exp_type;
    keep_name = 'running';
    id_type = 'olR';
    trial_range_end = min(4000,d.anm_params.trial_range_end(1));
    trial_range = [d.anm_params.trial_range_start(1):trial_range_end];
    run_thresh = d.anm_params.run_thresh;
    constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
    keep_trials = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
    
    
    RASTER = d.summarized_cluster{clust_num}.RUNNING_RASTER;
    
    [group_ids groups] = define_group_ids(exp_type,id_type,[]);
    
    raster_mat_full = squeeze(d.s_ctk(1,:,keep_trials))';
    vals = raster_mat_full(:,1000);
    u_vals = unique(vals);
    raster_mat_full = max(raster_mat_full(:)) - raster_mat_full;
    
    tc = zeros(length(group_ids),1);
    for ij = 1:length(group_ids)
        num_trials = sum(vals == u_vals(ij));
        tc(ij) = sum(RASTER.spikes{ij}>1 & RASTER.spikes{ij}<3)/2/num_trials;
    end
    
    
    run_thresh = d.anm_params.run_thresh;
    trial_range =d.anm_params.trial_range_start(1):min(4000,d.anm_params.trial_range_end(1));
    exp_type = d.anm_params.exp_type;
    keep_name = 'running';
    
    regressor_tune_type = 'Smooth';
    stim_name = 'wall_direction';
    time_range = [2 3];
    tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh,regressor_tune_type);
    %plot_tuning_curve_ephys(fig_props,tuning_curve)
    
    constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
    keep_trials = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
    
    raster_mat = squeeze(d.r_ntk(clust_id,:,keep_trials))';
    sense_mat = squeeze(d.s_ctk(1,:,keep_trials))';
    [group_ids groups] = define_group_ids(exp_type,id_type,[]);
    groups = d.u_ck(1,keep_trials);
    
    raster_mat_avg = NaN(length(group_ids),size(raster_mat,2));
    sense_mat_avg = NaN(length(group_ids),size(raster_mat,2));
    time_mat_avg = NaN(length(group_ids),size(raster_mat,2));
    for ij = 1:length(group_ids)
        tmp = mean(raster_mat(groups == group_ids(ij),:),1);
        tmps = mean(sense_mat(groups == group_ids(ij),:),1);
        if ~isempty(tmp)
            raster_mat_avg(ij,:) = tmp;
            sense_mat_avg(ij,:) = tmps;
            time_mat_avg(ij,:) = [1:size(raster_mat,2)]/500;
        end
    end
    
%    assignin('base','sense_mat_avg',sense_mat_avg)

    temp_smooth = 80;
    raster_mat = conv2(raster_mat,ones(1,temp_smooth)/temp_smooth,'same');
    raster_mat_avg = 500*conv2(raster_mat_avg,ones(1,temp_smooth)/temp_smooth,'same');
    
    avg_on = NaN(length(group_ids),500);
    avg_off = NaN(length(group_ids),500);
    sense_on = NaN(length(group_ids),500);
    sense_off = NaN(length(group_ids),500);
    
    for ij = 1:length(group_ids)
        onset = find(sense_mat_avg(ij,:)<=16,1,'first');
        offset = find(sense_mat_avg(ij,:)<=16,1,'last');
        if ~isempty(onset) && ~isempty(offset)
            avg_on(ij,:) = raster_mat_avg(ij,onset-149:onset+350);
            avg_off(ij,:) = raster_mat_avg(ij,offset-350:offset+149);
            sense_on(ij,:) = sense_mat_avg(ij,onset-149:onset+350);
            sense_off(ij,:) = sense_mat_avg(ij,offset-350:offset+149);
        end
    end
    %avg_off = flipdim(avg_off,2);
    
    avg_on = nanmean(avg_on);
    avg_off = nanmean(avg_off);
    sense_on = nanmean(sense_on);
    sense_off = nanmean(sense_off);
    sense_on_full = sense_on;
    %avg_on = smooth(nanmean(avg_on),50);
    %avg_off = smooth(nanmean(avg_off),50);
    
    avg_on = smooth(avg_on,20);
    avg_off = smooth(avg_off,20);
    
    raster_mat_avg_red = raster_mat_avg(:,81:20:end-80);
    sense_mat_avg_red = sense_mat_avg(:,81:20:end-80);
    sense_on = sense_on(81:20:end-80);
    sense_off = sense_off(81:20:end-80);
    
    trace_time = linspace(0,1,500);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    X = raster_mat_avg_red(:);
    Y = sense_mat_avg_red(:);
    
    weight = mean(raster_mat_avg_red(:,20:60),2);
    stim = mean(sense_mat_avg_red(:,20:60),2);
    
    [val_M ind_M] = max(weight);
    [val_m ind_m] = min(weight);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    baseline = 3;
    gain = 8;
    weight = 0.1;
    center_1 = 10;
    scale_1 = 1;
    center_2 = 10;
    scale_2 = 1;
    prsK_1 = [0.1];
    prsK_2 = [0.1];
    
    
    initPrs = [baseline gain weight center_1 scale_1 center_2 scale_2 prsK_1 prsK_2];
    %initPrs = [0 40 1/4 8 4 5 1 -3.5/4 0];
    %initPrs =[-3.3957   40.9997    0.4677   12.5018    3.1539   11.4084    2.6212    0.1    .9];
    %initPrs =[0   40.9997    0.5   12.5018    3.1539   11.4084    2.6212    0.1    .9];
    
    out = fitDoubleSigmoidKnp(sense_mat_avg_red,raster_mat_avg_red,initPrs);
    curve = fitDoubleSigmoidKnp_modelFun(sense_mat_avg_red,out.estPrs);
    
    out.estPrs;
    
    x_vals = [0:.5:30];
    prs = out.estPrs([2 5 1 4]);
    prs(1) = prs(1)*(1+out.estPrs(8));
    curve_G1 = fitSigmoid_modelFun(x_vals,prs);
    prs = out.estPrs([2 7 1 6]);
    prs(1) = prs(1)*out.estPrs(3);
    prs(1) = prs(1)*(1+out.estPrs(9));
    prs(3) = 0;
    curve_G2 = fitSigmoid_modelFun(x_vals,prs);
    
    curve_G = curve_G1 - curve_G2;
    curve_G(curve_G<0) = 0;
    
    tc_baseline = curve_G(end);
    [tc_min_val sup_loc] = min(curve_G);
    [tc_max_val act_loc] = max(curve_G);
    
    curve_K1 = [1 out.estPrs(8)];
    curve_K2 = [1 out.estPrs(9)];
    
    xt_vals = [repmat(30,1,10) linspace(30,0,25) repmat(0,1,10)]; % downsample by 20, so 500/20 = 25 timepoints per second
    curve_xt_on = fitDoubleSigmoidKnp_modelFun(xt_vals,out.estPrs);
    curve_xt_off = fitDoubleSigmoidKnp_modelFun(flipdim(xt_vals,2),out.estPrs);
    %curve_xt_off = flipdim(curve_xt_off,2);
    
    xt_vals = xt_vals(11:end-10);
    curve_xt_on = curve_xt_on(11:end-10);
    curve_xt_off = curve_xt_off(11:end-10);
    
    curve_xt_on  = fitDoubleSigmoidKnp_modelFun(sense_on, out.estPrs);
    curve_xt_off = fitDoubleSigmoidKnp_modelFun(sense_off,out.estPrs);
    %curve_xt_off = flipdim(curve_xt_off,2);
    
    xt_vals = linspace(0,1,length(curve_xt_on));
    
    ton_mod_val = max(avg_on) - min(avg_on);
    toff_mod_val = max(avg_off) - min(avg_off);
    tdirc_mix = (abs(ton_mod_val) - abs(toff_mod_val))/(abs(ton_mod_val) + abs(toff_mod_val));

        

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    curve_m = curve(1,:);
    
    raster_mat_avg_m = mean(raster_mat_avg(:,[501:1500]),2);
    sense_mat_avg_m = mean(sense_mat_avg(:,[501:1500]),2);
    
    regressor_tune_type = 'DoubleGauss';
    stim_name = 'corPos';
    time_range = [0 4];
    tuning_curve = get_tuning_curve_ephys_red(raster_mat_avg_m(:),sense_mat_avg_m(:),d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh,regressor_tune_type);
    %tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh,regressor_tune_type);
    
    tc_baseline = curve_G(end);
    tc_min_val = min(curve_G);
    tc_max_val = max(curve_G);
    y_max = max(ceil(max(curve_G)/2)*2,1);
    
    tc_sup = tc_baseline - tc_min_val;
    tc_act = tc_max_val - tc_baseline;
    tc_mix = (abs(tc_act) - abs(tc_sup))/(abs(tc_act) + abs(tc_sup));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output.r2 = out.r2;

output.baseline = tc_baseline;


output.act = tc_act;
output.sup = tc_sup;
output.tc_mod = tc_mix;
output.act_loc = act_loc;
output.sup_loc = sup_loc;

output.towards = ton_mod_val;
output.away = toff_mod_val;
output.dir_mod = tdirc_mix;

output.tc = curve_G;
output.tc_xvals = x_vals; 

output.trace_on = avg_on;
output.trace_off = avg_off;
output.trace_t = trace_time;

output.raster_ds = raster_mat_avg_red;
output.raster_fit = curve;
output.tuning_curve = tuning_curve;
output.RASTER = RASTER;
output.raster_mat_full = raster_mat_full;

output.sense_mat_avg = sense_mat_avg;
output.sense_trace_time = sense_on_full;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

















