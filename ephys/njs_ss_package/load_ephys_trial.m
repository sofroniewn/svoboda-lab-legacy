function [s p d] = load_ephys_trial(base_dir,file_list,trial_id);

	[pathstr, f_name_base, ext] = fileparts(file_list{trial_id});
	f_name_processed_vlt = fullfile(base_dir,'ephys','processed',[f_name_base '_processed_vlt.mat']);
	f_name_spikes = fullfile(base_dir,'ephys','processed',[f_name_base '_spikes.mat']);
	load(f_name_processed_vlt);
	load(f_name_spikes);

end