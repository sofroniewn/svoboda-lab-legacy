%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% WGNR RIG CALIBRATION FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters for WGNR GUI
rig_config.rig_name = 'Behaviour_rig'; % BASE DIRECTORY
rig_config.rig_room = 'JFRC_2W.353'; % BASE DIRECTORY
rig_config.base_dir = 'C:\Documents and Settings\USER\My Documents\code\njs_library\behaviour\WGNR_GUI'; % BASE DIRECTORY
rig_config.comp_ip_address = '192.168.1.2'; % COMPUTER IP ADDRESS
rig_config.globals_name = 'globals_WGNR.c'; % base globals file
rig_config.treadmill_str = 'treadmill2';
rig_config.data_dir = 'C:\Documents and Settings\USER\My Documents\WGNR_DATA'; % DATA DIRECTORY
rig_config.TCP_IP_address = [];


% Parameters for globals file
% AI input channels
rig_config.ai_channels_ball_tracker_clock = '0';
rig_config.ai_channels_cam = '{1, 2, 3, 4}';
rig_config.ai_channels_scan_image_frame_clock = '5';
rig_config.ai_channels_lick = '6';
rig_config.ai_channels_scim_logging = '7';

% AO output channels - NOTE CHANNEL 8 is not functional
rig_config.ao_channels_laser_power = '1';
rig_config.ao_channels_synch = '0';
rig_config.ao_channels_iti = '8';
rig_config.ao_channels_l_wall_lat = '2';
rig_config.ao_channels_l_wall_for = '3';
rig_config.ao_channels_r_wall_lat = '4';
rig_config.ao_channels_r_wall_for = '5';
rig_config.ao_channels_x_mirror = '6';
rig_config.ao_channels_y_mirror = '7';

% AO offset values
rig_config.ao_offsets = [-0.115; -0.125; -0.125; -0.125; -0.119; -0.122; -0.128; -0.110; 0];

% DIO channels - NOTE CHANNELS ABOVE 8 NOT FUNCTIONAL
rig_config.dio_water_valve_trig = '0';
rig_config.dio_trial_iti_trig = '11';
rig_config.dio_wv_trig = '2';
rig_config.dio_bv_trig = '4';
rig_config.dio_sound_trig = '3';
rig_config.dio_synch_pulse = '1';
rig_config.dio_sound_trig_2 = '10';
rig_config.dio_trial_on_trig = '6';
rig_config.dio_trial_ephys_trig = '7';
rig_config.dio_trial_test_trig = '8';
rig_config.dio_mf_dio_yellow = '9';
rig_config.dio_mf_dio_blue = '5';


% Ball tracker calibration values
rig_config.A_calib_str = '{{-0.3440, -5.4480, 0.2265, -0.3738}, {0.2564, -0.1580, 0.1903, 4.5241}, {-2.0053, 0.4055, -2.5573, 0.5321}}'; % Ball motion calibration matrix
rig_config.zero_V_str = '{2.371,2.378,2.376,2.377}';
rig_config.step_V = 0.145;

% General parameters
rig_config.sample_freq = 500;
rig_config.ai_threshold = 3;
rig_config.run_speed_thresh = 5;
rig_config.speed_time_length = 250;
rig_config.wall_ball_gain = -.2;

rig_config.max_wall_pos = 40;
rig_config.max_cor_width = 99;
rig_config.l_for_pos_default = 20;
rig_config.r_for_pos_default = 20;

% Video frame rates
rig_config.bv_period = 5; % behavioural video frame period / 2 in ms
rig_config.wv_period = 1; % whisker video frame period / 2 in ms

rig_config.valve_open_time = 50; % Time water valve open for at 500 Hz

rig_config.max_galvo_pos = 5;

rig_config.ao_trial_trig_on = 0;

rig_config.dist_thresh = 200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tmp = eval(rig_config.A_calib_str);
rig_config.A_inv = [];
for ij = 1:3
    rig_config.A_inv(ij,:) = cell2mat(tmp{ij});
end
rig_config.A_inv = rig_config.A_inv/rig_config.sample_freq;

