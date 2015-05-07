%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% WGNR RIG CALIBRATION FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters for WGNR GUI
rig_config.rig_name = 'Imaging_rig'; % BASE DIRECTORY
rig_config.rig_room = 'JFRC_2W.333'; % BASE DIRECTORY
rig_config.base_dir = 'E:\Documents and Settings\user\My Documents\MATLAB\code\wgnr\behaviour\mVR_GUI'; % BASE DIRECTORY
rig_config.comp_ip_address = '10.102.22.52'; % COMPUTER IP ADDRESS
rig_config.globals_name = 'globals_mVR.c'; % base globals file
rig_config.treadmill_str = 'treadmill4';
rig_config.data_dir = 'E:\Documents and Settings\user\My Documents\mVR_DATA'; % DATA DIRECTORY
rig_config.TCP_IP_address = '10.102.22.49';
rig_config.accesory_path = 'X:\Nick\mVR_DATA';
rig_config.screenComPort = '/dev/tty.usbmodem1411';


% Parameters for globals file
% AI input channels
rig_config.ai_channels_ball_tracker_clock = '0';
rig_config.ai_channels_cam = '{1, 2, 3, 4}';
rig_config.ai_channels_scan_image_frame_clock = '5';
rig_config.ai_channels_lick = '6';
rig_config.ai_channels_scim_logging = '7';

% AO output channels - NOTE CHANNEL 8 is not functional
rig_config.ao_channels_maze_num = '0';
rig_config.ao_channels_synch = '8';
rig_config.ao_channels_iti = '1';
rig_config.ao_channels_c_wall_lat = '4';
rig_config.ao_channels_c_wall_for = '5';
rig_config.ao_channels_l_wall_lat = '3';
rig_config.ao_channels_r_wall_lat = '2';
rig_config.ao_channels_maze_for = '6';
rig_config.ao_channels_maze_lat = '7';

% AO offset values
rig_config.ao_offsets = [-0.115; -0.113; -0.118; -0.120; -0.121; -0.120; -0.115; -0.115; 0];

% DIO channels - NOTE CHANNELS ABOVE 8 NOT FUNCTIONAL
rig_config.dio_water_valve_trig = '0';
rig_config.dio_trial_iti_trig = '1';
rig_config.dio_wv_trig = '2';
rig_config.dio_bv_trig = '3';
rig_config.dio_screen_on_trig = '4';
rig_config.dio_synch_pulse = '5';
rig_config.dio_trial_on_trig = '6';
rig_config.dio_sound_cue = '7';
rig_config.dio_trial_ephys_trig = '8';


% Ball tracker calibration values
%rig_config.A_calib_str = '{{-0.1331, -7.7882, 0.1671, 0.0856}, {0.1133, 0.1117, 0.2213, 8.1600}, {-4.0722, 0, -4.4783, 0}}'; % Ball motion calibration matrix
rig_config.A_calib_str = '{{-0.0665, -3.8941, 0.0835, 0.0428}, {0.0566, 0.0558, 0.1107, 4.0800}, {-2.0361, 0, -2.2392, 0}}';
rig_config.zero_V_str = '{2.59, 2.61, 2.60, 2.61}';
rig_config.step_V = 0.154;

% General parameters
rig_config.sample_freq = 500;
rig_config.ai_threshold = 3;
rig_config.run_speed_thresh = 5;
rig_config.speed_time_length = 250;

rig_config.max_wall_pos = 40;
rig_config.max_wall_for_pos = 30;

% Video frame rates
rig_config.bv_period = 5; % behavioural video frame period / 2 in ms
rig_config.wv_period = 1; % whisker video frame period / 2 in ms

rig_config.valve_open_time = 50; % Time water valve open for at 500 Hz

rig_config.ao_trial_trig_on = 1;

rig_config.dist_thresh = 200;

rig_config.sound_on_length = .1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tmp = eval(rig_config.A_calib_str);
rig_config.A_inv = [];
for ij = 1:3
    rig_config.A_inv(ij,:) = cell2mat(tmp{ij});
end
rig_config.A_inv = rig_config.A_inv/rig_config.sample_freq;

