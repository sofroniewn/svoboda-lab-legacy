function [start_ind start_time ephys_inds ephys_time] = extract_behaviour_triggers(d)

	start_ind = find(d.Trigger_allCh>.5,1,'first');
	clock_ticks = d.allOther_allCh(:,2) > .5;
	ephys_inds = 1+find(diff(clock_ticks) == 1);

	[val start_ind] = min(abs(ephys_inds - start_ind));
	start_time = d.TimeStamps(ephys_inds(start_ind));
	ephys_time = d.TimeStamps(ephys_inds);