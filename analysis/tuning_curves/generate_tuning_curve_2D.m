function tuning_curve = generate_tuning_curve_2D(roi_id,stim_type_name_1,stim_type_name_2,keep_type_name,trial_range)


global session_bv;
global session_ca;

scim_frames = logical(session_bv.data_mat(24,:));

	global handles_roi_ts
                switch handles_roi_ts.type
                    case 'dff'
                        respones_vect = session_ca.dff(roi_id,:);
                    case 'events'
                        respones_vect = session_ca.events(roi_id,:);
                    case 'event_dff'
                        respones_vect = session_ca.event_dff(roi_id,:);
                    case 'raw'
                        respones_vect = session_ca.rawRoiData(roi_id,:);
                    case 'deconv'
      					caES = session_ca.event_array{roi_id};
                        rescale = 5;
                        caES.decayTimeConstants = caES.decayTimeConstants/rescale;
                        respones_vect = getDffVectorFromEvents(caES, session_ca.time, 2);
                        caES.decayTimeConstants = caES.decayTimeConstants*rescale;
          		    case 'neuropil'
                        respones_vect = session_ca.neuropilData(roi_id,:);
                    otherwise
                        respones_vect = session_ca.dff(roi_id,:);
                end

[regMat regVect regressor_obj_1 keep_obj] = get_full_regression_vars(stim_type_name_1,keep_type_name,trial_range);
regVect_1 = regVect(scim_frames);
num_groups_1 = regressor_obj_1.num_groups;
[regMat regVect regressor_obj_2 keep_obj] = get_full_regression_vars(stim_type_name_2,keep_type_name,trial_range);
regVect_2 = regVect(scim_frames);
num_groups_2 = regressor_obj_2.num_groups;


% if strcmp(keep_type_name,'openloop')
%  iti_vect = session_bv.data_mat(9,scim_frames);
%  tmp = session_bv.data_mat(25,:);
%  % correction for bug in anm0227254 data
%  if iti_vect(1) == 0
%   tmp = [tmp(501:end),repmat(tmp(end),1,501)];
%   end
%  trial_num_vect = tmp(scim_frames);
%  respones_vect = subtract_iti_dff(respones_vect,iti_vect,trial_num_vect);
% end


tuning_curve = get_tuning_curve_2D(regVect_1,num_groups_1,regVect_2,num_groups_2,respones_vect);
tuning_curve.x_vals = regressor_obj_2.x_vals;
tuning_curve.x_fit_vals = regressor_obj_2.x_fit_vals;
tuning_curve.x_label = regressor_obj_2.x_label;
tuning_curve.x_range = regressor_obj_2.x_range;
tuning_curve.y_vals = regressor_obj_1.x_vals;
tuning_curve.y_label = regressor_obj_1.x_label;
tuning_curve.y_range = regressor_obj_1.x_range;
tuning_curve.y_fit_vals = regressor_obj_1.x_fit_vals;

tuning_curve.z_label = regressor_obj_1.y_label;

model_fit = 1;
if model_fit
    full_x = [];
	full_y = [];
	full_z = [];
	for ij = 1:length(tuning_curve.x_vals)
		for ik = 1:length(tuning_curve.y_vals)
			full_x = [full_x;repmat(tuning_curve.x_vals(ij),length(tuning_curve.data{ik,ij}),1)];
			full_y = [full_y;repmat(tuning_curve.y_vals(ik),length(tuning_curve.data{ik,ij}),1)];
			full_z = [full_z;tuning_curve.data{ik,ij}'];
		end
	end

	mean_vals = nanmean(tuning_curve.means)';
	baseline = prctile(mean_vals,10);
	weight = mean_vals - baseline;
	mod_depth = max(weight(:));
    %weight = abs(weight);
	weight = weight/sum(weight);
	tuned_val = sum(weight.*tuning_curve.x_vals);
	initPrs = [tuned_val, 1, 0, 1, mod_depth, baseline];
	%initPrs = [tuned_val, 10, 5, 10, mod_depth, baseline];
	tuning_curve.model_fit = fitGS2D(full_x,full_y,full_z,initPrs);
	[X Y] = meshgrid(tuning_curve.x_fit_vals,tuning_curve.y_fit_vals);
	X = X(:);
	Y = Y(:);	
	Z = fitGS2D_modelFun(X,Y,tuning_curve.model_fit.estPrs);
	tuning_curve.model_fit.curve = reshape(Z,length(tuning_curve.x_fit_vals),length(tuning_curve.y_fit_vals));
else
	tuning_curve.model_fit = [];
end

 tuning_curve.title = ['ROI ' num2str(roi_id)];
