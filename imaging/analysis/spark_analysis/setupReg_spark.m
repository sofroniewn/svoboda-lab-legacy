function [stim_types val_array] = setupReg_spark


	stim_types = {'corPos';'speed'};
	val_array = cell(numel(stim_types),1);
	for ij = 1:numel(stim_types)
		[X val] = buildReg_spark([],stim_types{ij});
		val_array{ij} = val;
	end
