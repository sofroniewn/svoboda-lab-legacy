function sorted_spikes = extract_sorted_units_klusters(base_dir,sorted_name,overwrite)

disp(['--------------------------------------------']);

f_name_sorted_units = fullfile(base_dir,'ephys','sorted',[sorted_name '_sorted.mat']);

if overwrite == 0 && exist(f_name_sorted_units) == 2
    disp(['LOAD SORTED UNITS']);
    load(f_name_sorted_units);
else
disp(['EXTRACT SORTED UNITS']);


f_name_sync = fullfile(base_dir,'ephys','sorted',sorted_name,[sorted_name '.sync.1']);
sync_info = dlmread(f_name_sync);

f_name_fet = fullfile(base_dir,'ephys','sorted',sorted_name,[sorted_name '.fet.1']);
spike_amp = dlmread(f_name_fet);

f_name_clu = fullfile(base_dir,'ephys','sorted',sorted_name,[sorted_name '.clu.1']);
cluster_ids = dlmread(f_name_clu);
num_clusters = cluster_ids(1);
cluster_ids(1) = [];
num_spikes = length(cluster_ids);

num_chan = spike_amp(1);
spike_amp = reshape(spike_amp,[num_spikes+1,num_chan]);
spike_amp(1,:) = [];

f_name_spk = fullfile(base_dir,'ephys','sorted',sorted_name,[sorted_name '.spk.1']);
fid_spk = fopen(f_name_spk,'r');
spike_waves = fread(fid_spk,'int16');
num_samps = length(spike_waves)/(num_chan-1)/num_spikes;
spike_waves = reshape(spike_waves,[num_chan-1,num_samps,num_spikes]);

sorted_spikes = cell(1,num_clusters);
for clust_id = 1:num_clusters
	disp(['Cluster ' num2str(clust_id)]);
	sorted_spikes{clust_id}.clust_id = clust_id-1;
	spike_inds = cluster_ids == clust_id-1;
	sorted_spikes{clust_id}.detected_chan = mode(sync_info(spike_inds,6));
	sorted_spikes{clust_id}.trial_num = sync_info(spike_inds,1);
	sorted_spikes{clust_id}.ephys_index = sync_info(spike_inds,2);
	sorted_spikes{clust_id}.ephys_time = sync_info(spike_inds,3)/10^6;
	sorted_spikes{clust_id}.bv_index = sync_info(spike_inds,10);
	sorted_spikes{clust_id}.laser_power = sync_info(spike_inds,9)/10^3;
	sorted_spikes{clust_id}.spike_amp = spike_amp(spike_inds,sorted_spikes{clust_id}.detected_chan); %spike amplitude on detected channel
	sorted_spikes{clust_id}.spike_waves = squeeze(spike_waves(sorted_spikes{clust_id}.detected_chan,:,spike_inds))'; %spike wave forms
end
	save(f_name_sorted_units,'sorted_spikes');
disp(['SAVED SORTED UNITS']);
disp(['--------------------------------------------']);

end
disp(['--------------------------------------------']);
