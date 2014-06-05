function response_vect = subtract_iti_dff(response_vect,iti_vect,trial_num_vect)
	
trial_num_tmp = trial_num_vect(logical(iti_vect));

% deal with legacy data from anm 227254 where iti was at end of trial not beginning
if isempty(find(trial_num_tmp == 1,1,'first'))
	trial_num_tmp(1) = 1;
end

response_tmp = response_vect(logical(iti_vect));

tmp_data = accumarray(trial_num_tmp',response_tmp,[],@mean);

iti_avg_dff = tmp_data(trial_num_vect)';


% figure(5);
% clf(5)
% hold on
% plot(response_vect)
% plot(iti_avg_dff,'g')
% plot(iti_vect,'m')
% global session_bv
% plot(session_bv.data_mat(3,logical(session_bv.data_mat(24,:)))/30,'k')

response_vect = response_vect - iti_avg_dff;

