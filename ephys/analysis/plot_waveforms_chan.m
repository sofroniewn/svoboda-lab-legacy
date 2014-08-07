function plot_waveforms_chan(fig_id,clust_id,sorted_spikes,trial_range,type)

% screen_size = get(0,'ScreenSize');
% screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
% screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
% screen_position_across = [1, screen_size(4)*2/3, screen_size(3), screen_size(4)/3];

spike_wave_detect = sorted_spikes{clust_id}.spike_waves;
trials = sorted_spikes{clust_id}.trial_num;

spike_wave_detect(~ismember(trials,trial_range),:) = [];
trials(~ismember(trials,trial_range)) = [];



detected_ch = sorted_spikes{clust_id}.detected_chan;

%nspk = size(spike_wave_detect,1);
%nchan = 1;
%nwind = size(spike_wave_detect,2);
time_vect = ([1:53]-20)/20833.33/2*1000;

if strcmp(type,'avg')
    figure(fig_id)
    clf(fig_id)
    set(gcf,'Position',[1554         637         362         358])
    hold on
    avg_spk = mean(spike_wave_detect);
    std_spk = std(spike_wave_detect);
    plot(time_vect,spike_wave_detect','Color','b','LineWidth',0.5)
    plot(time_vect,avg_spk,'Color','r','LineWidth',2)
    plot(time_vect,avg_spk + std_spk,'Color','c','LineWidth',1)
    plot(time_vect,avg_spk - std_spk,'Color','c','LineWidth',1)
    
    time_vect_interp = ([1:.2:53]-20)/20833.33/2*1000;
    avg_spk_interp = spline(time_vect,avg_spk,time_vect_interp);

    [min_avg ind_min] = min(avg_spk_interp);
    ind_first_half_min = find(avg_spk_interp<min_avg/2,1,'first');
    ind_second_half_min = find(avg_spk_interp<min_avg/2,1,'last')+1;
    tau_1 = time_vect_interp(ind_min) - time_vect_interp(ind_first_half_min);
    tau_2 = time_vect_interp(ind_second_half_min) - time_vect_interp(ind_min);
   
    [max_avg ind_first_max] = max(avg_spk_interp(1:ind_min));
    [max_avg ind_second_max] = max(avg_spk_interp(ind_min:end));
    ind_second_max = ind_second_max + ind_min-1;
    tau_3 = time_vect_interp(ind_second_max) - time_vect_interp(ind_first_max);
    
    %plot(time_vect_interp,avg_spk_interp,'Color','g','LineWidth',2)
    
    text(.7*(time_vect(end)),-180,sprintf('t1 %.0f us',1000*tau_1))
    text(.7*(time_vect(end)),-220,sprintf('t2 %.0f us',1000*tau_2))
    text(.7*(time_vect(end)),-260,sprintf('t3 %.0f us',1000*tau_3))
    text(.7*(time_vect(end)),-300,sprintf('Max %.0f uV',min(avg_spk_interp)))
 
else
    figure(fig_id+1)
    clf(fig_id+1)
    set(gcf,'Position',[10   285   362   258])
    hold on
    plot(time_vect,spike_wave_detect','Color','b')
end
%plot(0,-.35*10^(-3),'.k','MarkerSize',30)
title(['Cluster Id ' num2str(clust_id)])
xlim([time_vect(1) 1.2*(time_vect(end))])
ylim([-500 150])
set(gca,'ytick',[-400:100:100])
xlabel('Time (ms)')
ylabel('Amplitude (uV)')

%set(gca,'position',[ 0.05    0.1100    0.90    0.815])
%xlim([1-.5-(nchan+1)/2 nchan+.5-(nchan+1)/2])
%ylim([-.41 .21]*10^(-3))
