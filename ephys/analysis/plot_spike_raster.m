function plot_spike_raster(clustnum,sorted_spikes,trial_range)

spike_times = sorted_spikes{clustnum}.ephys_time;
trials = sorted_spikes{clustnum}.trial_num;

spike_times(trials < trial_range(1)) = [];
trials(trials < trial_range(1)) = [];
spike_times(trials > trial_range(2)) = [];
trials(trials > trial_range(2)) = [];

figure(14)
clf(14)
hold on

trial_tmp = [];
spike_times_psth = {};
n_trial = 0;
for i_trial = min(trials):max(trials)
    n_trial = n_trial+1;
    spike_times_psth{n_trial,1} = spike_times(trials==i_trial)';
end
[psth t] = func_getPSTH(spike_times_psth,min(spike_times),max(spike_times));
bar(t(10:end-10),psth(10:end-10),'k');
max_psth = max(psth(10:end-10));
plot(spike_times,trials/max(trials)*max_psth+max_psth*1.2,'.k')
xlim([min(spike_times) max(spike_times)])

return




function [PSTH time] = func_getPSTH(SpikeTimes, PSTH_StartTime, PSTH_EndTime)

time = PSTH_StartTime:.001:PSTH_EndTime;


n_rep = size(SpikeTimes,1);
total_counts = 0;
for i_rep = 1:n_rep
    
    [counts] = hist(SpikeTimes{i_rep,1},PSTH_StartTime:0.001:PSTH_EndTime);
    total_counts = total_counts+counts/n_rep;
    
end

avg_window = ones(1,50)/0.05;
PSTH = conv(total_counts,avg_window,'same');

time = time(21:end-20);
PSTH = PSTH(21:end-20);

return


