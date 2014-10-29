function SPK_LFP = get_spike_LFP(spike_times_ephys,spike_trials,lfp_data)


spike_phase = NaN(length(spike_times_ephys),1);
trial_nums = unique(spike_trials);

freq_ephys = 4.8*10^(-5);
freq_session = 500;

%spike_times_ephys_inds = round(spike_times_ephys/freq_ephys - 1);
spike_times_ephys_inds = round(spike_times_ephys*freq_session);

%			spike_times_ind = round(spike_times_psth*session.rig_config.sample_freq);
%			spike_times_ind(spike_times_ind<1) = [];
%			spike_times_ind(spike_times_ind>cur_trial_length) = [];	

for ij = 1:length(trial_nums)
	trial_id = trial_nums(ij);
	lfp_ind = find(lfp_data.trial==trial_id);
	lfp_phase = lfp_data.flt_vlt_gamma{lfp_ind};
	lfp_phase = angle(hilbert(lfp_phase));
	inds_trial = spike_trials == trial_id;
	ephys_inds_trial = spike_times_ephys_inds(inds_trial);
    %ephys_inds_trial(ephys_inds_trial > length(lfp_phase)) = [];
    %ephys_inds_trial(ephys_inds_trial < 1) = [];
	lfp_phase = lfp_phase(ephys_inds_trial);
	spike_phase(inds_trial) = lfp_phase;
end

SPK_LFP.spike_phase = spike_phase;
