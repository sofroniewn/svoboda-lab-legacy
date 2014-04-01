function save_common_data_format(session_path,file_name_tag,overwrite,session,im_session,session_ca);

save_path = fullfile(session_path,['session_imaging_summary_' file_name_tag '.mat']);
if overwrite ~= 1 && exist(save_path) == 2
else
	save(save_path,'im_session')
end

save_path = fullfile(session_path,['session_behaviour_' file_name_tag '.mat']);
if overwrite ~= 1 && exist(save_path) == 2
else
	save(save_path,'session')
end

save_path = fullfile(session_path,['session_ca_data_' file_name_tag '.mat']);
if overwrite ~= 1 && exist(save_path) == 2
else
	save(save_path,'session_ca')
end