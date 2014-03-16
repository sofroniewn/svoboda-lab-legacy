function output_data = tcp_struct_parser(send_data,type,send_recieve)

if send_recieve == 1
	switch type
	case 'trial_config'
		output_data = {type, send_data.dat, send_data.column_names, send_data.laser_calibration, send_data.random_order, send_data.repeating_order, send_data.repeating_numbers, send_data.plot_options.dat, send_data.plot_options.names, send_data.file_name, send_data.version};
	case 'rig_config'
		rig_config_names = fieldnames(send_data);
		output_data = cell(1+2*numel(rig_config_names),1);
		output_data{1} = type;
		for ij = 1:numel(rig_config_names)
			output_data{1+2*(ij-1)+1} = rig_config_names{ij};
			output_data{1+2*(ij-1)+2} = send_data.(rig_config_names{ij});
		end
	case 'ps_sites'
		ps_sites_names = fieldnames(send_data);
		output_data = cell(1+2*numel(ps_sites_names),1);
		output_data{1} = type;
		for ij = 1:numel(ps_sites_names)
			output_data{1+2*(ij-1)+1} = ps_sites_names{ij};
			output_data{1+2*(ij-1)+2} = send_data.(ps_sites_names{ij});
		end
	otherwise
		error('Unrecognized type')
	end
else
	switch type
	case 'trial_config'
		trial_config = trial_config_class;
		trial_config.dat = cell(send_data{2});
        if min(size(trial_config.dat)) == 1
            trial_config.dat = trial_config.dat';
        end
		trial_config.column_names = send_data{3};
		trial_config.laser_calibration = send_data{4};
		trial_config.random_order = send_data{5};
		trial_config.repeating_order = send_data{6};
		trial_config.repeating_numbers = send_data{7};
		trial_config.plot_options.dat = send_data{8};
		trial_config.plot_options.names = send_data{9};
		trial_config.file_name = send_data{10};
		trial_config.version = send_data{11};
        trial_config
		trial_config = trial_dat_parser(trial_config);	
		output_data = trial_config;
	case 'rig_config'
		num_rig_config_fields = numel(send_data);
		for ij = 1:(num_rig_config_fields-1)/2
			rig_config.(send_data{1+2*(ij-1)+1}) = send_data{1+2*(ij-1)+2};
		end
		output_data = rig_config;
	case 'ps_sites'
		num_ps_sites_fields = numel(send_data);
		for ij = 1:(num_ps_sites_fields-1)/2
			ps_sites.(send_data{1+2*(ij-1)+1}) = send_data{1+2*(ij-1)+2};
		end
		output_data = ps_sites;
	otherwise
		error('Unrecognized type')
	end
end


end

		