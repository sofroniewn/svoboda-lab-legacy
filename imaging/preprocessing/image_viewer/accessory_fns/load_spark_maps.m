function load_spark_maps(data_dir,overwrite)

global im_session
num_planes = im_session.ref.im_props.numPlanes;
num_chan = im_session.ref.im_props.nchans;


output_files = dir(fullfile(data_dir,'spark','*.mat'));
output_files = {output_files(:).name};

if numel(output_files)>0
	ind = find(strcmp(output_files,'mean_vals.mat'));
	if ~isempty(ind) && (overwrite || ~isempty(im_session.spark_output.mean));
		load(fullfile(data_dir,'spark',output_files{ind}));
		im_session.spark_output.mean = cell(num_planes,num_chan);
		for ik = 1:num_planes
			for ih = 1:num_chan
				im_session.spark_output.mean{ik,ih} = squeeze(mean_vals(:,:,ik))';
			end
		end
	end

	ind = find(strcmp(output_files,'local_corr.mat'));
	if ~isempty(ind) && (overwrite || ~isempty(im_session.spark_output.localcorr));
		load(fullfile(data_dir,'spark',output_files{ind}));
		im_session.spark_output.localcorr = cell(num_planes,num_chan);
		for ik = 1:num_planes
			for ih = 1:num_chan
				im_session.spark_output.localcorr{ik,ih} = squeeze(local_corr(:,:,ik))';
			end
		end
	end

	for ij = 1:numel(im_session.spark_output.regressor.names)
		cur_name = ['stats_' im_session.spark_output.regressor.names{ij} '.mat'];
		ind = find(strcmp(output_files,cur_name));
		if ~isempty(ind) && (overwrite || ~isempty(im_session.spark_output.regressor.stats{ij}));
			load(fullfile(data_dir,'spark',output_files{ind}));
			im_session.spark_output.regressor.stats{ij} = cell(num_planes,num_chan);
			for ik = 1:num_planes
				for ih = 1:num_chan
					im_session.spark_output.regressor.stats{ij}{ik,ih} = eval(sprintf('squeeze( %s (:,:,ik))''',['stats_' im_session.spark_output.regressor.names{ij}]));
				end
			end
		end
		cur_name = ['tune_' im_session.spark_output.regressor.names{ij} '-0.mat'];
		ind = find(strcmp(output_files,cur_name));
		if ~isempty(ind) && (overwrite || ~isempty(im_session.spark_output.regressor.tune{ij}));
			load(fullfile(data_dir,'spark',output_files{ind}));
			im_session.spark_output.regressor.tune{ij} = cell(num_planes,num_chan);
			for ik = 1:num_planes
				for ih = 1:num_chan
					im_session.spark_output.regressor.tune{ij}{ik,ih} = eval(sprintf('squeeze( %s (:,:,ik))''',['tune_' im_session.spark_output.regressor.names{ij} '0']));
				end
			end
		end
	end
end