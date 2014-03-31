
global im_session
    

num_planes = im_session.ref.im_props.numPlanes;

[im_session.reg.nFrames(1:15) im_session.reg.startFrame(1:15)]

session.trial_info.scim_num_trigs(1:15)/4



scim_info = cell(length(im_session.reg.nFrames),1);
for ij = 1:length(im_session.reg.nFrames)
	scim_info{ij}.nframes = im_session.reg.nFrames(ij)*im_session.ref.im_props.numPlanes;
	scim_info{ij}.numPlanes = im_session.ref.im_props.numPlanes;
	scim_info{ij}.firstFrameNumberRelTrigger = im_session.reg.startFrame(ij);
end


 session_sync = func_scim_align_3(session,scim_info);


 session_sync.trial_info.firstFrameNumberRelTrigger(1:10)
 session_sync.trial_info.scim_num_frames(1:10)


 %%
 base_path_behaviour = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/behaviour/';
 base_path_behaviour =   '/Volumes/wdbp/imreg/sofroniewn/an234870/2014_03_22/run_01/behaviour/';


    global session;
    session = [];
    session = load_session_data(base_path_behaviour);
    session = parse_session_data(1,session);

trial_num = 8;
figure(1)
clf(1)
hold on
plot(session.data{trial_num}.trial_matrix(14,:))
plot(session.data{trial_num}.trial_matrix(16,:),'m')

plot(session.data{trial_num}.trial_matrix(9,:),'r','LineWidth',2)
plot(session.data{trial_num}.processed_matrix(6,:),'.g')
% 

fullpath = '/Volumes/wdbp/imreg/sofroniewn/an234870/2014_03_22/run_01/scanimage/an234870_2014_03_22_main_002.tif';
hdr = extern_scim_opentif(fullpath, 'header');


convert_name = 'Early JaeSung mice';
over_write = 1;
data_dir = '/Volumes/wdbp/imreg/sofroniewn/an234870/2014_03_22/run_01/';
convert_legacy_behaviour(data_dir,convert_name,over_write)





