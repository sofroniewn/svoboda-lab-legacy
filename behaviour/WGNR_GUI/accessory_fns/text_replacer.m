function text_replacer(trial_config,rig_config,ps_sites,fileIn,fileOut)
%%
% load('/Users/sofroniewn/Desktop/WGNR/NEW_GUI/NEW_GUI/Trial_configs/DEFAULT.mat')
% %% PARAMETERS FOR PHOTOSTIMULATION
% ps_sites.S1_x = 3.3;
% ps_sites.S1_y = -1.0;
% ps_sites.S2_x = 4.0;
% ps_sites.S2_y = -1.0;
% ps_sites.V1_x = 2.0;
% ps_sites.V1_y = -3.5;
% ps_sites.M1_x = 1.5;
% ps_sites.M1_y = 1.5;
% ps_sites.M2_x = 1.0;
% ps_sites.M2_y = 2.5;
% ps_sites.PPC_x = 1.7;
% ps_sites.PPC_y = -2.0;
% ps_sites.vM1_x = 0.5;
% ps_sites.vM1_y = 1.0;
% ps_sites.dither_x = [0, -1, 0, 1, 0];
% ps_sites.dither_y = [0, 0, -1, 0, 1];
% fileOut = './globals/globals_WGNR_MOD.c';
% fileIn = './globals/globals_WGNR.c';



ind = find(strcmp(trial_config.column_names,'Ps site'));
trial_ps_x_pos = ['{'];
trial_ps_y_pos = ['{'];
for ij = 1:trial_config.processed_dat.vals.num_trial_types;
    if strcmp(trial_config.dat{ij,ind},'S1')
        x_cord = ps_sites.S1_x;
        y_cord = ps_sites.S1_y;
    elseif strcmp(trial_config.dat{ij,ind},'S2')
        x_cord = ps_sites.S2_x;
        y_cord = ps_sites.S2_y;
    elseif strcmp(trial_config.dat{ij,ind},'V1')
        x_cord = ps_sites.V1_x;
        y_cord = ps_sites.V1_y;
    elseif strcmp(trial_config.dat{ij,ind},'M1')
        x_cord = ps_sites.M1_x;
        y_cord = ps_sites.M1_y;
    elseif strcmp(trial_config.dat{ij,ind},'M2')
        x_cord = ps_sites.M2_x;
        y_cord = ps_sites.M2_y;
    elseif strcmp(trial_config.dat{ij,ind},'vM1')
        x_cord = ps_sites.vM1_x;
        y_cord = ps_sites.vM1_y;
    elseif strcmp(trial_config.dat{ij,ind},'PPC')
        x_cord = ps_sites.PPC_x;
        y_cord = ps_sites.PPC_y;
    elseif strcmp(trial_config.dat{ij,ind},'Zero')
        x_cord = ps_sites.Zero_x;
        y_cord = ps_sites.Zero_y;
    else
        error('Unrecognised photostim site')
    end
    x_mir_vect = x_cord*ones(1,trial_config.processed_dat.vals.trial_num_ps_spots(ij,1));
    y_mir_vect = y_cord*ones(1,trial_config.processed_dat.vals.trial_num_ps_spots(ij,1));
    if trial_config.processed_dat.vals.trial_num_ps_hemi(ij,1) == 0
        x_mir_vect(trial_config.processed_dat.vals.trial_num_ps_spots(ij,1)/2+1:end) = -x_mir_vect(trial_config.processed_dat.vals.trial_num_ps_spots(ij,1)/2+1:end);
        if trial_config.processed_dat.vals.trial_dither_mag(ij,1) > 0
            x_mir_vect = x_mir_vect + trial_config.processed_dat.vals.trial_dither_mag(ij,1)*[ps_sites.dither_x ps_sites.dither_x]/1000;
            y_mir_vect = y_mir_vect + trial_config.processed_dat.vals.trial_dither_mag(ij,1)*[ps_sites.dither_y ps_sites.dither_y]/1000;
        end
    else
        x_mir_vect = trial_config.processed_dat.vals.trial_num_ps_hemi(ij,1)*x_mir_vect;
        if trial_config.processed_dat.vals.trial_dither_mag(ij,1) > 0
            x_mir_vect = x_mir_vect + trial_config.processed_dat.vals.trial_dither_mag(ij,1)*[ps_sites.dither_x]/1000;
            y_mir_vect = y_mir_vect + trial_config.processed_dat.vals.trial_dither_mag(ij,1)*[ps_sites.dither_y]/1000;
        end
    end
    
    if trial_config.processed_dat.vals.trial_num_ps_spots(ij) < trial_config.processed_dat.vals.max_num_ps_spots
        for ik = 1:trial_config.processed_dat.vals.max_num_ps_spots-trial_config.processed_dat.vals.trial_num_ps_spots(ij)
            x_mir_vect = [x_mir_vect 0];
            y_mir_vect = [y_mir_vect 0];
        end
    end
    trial_ps_x_pos = [trial_ps_x_pos '{'];
    trial_ps_y_pos = [trial_ps_y_pos '{'];
    for ik = 1:trial_config.processed_dat.vals.max_num_ps_spots
        trial_ps_x_pos = [trial_ps_x_pos num2str(x_mir_vect(ik)) ', '];
        trial_ps_y_pos = [trial_ps_y_pos num2str(y_mir_vect(ik)) ', '];
    end
    trial_ps_x_pos(end-1:end) = [];
    trial_ps_y_pos(end-1:end) = [];
    trial_ps_x_pos = [trial_ps_x_pos '}, '];
    trial_ps_y_pos = [trial_ps_y_pos '}, '];
