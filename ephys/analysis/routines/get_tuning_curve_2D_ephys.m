function tuning_curve = get_tuning_curve_2D_ephys(clust_id,d,stim_name,stim_name2,keep_name,exp_type,id_type,time_range);

constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type);
keep_trials = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
regressor_obj = define_regression_var_ephys(stim_name);
regressor_obj2 = define_regression_var_ephys(stim_name2);

time_range_inds = floor([d.samp_rate*time_range(1):d.samp_rate*time_range(2)])+1;
time_range_inds(time_range_inds>size(d.r_ntk,2)) = [];

responseVar = d.r_ntk(clust_id,time_range_inds,keep_trials);
responseVar = d.samp_rate*responseVar(:);

label = regressor_obj.var_tune;
s_ind = find(strcmp(d.s_labels,regressor_obj.var_tune));
if isempty(s_ind)
    error('WGNR :: could not find s label for regression')
end
tmp = d.s_ctk(s_ind,time_range_inds,keep_trials);
regressor_obj.var_tune = tmp(:);

label2 = regressor_obj2.var_tune;
s_ind = find(strcmp(d.s_labels,regressor_obj2.var_tune));
if isempty(s_ind)
    error('WGNR :: could not find s label for regression')
end
tmp = d.s_ctk(s_ind,time_range_inds,keep_trials);
regressor_obj2.var_tune = tmp(:);

[regMat regVect1] = get_regression_mat(regressor_obj);
num_groups1 = regressor_obj.num_groups;
[regMat regVect2] = get_regression_mat(regressor_obj2);
num_groups2 = regressor_obj2.num_groups;

tuning_curve = get_tuning_curve_2D(regVect1,num_groups1,regVect2,num_groups2,responseVar);

regressor_obj.y_vals = regressor_obj.x_vals;
regressor_obj.y_label = regressor_obj.x_label;
regressor_obj.y_range = regressor_obj.x_range;
regressor_obj.y_fit_vals = regressor_obj.x_fit_vals;
regressor_obj.z_label = regressor_obj.y_label;

regressor_obj.x_vals = regressor_obj2.x_vals;
regressor_obj.x_fit_vals = regressor_obj2.x_fit_vals;
regressor_obj.x_label = regressor_obj2.x_label;
regressor_obj.x_range = regressor_obj2.x_range;

regressor_obj.var_tune = label;
tuning_curve.regressor_obj = regressor_obj;

fit_model_on = 0;

if fit_model_on
    full_x = [];
    full_y = [];
    for ij = 1:length(tuning_curve.regressor_obj.x_vals)
        full_x = [full_x;repmat(tuning_curve.regressor_obj.x_vals(ij),length(tuning_curve.data{ij}),1)];
        full_y = [full_y;tuning_curve.data{ij}];
    end
    
    baseline = prctile(tuning_curve.means,10);
    weight = tuning_curve.means - baseline;
    mod_depth = max(weight);
    %weight = abs(weight);
    weight = weight/sum(weight);
    tuned_val = sum(weight.*tuning_curve.regressor_obj.x_vals);
    
    
    switch regressor_obj.tune_type
        case 'Gauss'
            initPrs = [tuned_val, 1, mod_depth, baseline];
            tuning_curve.model_fit = fitGauss(full_x,full_y,initPrs);
            tuning_curve.model_fit.curve = fitGauss_modelFun(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit.estPrs);
        case 'Sigmoid'
            initPrs = [];
            tuning_curve.model_fit = fitSigmoid(full_x,full_y,initPrs);
            tuning_curve.model_fit.curve = fitSigmoid_modelFun(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit.estPrs);
        case 'Smooth'
            p = .0001;
            tuning_curve.model_fit.curve = csaps(full_x,full_y,p,tuning_curve.regressor_obj.x_fit_vals);
            [pks loc] = max(tuning_curve.model_fit.curve);
            tuning_curve.model_fit.estPrs = tuning_curve.regressor_obj.x_fit_vals(loc);
            tuning_curve.model_fit.r2 = 0;
            if tuning_curve.num_pts(1) == 0;
                ind = find(tuning_curve.num_pts>0,1,'first');
                val = tuning_curve.regressor_obj.x_vals(ind-1);
                ind = find(tuning_curve.regressor_obj.x_fit_vals<=val,1,'last');
                tuning_curve.model_fit.curve(1:ind) = NaN;
            end
            if tuning_curve.num_pts(end) == 0;
                ind = find(tuning_curve.num_pts>0,1,'last');
                val = tuning_curve.regressor_obj.x_vals(ind+1);
                ind = find(tuning_curve.regressor_obj.x_fit_vals<=val,1,'last');
                tuning_curve.model_fit.curve(ind+1:end) = NaN;
            end
        otherwise
            tuning_curve.model_fit = [];
    end
end



