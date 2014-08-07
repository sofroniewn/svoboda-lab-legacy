function plot_behaviour_corr(fig_id,clust_id,sorted_spikes,behaviour_vector,trial_range,time_range,color_vector)

% screen_size = get(0,'ScreenSize');
% screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
% screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
% screen_position_across = [1, screen_size(4)*2/3, screen_size(4)/3, screen_size(4)/3];


spike_times = sorted_spikes{clust_id}.ephys_time;
trials = sorted_spikes{clust_id}.trial_num;

spike_times(~ismember(trials,trial_range)) = [];
trials(~ismember(trials,trial_range)) = [];

spike_times(spike_times>time_range(2) & spike_times<time_range(1)) = [];


tot_spikes = NaN(length(trial_range),1);
behav_var = NaN(length(trial_range),1);
color_vector_trial = NaN(length(trial_range),1);
for i_trial = 1:length(trial_range)
    spike_times_trial = spike_times(trials == trial_range(i_trial))';
	tot_spikes(i_trial) = length(spike_times_trial)/diff(time_range);
	behav_var(i_trial) = behaviour_vector(trial_range(i_trial));
	color_vector_trial(i_trial) = color_vector(trial_range(i_trial));
end


figure(fig_id);
clf(fig_id)
set(gcf,'Position',[22   555   988   251])
subplot(1,3,1)
hold on
scatter(behav_var, tot_spikes,[],color_vector_trial,'fill');

title(['Cluster Id ' num2str(clust_id)])
%xlabel('Trial Number')
ylabel('Firing rate')

subplot(1,3,2)
hold on
%plot(behav_var, tot_spikes,'.k');
%scatter(behav_var, tot_spikes,[],color_vector_trial,'fill');
%plot(color_vector_trial,behav_var,'.k');
scatter(color_vector_trial,behav_var,[],tot_spikes,'fill');

title(['Cluster Id ' num2str(clust_id)])
%xlabel('Trial Number')
%ylabel('Firing rate')

subplot(1,3,3)
hold on
%plot(behav_var, tot_spikes,'.k');
%scatter(behav_var, tot_spikes,[],color_vector_trial,'fill');
%plot(color_vector_trial,behav_var,'.k');
scatter(color_vector_trial,tot_spikes,[],behav_var,'fill');

title(['Cluster Id ' num2str(clust_id)])