end

trial_ps_x_pos(end-1:end) = [];
trial_ps_y_pos(end-1:end) = [];
trial_ps_x_pos_str = [trial_ps_x_pos '}'];
trial_ps_y_pos_str = [trial_ps_y_pos '}'];
trial_ps_x_pos_cell = eval(trial_ps_x_pos_str);
trial_ps_y_pos_cell = eval(trial_ps_y_pos_str);
trial_ps_x_pos = [];
trial_ps_y_pos = [];
for ij = 1:trial_config.processed_dat.vals.num_trial_types
    trial_ps_x_pos(ij,:) = cell2mat(trial_ps_x_pos_cell{ij});
    trial_ps_y_pos(ij,:) = cell2mat(trial_ps_y_pos_cell{ij});
end

trial_config.processed_dat.str.trial_ps_x_pos = trial_ps_x_pos_str;
trial_config.processed_dat.vals.trial_ps_x_pos = trial_ps_x_pos;
trial_config.processed_dat.str.trial_ps_y_pos = trial_ps_y_pos_str;
trial_config.processed_dat.vals.trial_ps_y_pos = trial_ps_y_pos;

%%
% Make sure the file exists.
if ~exist(fileIn, 'file')
    error('find_and_replace:no_file', ...
        ['File doesn''t exist. To replace strings in text, ' ...
        'use regexprep.']);
end

% Read in the file as binary and convert to chars.
fid = fopen(fileIn);
text = fread(fid, inf, '*char')';
fclose(fid);


%% Replace rig config params
% AI input channels
expression =  'const unsigned ball_tracker_clock_ai_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned ball_tracker_clock_ai_chan = ', rig_config.ai_channels_ball_tracker_clock ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned cam_ai_chan\[\w*\] = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned cam_ai_chan[4] = ', rig_config.ai_channels_cam ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned scan_image_frame_clock_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned scan_image_frame_clock_chan = ', rig_config.ai_channels_scan_image_frame_clock ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned lick_in_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned lick_in_chan = ', rig_config.ai_channels_lick ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned scim_logging_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned scim_logging_chan = ', rig_config.ai_channels_scim_logging ,';'];     text = regexprep(text,expression,replace);


