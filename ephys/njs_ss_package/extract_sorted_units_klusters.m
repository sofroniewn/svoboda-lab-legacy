function sorted_spikes = extract_sorted_units_klusters(base_dir,sorted_name,dir_num,overwrite)

disp(['--------------------------------------------']);
f_name_sorted_units = fullfile(base_dir,'ephys','sorted',[sorted_name '_sorted_' num2str(dir_num) '.mat']);

if overwrite == 0 && exist(f_name_sorted_units) == 2
    disp(['LOAD SORTED UNITS']);
    load(f_name_sorted_units);
else
disp(['EXTRACT SORTED UNITS']);
%base_dir = all_base_dir{1};
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
spike_amp(1,:) = [];

f_name_spk = fullfile(base_dir,'ephys','sorted',sorted_name,[sorted_name '.spk.1']);
fid_spk = fopen(f_name_spk,'r');
num_samps = 53;
num_chan = 33;
spikes_to_read = 1000;
read_length = spikes_to_read*(num_chan-1)*num_samps;
read_samps = 1;
spike_waves = [];
tot_spikes = 0;
while read_samps
	tmp = fread(fid_spk,read_length,'int16');
	if ~isempty(tmp)
	num_spikes_read = length(tmp)/(num_chan-1)/num_samps;
	spike_waves_tmp = reshape(tmp,[num_chan-1,num_samps,num_spikes_read]);
	spike_inds = [1:num_spikes_read] + tot_spikes;
    X = sync_info(spike_inds,6);
    Y = [1:num_spikes_read]';
    spike_waves_tmp = arrayfun(@(x,y) squeeze(spike_waves_tmp(x,:,y)),X,Y,'UniformOutput',0);
	tot_spikes = tot_spikes + num_spikes_read;
	spike_waves = cat(1,spike_waves,cell2mat(spike_waves_tmp));
	else
	read_samps = 0;
	end
end
fclose(fid_spk);
if tot_spikes~=num_spikes
    error('Problem reading waveforms')
end

sorted_spikes = cell(1,num_clusters);
for clust_id = 1:num_clusters
    disp(['Cluster ' num2str(clust_id)]);
	sorted_spikes{clust_id}.clust_id = clust_id-1;
	spike_inds = cluster_ids == clust_id-1 & sync_info(:,end) == dir_num;
	if sum(spike_inds) > 0
		% Delete copies of the spike within two samples
    	spike_inds = find(spike_inds);
    	spike_times = spike_amp(spike_inds,end);
    	ISI = diff(spike_times);
    	spike_inds(ISI <= 4) = [];

    sorted_spikes{clust_id}.detected_chan = mode(sync_info(spike_inds,6));
	sorted_spikes{clust_id}.trial_num = sync_info(spike_inds,1);
	sorted_spikes{clust_id}.session_id_num = sync_info(spike_inds,end);
	sorted_spikes{clust_id}.ephys_index = sync_info(spike_inds,2);
	sorted_spikes{clust_id}.ephys_time = sync_info(spike_inds,3)/10^6;
	sorted_spikes{clust_id}.bv_index = sync_info(spike_inds,10);
	sorted_spikes{clust_id}.laser_power = sync_info(spike_inds,9)/10^3;
	sorted_spikes{clust_id}.spike_amp = spike_amp(spike_inds,sorted_spikes{clust_id}.detected_chan); %spike amplitude on detected channel
	sorted_spikes{clust_id}.session_time = spike_amp(spike_inds,end); %session time
%	sorted_spikes{clust_id}.spike_waves = squeeze(spike_waves(sorted_spikes{clust_id}.detected_chan,:,spike_inds))'; %spike wave forms
	sorted_spikes{clust_id}.spike_waves = spike_waves(spike_inds,:); %spike wave forms
	sorted_spikes{clust_id}.mean_spike_amp = mean(spike_amp(spike_inds,:),1)'; %spike amplitude on detected channel
	end
end
	save(f_name_sorted_units,'sorted_spikes');
disp(['SAVED SORTED UNITS']);
disp(['--------------------------------------------']);

end
disp(['--------------------------------------------']);
