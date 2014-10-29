function sorted_spikes = time_shift_sorted_spikes(sorted_spikes,bv_sync)

for ij = 1:numel(sorted_spikes)
	trial_ids = unique(sorted_spikes{ij}.trial_num);
	for ik = 1:length(trial_ids)
		sorted_spikes{ij}.ephys_time(sorted_spikes{ij}.trial_num == trial_ids(ik)) = sorted_spikes{ij}.ephys_time(sorted_spikes{ij}.trial_num == trial_ids(ik)) - bv_sync.start_time(trial_ids(ik));
		sorted_spikes{ij}.bv_index(sorted_spikes{ij}.trial_num == trial_ids(ik)) = bv_sync.ephys2bv{trial_ids(ik)}(sorted_spikes{ij}.ephys_index(sorted_spikes{ij}.trial_num == trial_ids(ik)));
	end
end