% AO output channels - NOTE CHANNEL 8 is not functional
expression =  'const unsigned laser_power_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned laser_power_ao_chan = ', rig_config.ao_channels_laser_power ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned synch_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned synch_ao_chan = ', rig_config.ao_channels_synch ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned iti_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned iti_ao_chan = ', rig_config.ao_channels_iti ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned l_wall_lat_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned l_wall_lat_ao_chan = ', rig_config.ao_channels_l_wall_lat ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned l_wall_for_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned l_wall_for_ao_chan = ', rig_config.ao_channels_l_wall_for ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned r_wall_lat_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned r_wall_lat_ao_chan = ', rig_config.ao_channels_r_wall_lat ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned r_wall_for_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned r_wall_for_ao_chan = ', rig_config.ao_channels_r_wall_for ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned x_mirror_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned x_mirror_ao_chan = ', rig_config.ao_channels_x_mirror ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned y_mirror_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned y_mirror_ao_chan = ', rig_config.ao_channels_y_mirror ,';'];     text = regexprep(text,expression,replace);


% DIO channels - NOTE CHANNELS ABOVE 8 NOT FUNCTIONAL
expression =  'const unsigned water_valve_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned water_valve_trig = ', rig_config.dio_water_valve_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_iti_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_iti_trig = ', rig_config.dio_trial_iti_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned wv_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned wv_trig = ', rig_config.dio_wv_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned bv_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned bv_trig = ', rig_config.dio_bv_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned sound_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned sound_trig = ', rig_config.dio_sound_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned synch_pulse = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned synch_pulse = ', rig_config.dio_synch_pulse ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned sound_trig_2 = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned sound_trig_2 = ', rig_config.dio_sound_trig_2 ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_on_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_on_trig = ', rig_config.dio_trial_on_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_ephys_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_ephys_trig = ', rig_config.dio_trial_ephys_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_test_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_test_trig = ', rig_config.dio_trial_test_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned mf_dio_yellow = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned mf_dio_yellow = ', rig_config.dio_mf_dio_yellow ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned mf_dio_blue = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned mf_dio_blue = ', rig_config.dio_mf_dio_blue ,';'];     text = regexprep(text,expression,replace);


% AO offsets
expression =  'const double laser_power_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double laser_power_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_laser_power)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double synch_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double synch_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_synch)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double iti_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double iti_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_iti)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double l_wall_lat_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double l_wall_lat_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_l_wall_lat)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double l_wall_for_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double l_wall_for_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_l_wall_for)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double r_wall_lat_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double r_wall_lat_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_r_wall_lat)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double r_wall_for_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double r_wall_for_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_r_wall_for)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double x_mirror_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double x_mirror_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_x_mirror)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double y_mirror_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double y_mirror_ao_offset = ',num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_y_mirror)+1)) ,';'];     text = regexprep(text,expression,replace);



% Ball tracker
expression =  'const double A_calib\[\w*\]\[\w*\] = (\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double A_calib[3][4] =  ', rig_config.A_calib_str ,';'];     text = regexprep(text,expression,replace);

expression =  'const double zero_V\[\w*\] = (\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double zero_V[4] =  ', rig_config.zero_V_str ,';'];     text = regexprep(text,expression,replace);

expression =  'const double step_V = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double step_V =  ', num2str(rig_config.step_V) ,';'];     text = regexprep(text,expression,replace);

% Parameters
expression =  'const double sample_freq = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double sample_freq =  ', num2str(rig_config.sample_freq) ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned ai_threshold = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned ai_threshold =  ', num2str(rig_config.ai_threshold) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double run_speed_thresh = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double run_speed_thresh =  ', num2str(rig_config.run_speed_thresh) ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned speed_time_length = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned speed_time_length =  ', num2str(rig_config.speed_time_length) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double wall_ball_gain = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double wall_ball_gain =  ', num2str(rig_config.wall_ball_gain) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double max_wall_pos = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double max_wall_pos =  ', num2str(rig_config.max_wall_pos) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double max_cor_width = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double max_cor_width =  ', num2str(rig_config.max_cor_width) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double l_for_pos_default = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double l_for_pos_default =  ', num2str(rig_config.l_for_pos_default) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double r_for_pos_default = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double r_for_pos_default =  ', num2str(rig_config.r_for_pos_default) ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned bv_period = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned bv_period =  ', num2str(rig_config.bv_period) ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned wv_period = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned wv_period =  ', num2str(rig_config.wv_period) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double valve_open_time_default = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double valve_open_time_default =  ', num2str(rig_config.valve_open_time) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double max_galvo_pos = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double max_galvo_pos =  ', num2str(rig_config.max_galvo_pos) ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned ao_trial_trig_on = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned ao_trial_trig_on =  ', num2str(rig_config.ao_trial_trig_on) ,';'];     text = regexprep(text,expression,replace);

