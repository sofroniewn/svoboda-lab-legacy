

ih = 2;
ij = 1;

% ih = 2;
% ij = 3;

    tuning_curve = all_anm{ih}.d.summarized_cluster{ij}.TOUCH_TUNING;


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

baseline = mean(tuning_curve.model_fit.curve(45:end));
%[pks loc] = findpeaks(tuning_curve.model_fit.curve);
%[pksm locm] = findpeaks(-tuning_curve.model_fit.curve);
[pks loc] = max(tuning_curve.model_fit.curve);
[pksm locm] = min(tuning_curve.model_fit.curve);

figure(22)
clf(22)
plot_tuning_curve_ephys([],tuning_curve)
plot([0 30],[baseline baseline],'r','linewidth',2)
plot(tuning_curve.regressor_obj.x_fit_vals(loc),tuning_curve.model_fit.curve(loc),'.g','MarkerSize',20)
plot(tuning_curve.regressor_obj.x_fit_vals(locm),tuning_curve.model_fit.curve(locm),'.r','MarkerSize',20)

x = tuning_curve.model_fit.curve';
thresh = 0;
max_min = 1;
plot_on = 1;

y = persistence_diagram(x,thresh,max_min,plot_on);

%     baseline = prctile(tuning_curve.means,10);
%     weight = tuning_curve.means - baseline;
%     mod_depth = max(weight);
%     %weight = abs(weight);
%     weight = weight/sum(weight);
%     tuned_val = sum(weight.*tuning_curve.regressor_obj.x_vals);
    
    
% %    full_y = full_y - baseline;
%             initPrs = [tuned_val, 1, mod_depth, tuned_val, 1, 0 baseline];
%             tuning_curve.model_fit = fitDoubleGauss(full_x,full_y,initPrs);
%             tuning_curve.model_fit.curve = fitDoubleGauss_modelFun(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit.estPrs);
%             tuning_curve.model_fit.estPrs



  
%plot(tuning_curve.regressor_obj.x_fit_vals,tmp,'g','linewidth',2)


