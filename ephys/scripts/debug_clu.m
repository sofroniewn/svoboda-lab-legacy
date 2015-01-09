

base_dir = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_245918/2014_06_21/run_03';
sorted_name = 'klusters_data'
f_name_spk = fullfile(base_dir,'ephys','sorted',sorted_name,[sorted_name '.spk.1']);
f_name_spk_b = ['/Users/sofroniewn/Documents/DATA/ephys_summary_rev10/' sorted_name '_COPY_b.spk.1'];
f_name_spk_l = ['/Users/sofroniewn/Documents/DATA/ephys_summary_rev10/' sorted_name '_COPY_l.spk.1'];
f_name_spk_s = ['/Users/sofroniewn/Documents/DATA/ephys_summary_rev10/' sorted_name '_COPY_s.spk.1'];
f_name_spk_a = ['/Users/sofroniewn/Documents/DATA/ephys_summary_rev10/' sorted_name '_COPY_a.spk.1'];

fid_spk = fopen(f_name_spk,'r');
fid_spk_b = fopen(f_name_spk_b,'w');
fid_spk_l = fopen(f_name_spk_l,'w');
fid_spk_s = fopen(f_name_spk_s,'w');
fid_spk_a = fopen(f_name_spk_a,'w');

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
	fwrite(fid_spk_b,tmp,'int16','b');
	fwrite(fid_spk_l,tmp,'int16','l');
	fwrite(fid_spk_s,tmp,'int16','s');
	fwrite(fid_spk_a,tmp,'int16','a');
	tot_spikes = tot_spikes + num_spikes_read
	else
	read_samps = 0;
	end
end
fclose(fid_spk);
fclose(fid_spk_b);
fclose(fid_spk_l);
fclose(fid_spk_s);
fclose(fid_spk_a);


