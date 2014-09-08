function [session] = sync_ephys_behaviour(base_dir,file_list,sync_trigs,session)


for trial_id = 1:numel(session.data)
	start_ind = sync_trigs{trial_id}.start_ind;
	start_ticks = sync_trigs{trial_id}.ephys_inds;
	start_times = sync_trigs{trial_id}.ephys_time;

	num_pre_start = start_ind - 1;
	num_post_start = length(start_ticks) - start_ind;

	start_ind_bv = session.trial_info.trial_start(trial_id);
	
	trig_times = NaN(1,session.trial_info.length(trial_id));
	trig_inds = NaN(1,session.trial_info.length(trial_id));

	pre_take = min(start_ind_bv-1,num_pre_start);
	post_take = min(length(trig_times)-start_ind_bv,num_post_start);
	
	trig_inds(start_ind_bv-pre_take:start_ind_bv+post_take) = start_ticks(start_ind-pre_take:start_ind+post_take);
	trig_times(start_ind_bv-pre_take:start_ind_bv+post_take) = start_times(start_ind-pre_take:start_ind+post_take);

	session.data{trial_id}.processed_matrix(6,:) = trig_inds;
	session.data{trial_id}.processed_matrix(7,:) = trig_times;
end

