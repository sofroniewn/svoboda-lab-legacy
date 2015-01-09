function merge_ephys_behaviour(all_anm_id,local_save_path)

if exist(local_save_path) ~= 7
	mkdir(local_save_path);
end

for ih =  1:numel(all_anm_id)
	anm_id = all_anm_id{ih}
	
    [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
    run_thresh = anm_params.run_thresh;
    trial_range_start = anm_params.trial_range_start;
    trial_range_end = anm_params.trial_range_end;
    cell_reject = anm_params.cell_reject;
    exp_type = anm_params.exp_type;
    layer_4 = anm_params.layer_4;
    boundaries = anm_params.boundaries;
    boundary_labels = anm_params.boundary_labels;

	[bv_sync] = func_extract_bv_sync(base_dir, [], 'bv_sync', 0);

	% Load in ephys data
	sorted_name = 'klusters_data';
	over_write_sorted = 0;
	dir_num = 1;
	sorted_spikes = extract_sorted_units_klusters(base_dir,sorted_name,dir_num,over_write_sorted);
	
	% remove noise clusters
	sorted_spikes = sorted_spikes(3:end);

	% problem with last cluster from 237723 as empty
	%if strcmp(anm_id,'237723')
   	%	sorted_spikes = sorted_spikes(1:28);
	%end

	sorted_spikes = time_shift_sorted_spikes(sorted_spikes,bv_sync);

	% Load in behaviour data
	base_path_behaviour = fullfile(base_dir, 'behaviour');
	
	session = load_session_data(base_path_behaviour);
	session = parse_session_data(1,session);

	% Merge and summarize ephys data
	all_clust_ids = 1:numel(sorted_spikes);
	plot_on = 0;
	d = [];
    ephys_summary = [];
	d = summarize_cluster_params(d,ephys_summary,all_clust_ids,sorted_spikes,session,exp_type,trial_range_start,trial_range_end,layer_4,run_thresh,plot_on);
	d.anm_params = anm_params;
	
	save(fullfile(local_save_path,[anm_id '_d']),'d','-v7.3');
end
