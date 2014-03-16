%% PREPROCESS CA DATA
base_drive = 'G:';
base_session = '\an234869\2014_01_16\run_02';
cluster_base = 'S:\Janelia\wgnr\data\processed';
base_path = fullfile(base_drive,base_session);
overwrite_improps = 0;
overwrite_parsed_data = 0;
d = func_preprocess_scim(base_path,overwrite_improps,overwrite_parsed_data);

%% Generate and save text file for each plane
func_im2text(base_path,base_session)
%% Generate and save text file for each plane
func_im2text_trial(base_path,cluster_base,base_session)

%% Put data on cluster
cluster_stim = fullfile(cluster_base,base_session,'stim');
cluster_raw = fullfile(cluster_base,base_session,'raw');
if exist(cluster_raw,'dir') ~= 7
    mkdir(cluster_raw);
end
if exist(cluster_stim,'dir') ~= 7
    mkdir(cluster_stim);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%