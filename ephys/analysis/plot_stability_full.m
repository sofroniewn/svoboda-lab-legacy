function plot_stability_full(clust_id,sorted_spikes,behaviour_vector)

screen_size = get(0,'ScreenSize');
screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
screen_position_across = [1, screen_size(4)*2/3, screen_size(4)/3, screen_size(4)/3];

trials = sorted_spikes{clust_id}.spike_inds(:,1);
[y x] = hist(trials,min(trials):max(trials));
num_chan = size(sorted_spikes{clust_id}.spike_waves,3);
waveform_full = sorted_spikes{clust_id}.spike_waves(:,:,(num_chan+1)/2);
waveform_amp = range(waveform_full,2);
waveform_amp = waveform_amp-min(waveform_amp);
waveform_amp = waveform_amp/max(waveform_amp)*max(y) + max(y)*1.2;




figure(82);
clf(82)
hold on
bar(x,y);
xlim([min(trials) max(trials)]);
plot(trials, waveform_amp,'.k');

if isempty(behaviour_vector) ~=1
	behaviour_trials = [1:length(behaviour_vector)];
	plot(behaviour_trials,behaviour_vector,'r','LineWidth',2)
end