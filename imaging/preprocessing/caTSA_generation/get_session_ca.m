function session_ca = get_session_ca(caTSA_file_name,num_files,neuropilDilationRange,signalChannels,neuropilSubSF,file_name_tag,overwrite,handles)

global im_session	
% if overwrite is off and session ca file exists load it in
if overwrite ~= 1 && exist(caTSA_file_name) == 2
	fprintf('(caTSA)  load file\n');
	load(caTSA_file_name);
else
	session_ca = generate_session_ca(im_session,num_files,signalChannels,neuropilDilationRange,handles,overwrite);
	session_ca.im_session.reg = [];
	session_ca = calculate_dff(session_ca,im_session,neuropilSubSF);
	save(caTSA_file_name,'session_ca')
	fprintf('(caTSA)  saved file\n');
end




