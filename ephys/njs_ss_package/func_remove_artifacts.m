function spikes_all = func_remove_artifacts(spikes_all,spike_wave,artifact_thresh)
%%
disp(['--------------------------------------------']);
disp(['remove artifacts']);

% Remove artifacts
spikes_all = cat(2,spikes_all,ones(size(spikes_all,1),1));

detection_ch = spikes_all(:,1);
waveform_tmp = zeros(size(spike_wave,1),size(spike_wave,2));
for i_sample = 1:size(spike_wave,2)
    i_tmp = sub2ind(size(spike_wave), 1:size(spike_wave,1), zeros(1,size(detection_ch,1))+i_sample, detection_ch');
    waveform_tmp(:,i_sample) = spike_wave(i_tmp);
end

max_wave = max(waveform_tmp,[],2);
spikes_all(:,5) = max_wave <= artifact_thresh;

disp(['--------------------------------------------']);
