function add_pca_features(base_dir,sorted_name,num_pca_features)


disp(['--------------------------------------------']);

f_name_sorted_units = fullfile(base_dir,'ephys','sorted',[sorted_name '_sorted.mat']);

disp(['ADD PCA FEATURES']);

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
top_row = spike_amp(2,1);
spike_amp(1:2,:) = [];
num_fet = num_chan;

disp(['LOAD WAVEFORMS']);

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
spike_waves(1,:) = [];

disp(['PERFROM PCA']);
[COEFF,SCORE]   = princomp(spike_waves);
spike_PCA = SCORE(:,1:num_pca_features);
spike_PCA = round(spike_PCA) + round(top_row/2);
spike_amp = cat(2,spike_amp(:,1:end-1),spike_PCA,spike_amp(:,end));
top_row = repmat(top_row,1,size(spike_amp,2));
top_row(end) = 0;
spike_amp = cat(1,top_row,spike_amp);
num_fet = num_fet + num_pca_features;



disp(['SAVE FEATURES']);

fid_fet = fopen(f_name_fet,'w');
fprintf(fid_fet,['%i\n'],num_fet);

fmt = repmat('%i ',1,size(spike_amp,2)-1);
fprintf(fid_fet,[fmt ' %i\n'],spike_amp');


disp(['DONE']);
disp(['--------------------------------------------']);

end
