function RASTER = get_evoked_spike_probability(spike_times,spike_trials,trial_range,laser_data,first_only)
% Computes spike raster and psth

spike_times(~ismember(spike_trials,trial_range)) = [];
spike_trials(~ismember(spike_trials,trial_range)) = [];


if first_only
	min_time = -.25;
	max_time = 2.25;
else
	min_time = -20/1000;
	max_time = 80/1000;
end

trial_tmp = [];
spike_times_all = [];
ind_rep_all = [];

onset_times_all = [];
onset_reps_all = [];
offset_times_all = [];
offset_reps_all = [];

n_rep = 0;
for i_trial = min(spike_trials):max(spike_trials)
    n_trial = find(laser_data.trial == i_trial);
    if ~isempty(n_trial)
    	if ~isempty(laser_data.onset_times{n_trial})
		    spike_times_trial = spike_times(spike_trials==i_trial)';
		    if first_only
		    	tmp = spike_times_trial - laser_data.onset_times{n_trial}(1);
		    	tmp = tmp(tmp>min_time & tmp < max_time);
	    		n_rep = n_rep+1;
		    	spike_times_all = [spike_times_all;tmp'];
		    	ind_rep_all = [ind_rep_all;repmat(n_rep,length(tmp),1)];
		    	tmp = laser_data.onset_times{n_trial} - laser_data.onset_times{n_trial}(1);
		    	onset_times_all = [onset_times_all;tmp];
		    	onset_reps_all = [onset_reps_all;repmat(n_rep,length(tmp),1)];
		    	tmp = laser_data.offset_times{n_trial} - laser_data.onset_times{n_trial}(1);
		    	offset_times_all = [offset_times_all;tmp];
		    	offset_reps_all = [offset_reps_all;repmat(n_rep,length(tmp),1)];
		    else
			    for ij = 1:length(laser_data.onset_inds{n_trial})
		    		tmp = spike_times_trial - laser_data.onset_times{n_trial}(ij);
			    	tmp = tmp(tmp>min_time & tmp < max_time);
	    			n_rep = n_rep+1;
		    		spike_times_all = [spike_times_all;tmp'];
		    		ind_rep_all = [ind_rep_all;repmat(n_rep,length(tmp),1)];
			    	onset_times_all = [onset_times_all;0];
			    	onset_reps_all = [onset_reps_all;n_rep];
			    	offset_times_all = [offset_times_all;laser_data.offset_times{n_trial}(ij) - laser_data.onset_times{n_trial}(ij)];
			    	offset_reps_all = [offset_reps_all;n_rep];
			    end
			end
		end
	end
end

time = min_time:.001:max_time;
psth = hist(spike_times_all,time);

RASTER.spikes = cell(1,1);
RASTER.trials = cell(1,1);

RASTER.time_range = [min_time max_time];
RASTER.spikes{1} = spike_times_all;
RASTER.trials{1} = ind_rep_all;
RASTER.psth = psth;
RASTER.time = time;

RASTER.trial_range = [1 n_rep];

RASTER.laser_on = [onset_times_all offset_times_all]';
RASTER.laser_on_trial = [onset_reps_all onset_reps_all]';

