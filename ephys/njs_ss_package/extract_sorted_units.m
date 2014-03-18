function [sorted_spikes sync_trigs] = extract_sorted_units(base_dir,file_list,sorted_name,overwrite)


f_name_sorted_units = fullfile(base_dir,'ephys','sorted',[sorted_name '.mat']);

if overwrite == 0 && exist(f_name_sorted_units) == 2
    disp(['LOAD SORTED UNITS']);
    load(f_name_sorted_units);
else

global clustattrib
global clustdata

num_clusters = numel(clustattrib.clusters);

sorted_spikes = cell(1,num_clusters);
for clust_id = 1:num_clusters
	sorted_spikes{clust_id}.clust_id = clust_id;
	sorted_spikes{clust_id}.detected_chan = mode(clustdata.customvar.iCh(clustattrib.clusters{clust_id}.index));
	sorted_spikes{clust_id}.spike_inds = []; %trial_num, index_val, time_stamp
	sorted_spikes{clust_id}.spike_waves = []; %spike wave forms
end
sync_trigs = cell(numel(file_list),1);


for trial_id = 1:numel(file_list)
	display(num2str(trial_id));
	[s p d] = load_ephys_trial(base_dir,file_list,trial_id);
	[start_ind start_time ephys_inds ephys_time] = extract_behaviour_triggers(d);
	sync_trigs{trial_id}.start_ind = start_ind;
	sync_trigs{trial_id}.ephys_inds = ephys_inds;
	sync_trigs{trial_id}.start_time = start_time;
	sync_trigs{trial_id}.ephys_time = ephys_time;
	
	for clust_id = 1:num_clusters
		display(num2str(clust_id));

		ch_id = sorted_spikes{clust_id}.detected_chan;
		[spike_clustered spike_not_clustered spike_artifact ch_id] = extract_sorted_spike_times(clust_id,trial_id,ch_id,s,d);

		spike_inds = s.spikes_all(spike_clustered,2);
		spike_times = d.TimeStamps(spike_inds);
		trial_ids = repmat(trial_id,length(spike_times),1);
		spike_inds = cat(2,trial_ids,spike_inds,spike_times);

		ch_range_probe = ch_id-3:ch_id+3;
		ch_range_center = 1:7;
		ch_range_center(ch_range_probe<1) = [];
		ch_range_probe(ch_range_probe<1) = [];
		ch_range_center(ch_range_probe>size(s.spike_wave,3)) = [];
		ch_range_probe(ch_range_probe>size(s.spike_wave,3)) = [];

		spike_wave_detect = zeros(length(spike_clustered),size(s.spike_wave,2),7);
		spike_wave_detect(:,:,ch_range_center) = s.spike_wave(spike_clustered,:,ch_range_probe);

		sorted_spikes{clust_id}.spike_inds = cat(1,sorted_spikes{clust_id}.spike_inds,spike_inds);
		sorted_spikes{clust_id}.spike_waves = cat(1,sorted_spikes{clust_id}.spike_waves,spike_wave_detect);	
	end
end
	save(f_name_sorted_units,'sorted_spikes','sync_trigs');
end