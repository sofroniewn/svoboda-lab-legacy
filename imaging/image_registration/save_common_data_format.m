function save_common_data_format(session_path,file_name_tag,overwrite,num_files,behaviour_on,session,im_session,session_ca);

if isfield(im_session,'reg')
	align_mean = uint16(im_session.reg.align_mean);
	im_session.reg.raw_mean = [];
	im_session.reg.align_mean = [];
	save_path = fullfile(session_path,['session_imaging_align_mean_' file_name_tag '.mat']);
	if overwrite ~= 1 && exist(save_path) == 2
	else
		save(save_path,'align_mean')
	end
end

save_path = fullfile(session_path,['session_imaging_summary_' file_name_tag '.mat']);
if overwrite ~= 1 && exist(save_path) == 2
else
	save(save_path,'im_session')
end

if behaviour_on
	global session_bv;
	session_bv = [];
	session_bv = conact_behaviour(num_files,session);
	save_path = fullfile(session_path,['session_behaviour_' file_name_tag '.mat']);
	if overwrite ~= 1 && exist(save_path) == 2
	else
		save(save_path,'session_bv')
	end
end

%save_path = fullfile(session_path,['session_ca_data_' file_name_tag '.mat']);
%if overwrite ~= 1 && exist(save_path) == 2
%else
%	save(save_path,'session_ca')
%end