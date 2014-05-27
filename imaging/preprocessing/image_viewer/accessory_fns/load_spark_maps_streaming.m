function update_plot = load_spark_maps_streaming(data_dir)

global im_session
num_planes = im_session.ref.im_props.numPlanes;
num_chan = im_session.ref.im_props.nchans;
update_plot = 0;
tot_files = dir(fullfile(data_dir,'streaming','results','*.txt'));
if numel(tot_files) > im_session.spark_output.streaming.tot_num_files
	for ij = 1:numel(im_session.spark_output.regressor.names)
		output_files_r2 = dir(fullfile(data_dir,'streaming','results',['r2-' im_session.spark_output.regressor.names{ij} '-*.txt']));
		output_files_tune = dir(fullfile(data_dir,'streaming','results',['tuning-' im_session.spark_output.regressor.names{ij} '-*.txt']));
		im_session.spark_output.streaming.stats{ij} = cell(num_planes,num_chan);
		im_session.spark_output.streaming.tune{ij} = cell(num_planes,num_chan);
		if numel(output_files_r2) > 0 && numel(output_files_tune) > 0
			im_session.spark_output.streaming.stats{ij} = cell(num_planes,num_chan);
            im_session.spark_output.streaming.tune{ij} = cell(num_planes,num_chan);
            %r2_fid = fopen(fullfile(data_dir,'streaming','results',output_files_r2(end).name),'r');
			%r2_mat = fread(r2_fid,'single');
			%fclose(r2_fid);
			r2_mat = dlmread(fullfile(data_dir,'streaming','results',output_files_r2(end).name));
            r2_mat = reshape(r2_mat,[im_session.ref.im_props.height, im_session.ref.im_props.width, num_planes]);
            %tune_fid = fopen(fullfile(data_dir,'streaming','results',output_files_tune(end).name),'r');
			%tune_mat = fread(tune_fid,'%f');
			%fclose(tune_fid);
			tune_mat = dlmread(fullfile(data_dir,'streaming','results',output_files_tune(end).name));
            tune_mat = reshape(tune_mat,[im_session.ref.im_props.height, im_session.ref.im_props.width, num_planes]);
			for ik = 1:num_planes
				for ih = 1:num_chan
					im_session.spark_output.streaming.stats{ij}{ik,ih} = squeeze(r2_mat(:,:,ik)');
					im_session.spark_output.streaming.tune{ij}{ik,ih} = squeeze(tune_mat(:,:,ik)');
				end
            end
        else
            im_session.spark_output.streaming.stats{ij} = [];
            im_session.spark_output.streaming.tune{ij} = [];
        end
	end
	im_session.spark_output.streaming.tot_num_files = numel(tot_files);
	update_plot = 1;
end