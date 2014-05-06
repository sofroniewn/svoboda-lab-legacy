function [stim_types range_array] = setupReg_spark

	stim_types = {'corPos';'speed'};
	range_array = cell(numel(stim_types),1);
	for ij = 1:numel(stim_types)
		[X val range_vals] = buildReg_spark([],stim_types{ij});
		range_array{ij} = range_vals;
	end
