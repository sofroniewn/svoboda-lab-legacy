function plot_evoked_spike_probability(fig_id,clustnum,sorted_spikes,trial_range,laser_data)

spike_times = sorted_spikes{clustnum}.ephys_time;
trials = sorted_spikes{clustnum}.trial_num;

spike_times(~ismember(trials,trial_range)) = [];
trials(~ismember(trials,trial_range)) = [];


first_only = 0;
if first_only
	min_time = -.25;
	max_time = 2.25;
else
	min_time = -20/1000;
	max_time = 80/1000;
end

figure(fig_id)
clf(fig_id)
hold on
set(gcf,'Position',[13   192   556   348])

trial_tmp = [];
spike_times_all = [];
ind_rep_all = [];

onset_times_all = [];
onset_reps_all = [];
offset_times_all = [];
offset_reps_all = [];

n_rep = 0;
for i_trial = min(trials):max(trials)
    n_trial = find(laser_data.trial == i_trial);
    if ~isempty(n_trial)
    	if ~isempty(laser_data.onset_times{n_trial})
		    spike_times_trial = spike_times(trials==i_trial)';
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
bar(time,psth,'k');
plot([onset_times_all offset_times_all]',[onset_reps_all/10+ceil(max(psth))+20 onset_reps_all/10+ceil(max(psth))+20]','-','Color','c')
%plot(offset_times_all,offset_reps_all/10+ceil(max(psth))+20,'.','Color','c')
plot(spike_times_all,ind_rep_all/10+ceil(max(psth))+20,'.','Color','k')

xlim([min_time max_time])





