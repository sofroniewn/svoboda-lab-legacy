function update_tcp_buffer(obj,event,handles)

mssg = jtcp('read',handles.jTcpObj);

if isempty(mssg) ~= 1
mssg = cell(mssg);
%str_list = {'Start connection','Stop connection','Stop run','Prepare run', ...
%			'file_id_name','rig_config','trial_config','trial_mat_names', ...
%			'ps_sites', 'Start run','trial_data'};
	switch mssg{1}
		case 'Start connection'
			set(handles.text_TCP_status,'String',mssg{1})
		case 'Stop connection'
			set(handles.text_TCP_status,'String',mssg{1})
		case 'Stop run'
			set(handles.text_TCP_status,'String',mssg{1})
		case 'Prepare run'
			set(handles.text_TCP_status,'String',mssg{1})
			base_path_behaviour = fullfile(handles.base_path, 'behaviour');			
		    global session;
    		session = [];
    		session.data = [];
		case 'file_id_name'
			set(handles.text_TCP_status,'String','Recieved file name')
			global behaviour_fname_base;
			behaviour_fname_base = fullfile(handles.base_path, 'behaviour',mssg{2});
			global session;
			session.basic_info.data_dir = fullfile(handles.base_path, 'behaviour');
			[pathstr, name, ext] = fileparts(session.basic_info.data_dir); 
			[pathstr, name, ext] = fileparts(pathstr); 
			session.basic_info.run_str = name;
			[pathstr, name, ext] = fileparts(pathstr); 
			session.basic_info.date_str = name;
			[pathstr, name, ext] = fileparts(pathstr); 
			session.basic_info.anm_str = name;
		case 'rig_config'
			set(handles.text_TCP_status,'String','Recieved rig config')
			rig_config = tcp_struct_parser(mssg,'rig_config',0);
			global behaviour_fname_base;
			save([behaviour_fname_base 'rig_config.mat'],'rig_config');
			global session;
			session.rig_config = rig_config;
		case 'trial_config'
			set(handles.text_TCP_status,'String','Recieved trial config')
			trial_config = tcp_struct_parser(mssg,'trial_config',0);
			global behaviour_fname_base;
			save([behaviour_fname_base 'trial_config.mat'],'trial_config');
			global session;
			session.trial_config = trial_config;
		case 'trial_mat_names'
			set(handles.text_TCP_status,'String','Recieved trial mat names')
			global trial_mat_names;
			trial_mat_names = mssg{2};
		case 'ps_sites'
			set(handles.text_TCP_status,'String','Recieved ps sites')
			ps_sites = tcp_struct_parser(mssg,'ps_sites',0);
			global behaviour_fname_base;
			save([behaviour_fname_base 'ps_sites.mat'],'ps_sites');
		case 'Start run'
			set(handles.text_TCP_status,'String',mssg{1})
		case 'trial_data'
			trial_num = mssg{2};
			set(handles.text_TCP_status,'String',sprintf('Recieved trial data %04d.mat',trial_num))
			global behaviour_fname_base;
			global trial_mat_names;
			trial_matrix = mssg{3};
            save([behaviour_fname_base sprintf('trial_%04d.mat',trial_num)],'trial_matrix','trial_mat_names','trial_num');
			global session;
		    session.data{trial_num}.trial_matrix = trial_matrix;
		    session.data{trial_num}.trial_mat_names = trial_mat_names;
		    session.data{trial_num}.trial_num = trial_num;
		    session.data{trial_num}.f_name = [behaviour_fname_base sprintf('trial_%04d.mat',trial_num)];
    		parse_session_data(trial_num,[]);
    		set(handles.text_num_behaviour,'String',['Behaviour trials ' num2str(numel(session.data))]);
    	otherwise
    			error('Wrong data type sent over TCP')
	end
end