expression =  'double dist_thresh = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['double dist_thresh =  ', num2str(rig_config.dist_thresh) ,';'];     text = regexprep(text,expression,replace);

% Trial config
num_trial_types = trial_config.processed_dat.str.num_trial_types;

expression =  'const unsigned trial_num_types = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_num_types = ', num_trial_types ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_num_turns = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_num_turns = ',num2str(trial_config.processed_dat.vals.max_num_turns),';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_num_gain = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_num_gain = ',num2str(trial_config.processed_dat.vals.max_num_gain_changes),';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_num_open_loop = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_num_open_loop = ',num2str(trial_config.processed_dat.vals.max_num_ol_pos),';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_num_cor_widths = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_num_cor_widths = ',num2str(trial_config.processed_dat.vals.max_num_cor_widths_pos),';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_num_water_drops = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_num_water_drops = ',num2str(trial_config.processed_dat.vals.max_num_water),';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_random_order = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_random_order = ',num2str(trial_config.processed_dat.vals.random_order_flag),';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_num_sequence_length = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_num_sequence_length = ',num2str(trial_config.processed_dat.vals.trial_num_sequence_length),';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_num_sequence\[\w*\] = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
if trial_config.processed_dat.vals.trial_num_sequence_length>0
    replace    = ['const unsigned trial_num_sequence[', num2str(trial_config.processed_dat.vals.trial_num_sequence_length) , '] = ', trial_config.processed_dat.str.trial_num_sequence_str ,';'];
else
    replace    = ['const unsigned trial_num_sequence[', num2str(1) , '] = ', '{1}' ,';'];
end
text = regexprep(text,expression,replace);

expression =  'const unsigned trial_num_repeats\[\w*\] = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
if trial_config.processed_dat.vals.trial_num_sequence_length>0
    replace    = ['const unsigned trial_num_repeats[', num2str(trial_config.processed_dat.vals.trial_num_sequence_length) , '] = ', trial_config.processed_dat.str.trial_num_repeats_str ,';'];
else
    replace    = ['const unsigned trial_num_repeats[', num2str(1) , '] = ', '{1}' ,';'];
end
text = regexprep(text,expression,replace);


expression =  'const unsigned laser_calibration_mode = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned laser_calibration_mode = ', num2str(trial_config.processed_dat.vals.laser_calib_flag) ,';'];     text = regexprep(text,expression,replace);


