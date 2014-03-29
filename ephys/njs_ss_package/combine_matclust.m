function [ch_data switch_trial] = combine_matclust(ch_data_1,ch_data_2)

	switch_trial = max(ch_data_1.customvar.trials)+1;
	display(switch_trial)

	ch_data.params = cat(1,ch_data_1.params,ch_data_2.params);
	ch_data.paramnames = ch_data_1.paramnames;

	ch_data.customvar.waveform = cat(1,ch_data_1.customvar.waveform,ch_data_2.customvar.waveform);
	ch_data.customvar.spiketimes = cat(1,ch_data_1.customvar.spiketimes,ch_data_2.customvar.spiketimes);
	ch_data.customvar.trials = cat(1,ch_data_1.customvar.trials,switch_trial-1+ch_data_2.customvar.trials);
	ch_data.customvar.iCh = cat(1,ch_data_1.customvar.iCh,ch_data_2.customvar.iCh);

	if isfield('switch_trial',ch_data) == 0
		ch_data.switch_trial = switch_trial;
	else
		ch_data.switch_trial = [ch_data.switch_trial;switch_trial];
	end