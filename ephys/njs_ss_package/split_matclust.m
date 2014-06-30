function [clustdata_1 clustdata_2] = combine_matclust(clustdata,switch_trial)

	clustdata_1 = clustdata;
	clustdata_2 = clustdata;
	
	clustdata_1.customvar.trials(clustdata_1.customvar.trials>=switch_trial) = -1;
	clustdata_2.customvar.trials = clustdata_2.customvar.trials - switch_trial + 1;
	clustdata_2.customvar.trials(clustdata_2.customvar.trials<=0) = -1;
