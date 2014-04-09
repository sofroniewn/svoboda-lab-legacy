function convert_legacy_behaviour(data_dir,convert_name,over_write,wgnr_dir)

% convert_legacy_behaviour(fileparts(im_session.basic_info.data_dir),'Early JaeSung mice',0)
% convert_legacy_behaviour(fileparts(im_session.basic_info.data_dir),'anm_0227254',0)
% data_dir = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0217489/2013_07_19/run_01'
% convert_name = 'anm_0217489';
% over_write = 0;
% wgnr_dir = '/Users/sofroniewn/github/wgnr/behaviour/WGNR_GUI';


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
		% For JaeSung data from before March 31 2014
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
    		    fprintf('(convert)  file %03g/%g  ',ij,numel(cur_files)-1);

    			f_name = fullfile(data_dir,cur_files(ij).name);
    			load(f_name);
    			if exist(fullfile(data_dir,'original',cur_files(ij).name)) ~= 2
    				save(fullfile(data_dir,'original',cur_files(ij).name),'trial_mat_names','trial_num','trial_matrix');
    			end
				scim_trigs = ones(1,size(trial_matrix,2));
				load(fullfile(im_data_dir,im_files(ij).name));
				num_frames = im_summary.props.num_frames*im_summary.props.num_planes;
				fprintf(' %03d ', im_summary.props.num_frames);
				fprintf(' %.2f ',im_summary.props.num_frames/size(trial_matrix,2)*500);
				fprintf(' %.2f',im_summary.props.frameRate);
				fprintf('\n');
				trig_times = linspace(1,size(trial_matrix,2),num_frames+1);
				scim_trigs(round(trig_times)) = 0;
				trial_matrix(14,:) = scim_trigs;
				save(fullfile(data_dir,cur_files(ij).name),'trial_mat_names','trial_num','trial_matrix');
			end
    	end
    	fprintf('(convert) DONE\n');

    case('anm_0217489')
		% Layer 2/3 mouse recorded in 2013 with old data format with ol & cl data
		% total trial type 19
		% trials 200 cm long
		% 12 second timeout
		% 1 second iti
		%
		% reset corridor position
		%
		% 7 different closed loop turn types --- types 1-7
		% 30 mm wide corridor both walls on
		% turns ±16.7, ±11.3, ±5.7 and 0
		% turns during middle 1/2
		% test period middle 1/2
		% cl_dir_state = 1-7
		%
		% 12 different open loop turn types - left wall off ---- types 8-19
		%  {0,2,4,6,8,10,12,14,16,20,25,30}
		%  cl_dir_state = 9
		% 8 seconds long - time
		% 1/8 still, then 1/8 moves into position, then 1/2 still, then 1/8 out position then 1/8 still
		% out of position is 30 mm
		%
		%
		% water time 100ms
		% water range 2 - 28 mm
		% water distance frac .9


		data_dir = fullfile(data_dir,'behaviour');
		if exist(fullfile(data_dir,'original')) ~=7 || over_write == 1
			cur_files = dir(fullfile(data_dir,'*_data_v3.mat'));

			% copy and move original data file
			if numel(cur_files) == 1 && exist(fullfile(data_dir,'original')) ~=7
				mkdir(fullfile(data_dir,'original'));
				movefile(fullfile(data_dir,cur_files(1).name),fullfile(data_dir,'original',cur_files(1).name))
    		end

    		load(fullfile(data_dir,'original',cur_files(1).name));
    		data = obj;
    		base_fname = ['anm_0' data.animal_number '_20' data.date(1:2) 'x' data.date(3:4) 'x' data.date(5:6) '_run_' sprintf('%02d',str2num(data.run_number)) '_'];

			% Get rig config file
			if strcmp(data.rig_name,'im_rig')
				rig_config_file_name = 'WGNR_IM_rig_calib_file.m';
			else
				error('Unrecognized rig')				
			end
			rig_config_full_name = fullfile(wgnr_dir,'Rig_configs',rig_config_file_name);
			run(rig_config_full_name);
			rig_save_name = fullfile(data_dir,[base_fname 'rig_config.mat']);
			save(rig_save_name,'rig_config');

			% Get trial config file
			trial_config_file_name = 'scim_ol_cl.mat';
			trial_config_full_name = fullfile(wgnr_dir,'Trial_configs','LEGACY',trial_config_file_name);
			load(trial_config_full_name);
			trial_save_name = fullfile(data_dir,[base_fname 'trial_config.mat']);
			save(trial_save_name,'trial_config');

			% Get PS sites file
			ps_full_name = fullfile(wgnr_dir,'Rig_configs','DEFAULT_PS','photostim_sites.m');
			run(ps_full_name);
			ps_save_name = fullfile(data_dir,[base_fname 'ps_sites.mat']);
			save(ps_save_name,'ps_sites');

			% Prepare to extract trial by trial data
			trial_mat_names = {'x_vel','y_vel','cor_pos','cor_width','laser_power','x_mirror_pos','y_mirror_pos', ...
			    'trial_num','inter_trial_trig','lick_state','water','running_ind', ...
			    'masking_flash_on','scim_state','undefined','scim_logging','test_val'};

			
			% prepare the relevant variables for extraction
			x_vel = data.d_ball_pos_x.data;
			y_vel = data.d_ball_pos_y.data;
			cor_pos = data.cor_pos.data;
			cor_width = 30*ones(data.num_reads,1);
			laser_power = data.laser_power.data;
			x_mirror_pos = data.x_mirror_pos.data;
			y_mirror_pos = data.y_mirror_pos.data;
			trial_num_all = ones(data.num_reads,1); % NEED TO EDIT along with trial config
			inter_trial_trig = 1-data.trial_period.data;
			lick_state = data.licks.data;
			water = data.water.data;
			running_ind = 2-data.cl_gf_state.data;
			masking_flash_on = data.masking_flash.data;
			scim_state = data.scim_trig.data;
			undefined = zeros(data.num_reads,1);
			scim_logging = ones(data.num_reads,1); % NEED TO EDIT - check if any scim frames during trial
			test_val = data.test_period.data;
			
			cl_dir_state = data.cl_dir_state.data;

			% get trial boundaries
			trial_end_times = data.trial_period.stop_inds; % vector containing trial end times
			trial_start = 1;

			% extract trial by trial data
			for ij = 1:length(trial_end_times)
    			fprintf('(convert)  file %g/%g \n',ij,length(trial_end_times));
				trial_end = trial_end_times(ij);
    			num_time_points = trial_end - trial_start + 1;
				trial_matrix = zeros(numel(trial_mat_names),num_time_points);
				
				trial_matrix(1,:) = x_vel(trial_start:trial_end)/500;
				trial_matrix(2,:) = y_vel(trial_start:trial_end)/500;
				trial_matrix(3,:) = cor_pos(trial_start:trial_end);
				trial_matrix(4,:) = cor_width(trial_start:trial_end);
				trial_matrix(5,:) = laser_power(trial_start:trial_end);
				trial_matrix(6,:) = x_mirror_pos(trial_start:trial_end);
				trial_matrix(7,:) = y_mirror_pos(trial_start:trial_end);
				trial_matrix(8,:) = trial_num_all(trial_start:trial_end);
				trial_matrix(9,:) = inter_trial_trig(trial_start:trial_end);
				trial_matrix(10,:) = lick_state(trial_start:trial_end);
				trial_matrix(11,:) = water(trial_start:trial_end);
				trial_matrix(12,:) = running_ind(trial_start:trial_end);
				trial_matrix(13,:) = masking_flash_on(trial_start:trial_end);
				trial_matrix(14,:) = scim_state(trial_start:trial_end);
				trial_matrix(15,:) = undefined(trial_start:trial_end);
				trial_matrix(16,:) = scim_logging(trial_start:trial_end);
				trial_matrix(17,:) = test_val(trial_start:trial_end);
                trial_matrix(17,trial_matrix(9,:)>0) = 0;
                
				if ~any(trial_matrix(14,:))
					trial_matrix(16,:) = 0*trial_matrix(16,:);
				end
				cl_state_trial = cl_dir_state(trial_start:trial_end);
				cl_state_trial = round(mode(cl_state_trial(trial_matrix(17,:)>0)));
                if isnan(cl_state_trial)
    				cl_state_trial = cl_dir_state(trial_start:trial_end);
                    cl_state_trial = round(mode(cl_state_trial));
                end
				if cl_state_trial ~= 9
					switch_vect = [4 2 3 5 6 1 7];
					trial_num = switch_vect(cl_state_trial);
				else
					cor_pos_trial = round(mean(trial_matrix(3,trial_matrix(17,:)>0)));
					switch_vect = [0,2,4,6,8,10,12,14,16,20,25,30];
					trial_num = find(switch_vect == cor_pos_trial) + 7;
				end
				trial_matrix(8,:) = trial_num*trial_matrix(8,:);
				f_name = fullfile(data_dir,[base_fname 'trial_' sprintf('%04d',ij)]);
    			save(f_name,'trial_mat_names','trial_num','trial_matrix');
				trial_start = trial_end_times(ij)+1;
			end

    	end



	otherwise 
		display('No method for dealing with this legacy data type');
	end

end