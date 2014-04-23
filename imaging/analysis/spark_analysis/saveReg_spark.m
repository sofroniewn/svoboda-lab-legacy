function saveReg_spark(data_path,stimType,overwrite)

if overwrite || exist([data_path(1:end-4) '_' stimType '_X.mat']) ~=2
	load(data_path);
	[X,s] = buildReg_spark(full_trial_data,stimType);

	save([data_path(1:end-4) '_' stimType '_X.mat'],'X');
	save([data_path(1:end-4) '_' stimType '_s.mat'],'s');
end