function convert_legacy_behaviour(data_dir,convert_name,over_write)

switch(convert_name)
	case('anm_0227254')
		% Layer IV mouse recorded in 2013
		% problem was that scanimage trigger new file on end of iti period
		% not beginning of iti.
		% have to recombine trials such that iti is at the end of each trial
		% not at the beginning - means throwing away first iti period and last trial
		% should also delete last imaging file
		data_dir = fullfile(data_dir,'behaviour');
		if exist(fullfile(data_dir,'original')) ~=7 || over_write == 1
			cur_files = dir(fullfile(data_dir,'*_trial_*.mat'));

			if numel(cur_files) > 1 && exist(fullfile(data_dir,'original')) ~=7
				mkdir(fullfile(data_dir,'original'));
    		end

			for ij = 1:numel(cur_files)-1
    			fprintf('(convert)  file %g/%g \n',ij,numel(cur_files)-1);
				f_name = fullfile(data_dir,cur_files(ij).name);
    			load(f_name);
    			if exist(fullfile(data_dir,'original',cur_files(ij).name)) ~= 2
    				save(fullfile(data_dir,'original',cur_files(ij).name),'trial_mat_names','trial_num','trial_matrix');
    			end

				trial_matrix_next = trial_matrix;
				ind = 501;
    			if ij>1
					trial_matrix = [trial_matrix_prev trial_matrix_next(:,1:ind-1)];
					save(fullfile(data_dir,cur_files(ij-1).name),'trial_mat_names','trial_num','trial_matrix');
				end
				trial_matrix_prev = trial_matrix_next(:,ind:end);
    		end
    		delete(fullfile(data_dir,cur_files(numel(cur_files)-1).name));
    	end

	case('Early JaeSung mice')
		% For data from before March 31 2014
		% Scim trigger not recroderd due to wrong channel number in rig config
		% Place down triggers after new trial trig so correct number gauranteed
		im_data_dir =  fullfile(data_dir,'scanimage','summary');
		im_files = dir(fullfile(im_data_dir,'*_summary_*.mat'));
		data_dir = fullfile(data_dir,'behaviour');
		if exist(fullfile(data_dir,'original')) ~=7 || over_write == 1
			cur_files = dir(fullfile(data_dir,'*_trial_*.mat'));

			if numel(cur_files) > 1 && exist(fullfile(data_dir,'original')) ~=7
				mkdir(fullfile(data_dir,'original'));
    		end

			for ij = 1:numel(cur_files)-1
    		    fprintf('(convert)  file %g/%g \n',ij,numel(cur_files)-1);

    			f_name = fullfile(data_dir,cur_files(ij).name);
    			load(f_name);
    			if exist(fullfile(data_dir,'original',cur_files(ij).name)) ~= 2
    				save(fullfile(data_dir,'original',cur_files(ij).name),'trial_mat_names','trial_num','trial_matrix');
    			end
				scim_trigs = ones(1,size(trial_matrix,2));
				load(fullfile(im_data_dir,im_files(ij).name));
				num_frames = im_summary.props.num_frames*im_summary.props.num_planes;
				trig_times = linspace(1,size(trial_matrix,2),num_frames+1);
				scim_trigs(round(trig_times)) = 0;
				trial_matrix(14,:) = scim_trigs;
				save(fullfile(data_dir,cur_files(ij).name),'trial_mat_names','trial_num','trial_matrix');
			end
    	end

	otherwise 
		display('No method for dealing with this legacy data type');
	end

end