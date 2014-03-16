function rasterViewer_POWERS(clustnum,spikes_power,sort_vect,handles,col_mat)

global clustattrib;
global clustdata;
global figattrib;






figure(2);clf(2); hold on
trials_start = 100;
prev_trials = 0;
max_psth = 0;
for i_power = 1:size(spikes_power,1)
i_spk = spikes_power{i_power,clustnum};
spike_times = clustdata.customvar.spiketimes(i_spk);
trials = clustdata.customvar.trials(i_spk);
unique_trials = unique(trials);
%indv_sort_vect = sort_vect(unique_trials);
%[a sorted_data] = sort(indv_sort_vect,'descend');
length(unique_trials)
trial_tmp = [];
spike_times_psth = {};
n_trial = 0;
for i_trial = 1:length(unique_trials)
    n_trial = n_trial+1;
    spike_times_psth{n_trial,1} = spike_times(trials == unique_trials(i_trial))';
    trials(trials == unique_trials(i_trial)) = i_trial; % = sorted_data(i_trial);    
end
[psth t] = func_getPSTH(spike_times_psth,0,5);
plot(t(10:end-10),psth(10:end-10),'LineWidth',2,'Color',col_mat(i_power,:));
max_psth = max(max_psth,max(psth(10:end-10)));
end

trials_start = 100;
prev_trials = 0;
for i_power = 1:size(spikes_power,1)
i_spk = spikes_power{i_power,clustnum};
spike_times = clustdata.customvar.spiketimes(i_spk);
trials = clustdata.customvar.trials(i_spk);
unique_trials = unique(trials);
%indv_sort_vect = sort_vect(unique_trials);
%[a sorted_data] = sort(indv_sort_vect,'descend');
trial_tmp = [];
spike_times_psth = {};
n_trial = 0;
for i_trial = 1:length(unique_trials)
    n_trial = n_trial+1;
    spike_times_psth{n_trial,1} = spike_times(trials == unique_trials(i_trial))';
    trials(trials == unique_trials(i_trial)) = i_trial; % = sorted_data(i_trial);    
end
[psth t] = func_getPSTH(spike_times_psth,0,5);
plot(t(10:end-10),psth(10:end-10),'LineWidth',2,'Color',col_mat(i_power,:));

%trials = trials-min(trials);
plot(spike_times,(prev_trials+trials)*100/max(clustdata.customvar.trials)+10+round(10*max_psth)/10,'.','Color',col_mat(i_power,:))
prev_trials = prev_trials + max(trials) + 1;
end

xlim([0 5])
ylim([0 100+10+round(10*max_psth)/10+10])

return




function [PSTH time] = func_getPSTH(SpikeTimes, PSTH_StartTime, PSTH_EndTime)

% 
% SpikeTimes -- {n_rep,1}
% 

if nargin == 1
    PSTH_StartTime = -.52;
    PSTH_EndTime = 5.020;
end

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


