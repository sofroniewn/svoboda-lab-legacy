
base_im_path = '/Volumes/wdbp/imreg/sofroniewn/anm_0216166/2013_07_16/run_02/scanimage/an216166_2013_07_16_run_02_sbv_01_main_050.tif';
ref = generate_reference(base_im_path,1,1);


base_im_path = '/Volumes/wdbp/imreg/sofroniewn/anm_0216166/2013_07_17/run_01/scanimage/an216166_2013_07_17_run_01_sbv_01_main_050.tif';
ref = generate_reference(base_im_path,1,1);


base_im_path = '/Volumes/wdbp/imreg/sofroniewn/anm_0216166/2013_07_18/run_01/scanimage/an216166_2013_07_18_run_01_sbv_01_main_050.tif';
ref = generate_reference(base_im_path,1,1);


data_dir = '/Volumes/wdbp/imreg/sofroniewn/anm_0216166/2013_07_18/run_01/';
over_write = 0;
convert_name = 'open_cl_task';
wgnr_dir = '/Users/sofroniewn/github/wgnr/behaviour/WGNR_GUI';
convert_legacy_behaviour(data_dir,convert_name,over_write,wgnr_dir);


data_dir = '/Volumes/wdbp/imreg/sofroniewn/anm_0216166/2013_07_17/run_01/';
over_write = 0;
convert_name = 'open_cl_task';
wgnr_dir = '/Users/sofroniewn/github/wgnr/behaviour/WGNR_GUI';
convert_legacy_behaviour(data_dir,convert_name,over_write,wgnr_dir);


data_dir = '/Volumes/wdbp/imreg/sofroniewn/anm_0216166/2013_07_16/run_02/';
over_write = 0;
convert_name = 'open_cl_task';
wgnr_dir = '/Users/sofroniewn/github/wgnr/behaviour/WGNR_GUI';
convert_legacy_behaviour(data_dir,convert_name,over_write,wgnr_dir);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

base_name = '/Volumes/wdbp/imreg/sofroniewn/anm_0216166/2013_07_18/run_01';
first_file = load(fullfile(base_name,'scanimage/summary/an216166_2013_07_18_run_01_sbv_01_summary_002.mat'));

base_name = '/Volumes/wdbp/imreg/sofroniewn/anm_0216166/2013_07_17/run_01';
first_file = load(fullfile(base_name,'scanimage/summary/an216166_2013_07_17_run_01_sbv_01_summary_002.mat'));

base_name = '/Volumes/wdbp/imreg/sofroniewn/anm_0216166/2013_07_16/run_02';
first_file = load(fullfile(base_name,'scanimage/summary/an216166_2013_07_16_run_02_sbv_01_summary_002.mat'));


im_stats = get_image_stats(base_name);

%im_stats
global session

figure(14);
clf(14)
hold on
plot(session.trial_info.scim_num_trigs/4,'r')
plot(im_stats.num_frames(1:end),'b')
%plot(im_stats.num_frames(2:end),'b')


figure(14);
clf(14)
hold on
plot(im_stats.firstFrame(1:end),'b')


global im_session
im_session.reg.nFrames = im_stats.num_frames;
im_session.reg.startFrame = im_stats.firstFrame;

global scim_first_offset
%scim_first_offset = im_stats.firstFrame(2) - 1 - 1;
scim_first_offset = first_file.im_summary.props.firstFrame -1-4;
remove_first = 1;
save(fullfile(base_name,'scanimage','sync_offsets.mat'),'remove_first','scim_first_offset')
for ij = 1:length(im_stats.num_frames)-1
	fprintf('ALIGN %d/%d\n',ij,length(im_stats.num_frames)-1);
	trial_num_session = ij;
	trial_num_im_session = ij;	
	remove_first = func_scim_align_session(trial_num_session,trial_num_im_session,remove_first);
end

