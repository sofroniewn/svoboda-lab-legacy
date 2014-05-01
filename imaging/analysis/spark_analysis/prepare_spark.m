function prepare_spark(data_path,behaviour_on,overwrite)

	[stim_types val_array] = setupReg_spark;
	
	if behaviour_on
		% create regressor matrices
		for ij = 1:numel(stim_types)
			saveReg_spark(fullfile(data_path,'Text_behaviour.mat'),stim_types{ij},overwrite);
		end
	end

% if data on cluster create command to spark
start_ind = strfind(data_path,'imreg');

if isempty(start_ind)
	evalScript = 'DATA NOT ON CLUSTER';
	display(evalScript);
	return;
else	
	% set variables
	end_path = data_path(start_ind:end);
	end_path(strfind(end_path,'\')) = '/';
	directory = ['/groups/svoboda/wdbp/',end_path];

	% set paths for the function
	out_put_path = fullfile(data_path,'spark');
	if ~exist(out_put_path)
		mkdir(out_put_path)
	end

	image_names = '"Text_images_*.txt"';
	analysis_str = '/scripts/custom_thunder/combined.py';

	if behaviour_on
		stim_str = stim_types{1};
		for ij = 2:numel(stim_types)
			stim_str = [stim_str '-' stim_types{ij}];
		end
		regress_str = sprintf('--stim %s --basename Text_behaviour_',stim_str);
	else
		regress_str = '';
	end

	% create script
	evalScript = sprintf('pyspark %s $MASTER %s %s %s',analysis_str,directory,image_names,regress_str);
	display(evalScript)
end