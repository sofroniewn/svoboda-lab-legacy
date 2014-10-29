function d = convert_rsu_format(sorted_spikes,session,trial_range,group_ids,groups,max_length_trial)

num_clusters = numel(sorted_spikes);

keep_trials = find(ismember(groups,group_ids));
keep_trials(~ismember(keep_trials,trial_range)) = [];

d.s_labels = {'wall_pos';'wall_vel';'speed';'lateral_speed';'forward_speed';'run_angle';'whisker_amp';'laser_power'};
d.u_labels = {'group_id';'mean_speed';'trial_length';'trial_duration';'whisker_data';'laser_power';'trial_num'};

d.r_ntk = zeros(num_clusters,max_length_trial,length(keep_trials));
d.s_ctk = zeros(length(d.s_labels),max_length_trial,length(keep_trials));
d.u_ck = zeros(length(d.u_labels),length(keep_trials));
d.t = [0:max_length_trial-1]/session.rig_config.sample_freq;
d.samp_rate = session.rig_config.sample_freq;

i_ind = 0;
for i_group = 1:length(group_ids)
 	trial_id = find(groups == group_ids(i_group));
	trial_id = trial_id(ismember(trial_id,keep_trials));
	for i_trial = 1:length(trial_id)
		i_ind = i_ind + 1;
		start_ind = session.trial_info.trial_start(trial_id(i_trial));
    	cur_trial_length = min(max_length_trial,length(session.data{trial_id(i_trial)}.trial_matrix(1,start_ind:end)));
		for cluster_id = 1:num_clusters
    		spike_bv_inds = sorted_spikes{cluster_id}.bv_index;
			trials = sorted_spikes{cluster_id}.trial_num;
    		%spike_times = sorted_spikes{cluster_id}.ephys_time;
	    	%spike_times_psth = spike_times(trials == trial_id(i_trial))';
	    	%spike_times_ind = round(spike_times_psth*session.rig_config.sample_freq);
			spike_times_ind = spike_bv_inds(trials == trial_id(i_trial))';
			spike_times_ind(spike_times_ind<1) = [];
			spike_times_ind(spike_times_ind>cur_trial_length) = [];	
        	hist_vals = accumarray(spike_times_ind',ones(size(spike_times_ind')),[cur_trial_length 1]);
			d.r_ntk(cluster_id,1:cur_trial_length,i_ind) = hist_vals;
		end
		
		d.s_ctk(1,1:cur_trial_length,i_ind) = session.data{trial_id(i_trial)}.trial_matrix(3,start_ind:(start_ind+cur_trial_length-1));
 		d.s_ctk(4,1:cur_trial_length,i_ind) = session.rig_config.sample_freq*smooth(session.data{trial_id(i_trial)}.trial_matrix(1,start_ind:(start_ind+cur_trial_length-1)),25,'sgolay',1);
 		d.s_ctk(5,1:cur_trial_length,i_ind) = session.rig_config.sample_freq*smooth(session.data{trial_id(i_trial)}.trial_matrix(2,start_ind:(start_ind+cur_trial_length-1)),25,'sgolay',1);
 		d.s_ctk(2,1:cur_trial_length,i_ind) = session.data{trial_id(i_trial)}.processed_matrix(9,start_ind:(start_ind+cur_trial_length-1));
 		d.s_ctk(3,:,i_ind) = sqrt(d.s_ctk(4,:,i_ind).^2 + d.s_ctk(5,:,i_ind).^2);
 		d.s_ctk(6,:,i_ind) = atan2(d.s_ctk(4,:,i_ind),d.s_ctk(5,:,i_ind))*180/pi;

		d.u_ck(1,i_ind) = group_ids(i_group);
		d.u_ck(2,i_ind) = session.trial_info.mean_speed(trial_id(i_trial));
		d.u_ck(3,i_ind) = session.trial_info.length(trial_id(i_trial));
		d.u_ck(4,i_ind) = session.trial_info.time(trial_id(i_trial));
		d.u_ck(7,i_ind) = trial_id(i_trial);
		if isfield(session.trial_info,'whisker_data')
			d.u_ck(5,i_ind) = session.trial_info.whisker_data(trial_id(i_trial));
		 	d.s_ctk(7,1:cur_trial_length,i_ind) = session.data{trial_id(i_trial)}.processed_matrix(10,start_ind:(start_ind+cur_trial_length-1));
		else
			d.u_ck(5,i_ind) = 0;
        end
            tmp = session.data{trial_id(i_trial)}.trial_matrix(5,start_ind:(start_ind+cur_trial_length-1));
            tmp_conv = conv(tmp,ones(50,1));
		 	d.s_ctk(8,1:cur_trial_length,i_ind) = round((0.5-tmp_conv(1:length(tmp)))*60);
            
		if ismember(d.u_ck(1,i_ind),8:13)            
            max_power = 0.1+session.trial_info.max_laser_power(trial_id(i_trial));
            tmp_vect = zeros(2001,1);
            tmp_vect(1:500) = linspace(0,max_power,500);
            tmp_vect(501:1500) = max_power;
            tmp_vect(1501:2000) = linspace(max_power,0,500);
		 	try
		 		d.s_ctk(8,1:cur_trial_length,i_ind) = round((0.6-tmp_vect)*50);
			catch
			end
		end

			d.u_ck(5,i_ind) = session.trial_info.max_laser_power(trial_id(i_trial));
	end
end

