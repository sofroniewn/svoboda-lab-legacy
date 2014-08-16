function [r_ntk s_ctk s_labels u_ck u_labels] = convert_rsu_format(sorted_spikes,session,trial_range,group_ids,groups,max_length_trial)

num_clusters = numel(sorted_spikes);

keep_trials = find(ismember(groups,group_ids));
keep_trials(~ismember(keep_trials,trial_range)) = [];


r_ntk = zeros(num_clusters,max_length_trial,length(keep_trials));
s_ctk = zeros(5,max_length_trial,length(keep_trials));
u_ck = zeros(4,length(keep_trials));

i_ind = 0;
for i_group = 1:length(group_ids)
 	trial_id = find(groups == group_ids(i_group));
	trial_id = trial_id(ismember(trial_id,keep_trials));
	for i_trial = 1:length(trial_id)
		i_ind = i_ind + 1;
		start_ind = session.trial_info.trial_start(trial_id(i_trial));
    	cur_trial_length = min(max_length_trial,length(session.data{trial_id(i_trial)}.trial_matrix(1,start_ind:end)));
		for cluster_id = 1:num_clusters
    		spike_times = sorted_spikes{cluster_id}.ephys_time;
			trials = sorted_spikes{cluster_id}.trial_num;
	    	spike_times_psth = spike_times(trials == trial_id(i_trial))';
			spike_times_ind = round(spike_times_psth*session.rig_config.sample_freq);
			spike_times_ind(spike_times_ind<1) = [];
			spike_times_ind(spike_times_ind>cur_trial_length) = [];	
        	hist_vals = accumarray(spike_times_ind',ones(size(spike_times_ind')),[cur_trial_length 1]);
			r_ntk(cluster_id,1:cur_trial_length,i_ind) = hist_vals;
		end
		
		s_ctk(1,1:cur_trial_length,i_ind) = session.data{trial_id(i_trial)}.trial_matrix(3,start_ind:(start_ind+cur_trial_length-1));
 		s_ctk(4,1:cur_trial_length,i_ind) = session.rig_config.sample_freq*smooth(session.data{trial_id(i_trial)}.trial_matrix(1,start_ind:(start_ind+cur_trial_length-1)),25,'sgolay',1);
 		s_ctk(5,1:cur_trial_length,i_ind) = session.rig_config.sample_freq*smooth(session.data{trial_id(i_trial)}.trial_matrix(2,start_ind:(start_ind+cur_trial_length-1)),25,'sgolay',1);
 		s_ctk(2,1:cur_trial_length,i_ind) = session.data{trial_id(i_trial)}.processed_matrix(9,start_ind:(start_ind+cur_trial_length-1));
 		s_ctk(3,:,i_ind) = sqrt(s_ctk(4,:,i_ind).^2 + s_ctk(5,:,i_ind).^2);

		u_ck(1,i_ind) = i_group;
		u_ck(2,i_ind) = session.trial_info.mean_speed(trial_id(i_trial));
		u_ck(3,i_ind) = session.trial_info.length(trial_id(i_trial));
		u_ck(4,i_ind) = session.trial_info.time(trial_id(i_trial));
	end
end

s_labels = {'wall_pos';'wall_vel';'speed';'lateral_speed';'forward_speed'};
u_labels = {'group_id';'mean_speed';'trial_length';'trial_duration'};
