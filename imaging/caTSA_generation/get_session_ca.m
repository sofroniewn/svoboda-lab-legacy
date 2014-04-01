function session_ca = get_session_ca(num_files,neuropilDilationRange,signalChannels,neuropilSubSF,file_name_tag,overwrite)

global im_session

% define session ca
caTSA_file_name = fullfile(im_session.ref.path_name,['CaTSA_' file_name_tag '_' im_session.ref.file_name '.mat']);
	
% if overwrite is off and session ca file exists load it in
if overwrite ~= 1 && exist(caTSA_file_name) == 2
	load(caTSA_file_name);
else
	session_ca = generate_session_ca(im_session,num_files,signalChannels,neuropilDilationRange);
	session_ca.im_session.reg = [];
	session_ca = calculate_dff(session_ca,im_session,neuropilSubSF);
	save(caTSA_file_name,'session_ca')
end