expression =  'const unsigned trial_type\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_type[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_type ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_duration\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_duration[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_dur ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_timeout\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_timeout[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_timeout ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_iti\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_iti[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_iti ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_left_wall\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_left_wall[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_left_wall ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_right_wall\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_right_wall[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_right_wall ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_cor_reset\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_cor_reset[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_cor_reset ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_ol_positions\[\w*\]\[\w*\] = \{\{(\w*)(\W*)(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_ol_positions[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_ol_pos) , '] = ' trial_config.processed_dat.str.trial_ol_pos ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_ol_values\[\w*\]\[\w*\] = \{\{(\w*)(\W*)(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_ol_values[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_ol_pos) , '] = ' trial_config.processed_dat.str.trial_ol_vals ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_cor_width_positions\[\w*\]\[\w*\] = \{\{(\w*)(\W*)(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_cor_width_positions[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_cor_widths_pos) , '] = ' trial_config.processed_dat.str.trial_cor_width_pos ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_cor_width\[\w*\]\[\w*\] = \{\{(\w*)(\W*)(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_cor_width[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_cor_widths_pos) , '] = ' trial_config.processed_dat.str.trial_cor_widths_vals ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_turn_positions\[\w*\]\[\w*\] = \{\{(\w*)(\W*)(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_turn_positions[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_turns+1) , '] = ' trial_config.processed_dat.str.trial_turn_pos ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_turn_values\[\w*\]\[\w*\] = \{\{(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_turn_values[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_turns) , '] = ' trial_config.processed_dat.str.trial_turn_vals ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_gain_positions\[\w*\]\[\w*\] = \{\{(\w*)(\W*)(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_gain_positions[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_gain_changes+1) , '] = ' trial_config.processed_dat.str.trial_gain_pos ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_gain_values\[\w*\]\[\w*\] = \{\{(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_gain_values[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_gain_changes) , '] = ' trial_config.processed_dat.str.trial_gain_vals ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_test_period\[\w*\]\[\w*\] = \{\{(\W*)(\w*)(\W*)(\w*)(\W*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_test_period[', num_trial_types , '][', num2str(2) , '] = ' trial_config.processed_dat.str.trial_test_pos ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_water_enabled\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_water_enabled[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_water ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_water_pos\[\w*\]\[\w*\] = \{\{(\W*)(\w*)(\W*)(\w*)(\W*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_water_pos[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_water) , '] = ' trial_config.processed_dat.str.trial_water_pos ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_water_range_min\[\w*\]\[\w*\] = \{\{(\w*)(\W*)(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_water_range_min[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_water) , '] = ' trial_config.processed_dat.str.trial_water_range_min ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_water_range_max\[\w*\]\[\w*\] = \{\{(\w*)(\W*)(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_water_range_max[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_water) , '] = ' trial_config.processed_dat.str.trial_water_range_max ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_water_range_type\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_water_range_type[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_water_range_type ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_water_drop_size\[\w*\]\[\w*\] = \{\{(\w*)(\W*)(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_water_drop_size[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_water) , '] = ' trial_config.processed_dat.str.trial_water_drop_size ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_masking_flash\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_masking_flash[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_mf_type ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_mf_period\[\w*\]\[\w*\] = \{\{(\W*)(\w*)(\W*)(\w*)(\W*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_mf_period[', num_trial_types , '][', num2str(2) , '] = ' trial_config.processed_dat.str.trial_mf_pos ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_mf_pulse_dur\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_mf_pulse_dur[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_mf_pulse_dur ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_mf_pulse_iti\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_mf_pulse_iti[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_mf_pulse_iti ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_photostim\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_photostim[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_ps_type ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_ps_period\[\w*\]\[\w*\] = \{\{(\W*)(\w*)(\W*)(\w*)(\W*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_ps_period[', num_trial_types , '][', num2str(2) , '] = ' trial_config.processed_dat.str.trial_ps_pos ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_ps_pulse_dur\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_ps_pulse_dur[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_ps_pulse_dur ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_ps_pulse_iti\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_ps_pulse_iti[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_ps_pulse_iti ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_ps_num_sites\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_ps_num_sites[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_num_ps_spots ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_ps_peak_power\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_ps_peak_power[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_ps_peak_power ';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_ps_stop_threshold\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_ps_stop_threshold[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_ps_stop_thresh ';'];     text = regexprep(text,expression,replace);

expression =  'unsigned trial_ps_closed_loop\[\w*\] = \{(\W*)(\w*)(\W*)(\w*)\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['unsigned trial_ps_closed_loop[', num_trial_types , '] = ' trial_config.processed_dat.str.trial_ps_closed_loop ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_ps_x_pos\[\w*\]\[\w*\] = \{\{(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_ps_x_pos[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_ps_spots) , '] = ' trial_config.processed_dat.str.trial_ps_x_pos ';'];     text = regexprep(text,expression,replace);

expression =  'const double trial_ps_y_pos\[\w*\]\[\w*\] = \{\{(\w*)\}\};'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double trial_ps_y_pos[', num_trial_types , '][', num2str(trial_config.processed_dat.vals.max_num_ps_spots) , '] = ' trial_config.processed_dat.str.trial_ps_y_pos ';'];     text = regexprep(text,expression,replace);


% Write out the new file.
fid = fopen(fileOut, 'w');
fwrite(fid, text);
fclose(fid);
