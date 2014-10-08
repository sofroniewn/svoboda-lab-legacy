function [ps curves] = extract_additional_ephys_vars(all_anm)

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

add_labels = {'no_walls_still_rate';'no_walls_run_rate';'touch_baseline_rate';'touch_peak_rate';'touch_min_rate';'touch_mean_rate';'touch_max_loc';'touch_min_loc';'num_trials'};
add_vec = zeros(size(p,1),numel(add_labels));
ik = 0
for ih = 1:numel(all_anm)
        anm_id = num2str(all_anm{ih}.d.p_nj(1,1)); 
        [base_dir trial_range_start exp_type layer_4] = ephys_anm_id_database(anm_id,0);
 for ij = 1:numel(all_anm{ih}.d.summarized_cluster)
 	ik = ik+1;

 	[ih numel(all_anm) ij numel(all_anm{ih}.d.summarized_cluster)]

	add_vec(ik,1:2) = all_anm{ih}.d.summarized_cluster{ij}.RUNNING_MOD.means;

    tuning_curve = all_anm{ih}.d.summarized_cluster{ij}.TOUCH_TUNING;
    
    full_x = [];
    full_y = [];
    for ij = 1:length(tuning_curve.regressor_obj.x_vals)
        full_x = [full_x;repmat(tuning_curve.regressor_obj.x_vals(ij),length(tuning_curve.data{ij}),1)];
        full_y = [full_y;tuning_curve.data{ij}];
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

       
       constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type);
       keep_trials = apply_trial_constraints(all_anm{ih}.d.u_ck,all_anm{ih}.d.u_labels,constrain_trials);


	    add_vec(ik,3:end) = [baseline pks pksm mean_rate loc locm sum(keep_trials)];

  end
end

p = cat(2,p,add_vec);
p_labels = [p_labels;add_labels];


add_labels = {'adapt'};
add_vec = zeros(size(p,1),numel(add_labels));
curves.onset = zeros(size(p,1),length(tuning_curve.model_fit.curve));
curves.offset = zeros(size(p,1),length(tuning_curve.model_fit.curve));
ik = 0;
for ih = 1:numel(all_anm)
anm_id = num2str(all_anm{ih}.d.p_nj(1,1)); 
[base_dir trial_range_start exp_type layer_4] = ephys_anm_id_database(anm_id,0);
  for ij = 1:numel(all_anm{ih}.d.summarized_cluster)
  [ih numel(all_anm) ij numel(all_anm{ih}.d.summarized_cluster)]
  ik = ik+1;
  time_range = [0 1.5];
  tune_curve = get_tuning_curve_ephys(ij+2,all_anm{ih}.d,stim_name,keep_name,exp_type,id_type,time_range);
  curves.onset(ik,:) = tune_curve.model_fit.curve;
  time_range = [1.5 3];
  tune_curve = get_tuning_curve_ephys(ij+2,all_anm{ih}.d,stim_name,keep_name,exp_type,id_type,time_range);
  curves.offset(ik,:) = tune_curve.model_fit.curve;
  add_vec(ik,:) = [mean(curves.onset(ik,:) - curves.offset(ik,:))];
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

%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
% %% MEAN WAVEFORMS
%
% time_vect = all_anm{1}.d.summarized_cluster{1}.WAVEFORMS.time_vect;
% mean_waves = [];
% mean_waves_sm = [];
% tau_new = [];
% for ih = 1:numel(all_anm)
%   for ij = 1:numel(all_anm{ih}.d.summarized_cluster)
%   	avg_wave = all_anm{ih}.d.summarized_cluster{ij}.WAVEFORMS.avg;
% 	mean_waves = cat(1,mean_waves,avg_wave);
% 	avg_wave = smooth(avg_wave,5,'sgolay',1);
% 	mean_waves_sm = cat(1,mean_waves_sm,avg_wave');
% 	[val ind] = max(avg_wave(20:end));
% 	tau_new = cat(1,tau_new,time_vect(20-1+ind));
% 	end
% end

% norm_waves = bsxfun(@minus,mean_waves,mean(mean_waves(:,1:10),2));
% %norm_waves = mean_waves;
% norm_waves = bsxfun(@rdivide,norm_waves,-min(norm_waves,[],2));

% norm_waves_sm = bsxfun(@minus,mean_waves_sm,mean(mean_waves_sm(:,1:10),2));
% norm_waves_sm = bsxfun(@rdivide,norm_waves_sm,-min(norm_waves_sm,[],2));
