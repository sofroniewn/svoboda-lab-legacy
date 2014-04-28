
filename = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/scanimage/memmap.dat';

t = memmapfile(filename, 'Writable', true, 'Format', 'uint16');

new_volume = rand(512,512,4);
new_volume = new_volume*200;
new_volume = new_volume(:);
volume_id = 1;

t.Data = uint16(cat(1,volume_id,new_volume));

ij = 1;
t.Data = uint16(cat(1,ij,200*rand(512*512*4,1))); ij = ij+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[im im_props] = load_image('/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/scanimage/an227254_2013_12_12_main_006.tif');

volume_id = 1;
new_volume = im(:,:,(volume_id-1)*4+1:4*volume_id); new_volume = new_volume(:); t.Data = int16(cat(1,volume_id,new_volume)); volume_id = volume_id+1;


for volume_id=1:35;
	new_volume = im(:,:,(volume_id-1)*4+1:4*volume_id); new_volume = new_volume(:); t.Data = int16(cat(1,volume_id,new_volume));
	pause(1/im_props.frameRate);
end

while volume_id < 36
	new_volume = im(:,:,(volume_id-1)*4+1:4*volume_id); new_volume = new_volume(:); t.Data = int16(cat(1,volume_id,new_volume));
	pause(1/im_props.frameRate);
	volume_id = volume_id+1;
	if volume_id == 36
		volume_id = 1;
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Have to write scan image user function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global im_session
    
filename = fullfile(handles.data_dir,'memmap.dat');
  % Create the communications file if it is not already there.
  [f, msg] = fopen(filename, 'wb');
  if f ~= -1
      fwrite(f, zeros(im_session.ref.im_props.height*im_session.ref.im_props.width*im_session.ref.im_props.numPlanes+1,1,'int16'), 'int16');
      fclose(f);
  else
      error('MATLAB:demo:send:cannotOpenFile', ...
            'Cannot open file "%s": %s.', filename, msg);
  end
  
  global mmap_data;
  mmap_data = memmapfile(filename, 'Writable', true, ...
        'Format', 'int16');
  global old_mmap_frame_num
  old_mmap_frame_num = 0;

  im_session.realtime.im_raw = zeros(im_session.ref.im_props.height,im_session.ref.im_props.width,im_session.ref.im_props.numPlanes,10);
  im_session.realtime.ind = 1;
  im_session.realtime.start = 0;
  
  update_im = get(handles.checkbox_plot_images,'value');
  contents = cellstr(get(handles.popupmenu_list_plots,'String'));
  plot_str = contents{get(handles.popupmenu_list_plots,'Value')};

  if update_im == 1 && strcmp(plot_str,'plot_realtime_raw.m') == 1
    im_data = plot_im_gui(handles,0);
    im_plot = get(handles.axes_images,'Children');
    set(im_plot,'CData',im_data)
  end




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





