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
			case 'clR'
				group_ids = 13;
            otherwise
				error('WGNR :: unrecognized groupd id')
		end
	case 'ol_cl_different_widths'
		groups = trial_inds;
		groups(groups>16) = 17;
		switch id_type
			case 'base'
				group_ids = [1:17];
			case 'olR'
				group_ids = [1:12];
			case 'outOfReach'
				group_ids = [10:12];
			case 'olMax'
				group_ids = [6:9];
			case 'clB'
				group_ids = [13:16];
			case 'clR'
				group_ids = 17;
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
	case 'laser_ol_new'
		groups = trial_inds;
		groups(trial_inds==15) = 4;
		groups(trial_inds==4) = 5;
		groups(trial_inds==16) = 6;
		groups(trial_inds==5) = 7;
		groups(trial_inds==17) = 8;
		groups(trial_inds==6) = 9;
		groups(trial_inds==18) = 10;
		groups(trial_inds==7) = 11;
		groups(trial_inds==8) = 12;
		groups(trial_inds==9) = 13;
		groups(trial_inds==10) = 14;
		groups(trial_inds==11) = 15;
		groups(trial_inds==12) = 16;
		groups(trial_inds==13) = 17;
		groups(trial_inds==14) = 18;
		switch id_type
			case 'base'
				group_ids = [1:18];
			case 'olR'
				group_ids = [1:11]; %[1 2 3 15 4 16 5 17 6 18 7];
			case 'olLP'
				group_ids = [18 17 16 15 14 13 12 11]; %7 8:13
			case 'outOfReach'
				group_ids = [11];
			otherwise
				error('WGNR :: unrecognized groupd id')
		end
	otherwise
		error('WGNR :: unrecognized expriment type')
end		