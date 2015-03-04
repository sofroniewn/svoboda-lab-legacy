function tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh,regressor_tune_type);

constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
regressor_obj = define_regression_var_ephys(stim_name,run_thresh);

time_range_inds = floor([d.samp_rate*time_range(1):d.samp_rate*time_range(2)])+1;
time_range_inds(time_range_inds>size(d.r_ntk,2)) = [];

responseVar = d.r_ntk(clust_id,time_range_inds,keep_trials);
%responseVar = squeeze(mean(responseVar,2));
responseVar = d.samp_rate*responseVar(:);

label = regressor_obj.var_tune;
s_ind = find(strcmp(d.s_labels,regressor_obj.var_tune));
if isempty(s_ind)
    error('WGNR :: could not find s label for regression')
end

tmp = d.s_ctk(s_ind,time_range_inds,keep_trials);
if s_ind == 8;
    tmp = tmp - min(tmp(:));
    tmp = tmp/max(tmp(:))*30;
end

%tmp = squeeze(mean(tmp,2));
regressor_obj.var_tune = tmp(:);

[regMat regVect] = get_regression_mat(regressor_obj);
num_groups = regressor_obj.num_groups;
tuning_curve = get_tuning_curve(regVect,num_groups,responseVar);

regressor_obj.var_tune = label;
tuning_curve.regressor_obj = regressor_obj;

fit_model_on = 1;

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
    
    
    switch regressor_tune_type %regressor_obj.tune_type
        case 'Gauss'
            initPrs = [tuned_val, 1, mod_depth, baseline];
            tuning_curve.model_fit = fitGauss(full_x,full_y,initPrs);
            tuning_curve.model_fit.curve = fitGauss_modelFun(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit.estPrs);
        case 'BiGauss'
            full_x = tuning_curve.regressor_obj.x_vals;
            full_y = tuning_curve.means;
            baseline = nanmean(full_y(full_x>22));
            weight = tuning_curve.means - baseline;
            [mod_depth_up ind_up] = max(weight);
            [mod_depth_down ind_down] = min(weight);
            vals = tuning_curve.regressor_obj.x_vals;
            full_y = full_y - baseline;
            if mod_depth_up > -mod_depth_down
                initPrs = [vals(ind_up), 1, mod_depth_up 0];
            else
                initPrs = [vals(ind_down), 1, mod_depth_down 0];
            end
            tuning_curve.model_fit = fitBiGauss(full_x,full_y,initPrs);
            tuning_curve.model_fit.curve = baseline + fitBiGauss_modelFun(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit.estPrs);
 case 'DoubleGauss'
            full_x = tuning_curve.regressor_obj.x_vals;
            full_y = tuning_curve.means;
            baseline = nanmean(full_y(full_x>22));
            weight = tuning_curve.means - baseline;
            [mod_depth_up ind_up] = max(weight);
            [mod_depth_down ind_down] = min(weight);
            vals = tuning_curve.regressor_obj.x_vals;
            full_y = full_y - baseline;
            initPrs = [vals(ind_up), 1, mod_depth_up, 0, vals(ind_down), 1, -mod_depth_down, 0];
            tuning_curve.model_fit = fitDoubleGauss(full_x,full_y,initPrs);
            tuning_curve.model_fit.curve = baseline + fitDoubleGauss_modelFun(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit.estPrs);
        case 'Sigmoid'
            initPrs = [];
            tuning_curve.model_fit = fitSigmoid(full_x,full_y,initPrs);
            tuning_curve.model_fit.curve = fitSigmoid_modelFun(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit.estPrs);
        case 'DoubleSigmoid'
            initPrs = [];
%baseline = prs(1);
%gain = prs(2);
%weight = prs(3);
%center_1 = prs(4);
%scale_1 = prs(5);
%center_2 = prs(6);
%scale_2 = prs(7);
            %max(full_x(:))full_

           if s_ind == 8;
            baseline = nanmean(full_y(full_x<=10))
            else
            baseline = nanmean(full_y(full_x>22))
            end
            
            weight = tuning_curve.means - baseline;
            [mod_depth_up ind_up] = max(weight);
            [mod_depth_down ind_down] = min(weight);
            vals = tuning_curve.regressor_obj.x_vals;
            initPrs = [baseline mod_depth_up 0 vals(ind_up) 1 vals(ind_down), 1];
            tuning_curve.model_fit = fitDoubleSigmoid(full_x,full_y,initPrs);
            tuning_curve.model_fit.curve = fitDoubleSigmoid_modelFun(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit.estPrs);
        case 'Smooth'
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
        otherwise
            tuning_curve.model_fit = [];
    end
end




