
global im_session
num_files = numel(im_session.basic_info.cur_files);

neuropilDilationRange = [3 8];
signalChannels = 1;
num_files = 6;
neuropilSubSF = -1;
overwrite = 0;
file_name_tag = 'cells';

session_ca = get_session_ca(num_files,neuropilDilationRange,signalChannels,neuropilSubSF,file_name_tag,overwrite);
