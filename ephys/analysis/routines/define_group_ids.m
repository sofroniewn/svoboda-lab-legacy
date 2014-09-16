function [group_ids groups] = define_group_ids(exp_type,id_type,trial_inds)

switch exp_type
	case 'classic_ol_cl'
		groups = trial_inds-1;
		groups(groups==0) = 20;
		groups(groups>12) = 13;
		switch id_type
			case 'base'
				group_ids = [1:13];
			case 'olR'
				group_ids = [1:12];
			case 'outOfReach'
				group_ids = [10:12];
			case 'olMax'
				group_ids = [6:9];
			case 'clB'
				group_ids = 13;
			otherwise
				error('WGNR :: unrecognized groupd id')
		end
	case 'bilateral_ol_cl'
		groups = trial_inds;
		groups(groups>=16) = 16;
		switch id_type
			case 'base'
				group_ids = [1:16];
			case 'olR'
				group_ids = [1:5 11];
			case 'olL'
				group_ids = [6:8 11];
			case 'olB'
				group_ids = [9:10 11];
			case 'outOfReach'
				group_ids = [11];
			case 'clB'
				group_ids = [12:15];
			case 'clR'
				group_ids = 16;
			otherwise
				error('WGNR :: unrecognized groupd id')
		end
	case 'laser_ol'
		groups = trial_inds;
		switch id_type
			case 'base'
				group_ids = [1:20];
			case 'olR'
				group_ids = [1:7];
			case 'olLP'
				group_ids = [13 12 11 10 9 8 7]; %7 8:13
			case 'olRLP'
				group_ids = [14:20];
			case 'outOfReach'
				group_ids = [7];
			otherwise
				error('WGNR :: unrecognized groupd id')
		end
	otherwise
		error('WGNR :: unrecognized expriment type')
end		