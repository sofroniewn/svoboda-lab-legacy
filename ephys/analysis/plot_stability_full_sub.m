function [h_ax_rast h_ax_bv] = plot_stability_full(fig_id,clust_id,sorted_spikes,behaviour_vector,trial_range)

%[h_ax_rast h_ax_bv] = plot_stability_full_sub(1000*(dir_num-1)+30,clust_id,sorted_spikes,behaviour_vector,trial_range)
%axes(h_ax_bv)
%ylabel('Mean run speed (cm/s)')
%ylim([0 30])

% screen_size = get(0,'ScreenSize');
% screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
% screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
% screen_position_across = [1, screen_size(4)*2/3, screen_size(4)/3, screen_size(4)/3];

trials = sorted_spikes{clust_id}.trial_num;

[y x] = hist(trials,min(trials):max(trials));
waveform_amp = sorted_spikes{clust_id}.spike_amp;
waveform_amp = waveform_amp-min(waveform_amp);
waveform_amp = waveform_amp/max(waveform_amp)*max(y) + max(y)*1.2;

if isempty(behaviour_vector)

figure(fig_id);
clf(fig_id)
hold on
set(gcf,'Position',[385   634   384   358])
h_ax_rast = gca;
h_ax_bv = [];
bar(x,y);
xlim([min(trials) max(trials)]);
plot(trials, waveform_amp,'.k');
title(['Cluster Id ' num2str(clust_id)])
xlabel('Trial Number')
ylabel('Firing rate (Hz)')
xlim([min(trial_range) max(trial_range)])

else
	figure(fig_id);
	clf(fig_id)
set(gcf,'Position',[385   634   384   358])
h_ax_rast = axes('Position',[.13 .4 .775 .55]);
hold on

bar(x,y);
xlim([min(trial_range) max(trial_range)])
plot(trials, waveform_amp,'.k');
title(['Cluster Id ' num2str(clust_id)])
ylabel('Firing rate (Hz)')
h_ax_bv = axes('Position',[.13 .1 .775 .25]);
hold on
behaviour_trials = [1:length(behaviour_vector)];
plot(behaviour_trials,behaviour_vector,'r','LineWidth',2)
xlabel('Trial Number')
xlim([min(trial_range) max(trial_range)])

end
