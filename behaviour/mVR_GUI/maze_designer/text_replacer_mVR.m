function text_replacer_mVR(maze_config,rig_config,fileIn,fileOut)

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
expression =  'const unsigned maze_num_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned maze_num_ao_chan = ', rig_config.ao_channels_maze_num ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned synch_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned synch_ao_chan = ', rig_config.ao_channels_synch ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned iti_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned iti_ao_chan = ', rig_config.ao_channels_iti ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned l_wall_lat_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned l_wall_lat_ao_chan = ', rig_config.ao_channels_l_wall_lat ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned c_wall_for_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned c_wall_for_ao_chan = ', rig_config.ao_channels_c_wall_for ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned r_wall_lat_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned r_wall_lat_ao_chan = ', rig_config.ao_channels_r_wall_lat ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned c_wall_lat_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned c_wall_lat_ao_chan = ', rig_config.ao_channels_c_wall_lat ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned maze_for_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned maze_for_ao_chan = ', rig_config.ao_channels_maze_for ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned maze_lat_ao_chan = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned maze_lat_ao_chan = ', rig_config.ao_channels_maze_lat ,';'];     text = regexprep(text,expression,replace);


% DIO channels - NOTE CHANNELS ABOVE 8 NOT FUNCTIONAL
expression =  'const unsigned water_valve_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned water_valve_trig = ', rig_config.dio_water_valve_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_iti_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_iti_trig = ', rig_config.dio_trial_iti_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned wv_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned wv_trig = ', rig_config.dio_wv_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned bv_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned bv_trig = ', rig_config.dio_bv_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned screen_on_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned screen_on_trig = ', rig_config.dio_screen_on_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned synch_pulse = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned synch_pulse = ', rig_config.dio_synch_pulse ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_on_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_on_trig = ', rig_config.dio_trial_on_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned trial_ephys_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned trial_ephys_trig = ', rig_config.dio_trial_ephys_trig ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned sound_cue_trig = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned sound_cue_trig = ', rig_config.dio_sound_cue ,';'];     text = regexprep(text,expression,replace);


% AO offsets
expression =  'const double maze_num_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double maze_num_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_maze_num)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double synch_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double synch_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_synch)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double iti_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double iti_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_iti)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double l_wall_lat_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double l_wall_lat_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_l_wall_lat)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double c_wall_for_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double c_wall_for_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_c_wall_for)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double r_wall_lat_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double r_wall_lat_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_r_wall_lat)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double c_wall_lat_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double c_wall_lat_ao_offset = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_c_wall_lat)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double x_mirror_maze_for = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double x_mirror_maze_for = ', num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_maze_for)+1)) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double maze_lat_ao_offset = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double maze_lat_ao_offset = ',num2str(rig_config.ao_offsets(str2num(rig_config.ao_channels_maze_lat)+1)) ,';'];     text = regexprep(text,expression,replace);


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

expression =  'const double max_wall_pos = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double max_wall_pos =  ', num2str(rig_config.max_wall_pos) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double max_wall_for_pos = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double max_wall_for_pos =  ', num2str(rig_config.max_wall_for_pos) ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned bv_period = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned bv_period =  ', num2str(rig_config.bv_period) ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned wv_period = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned wv_period =  ', num2str(rig_config.wv_period) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double valve_open_time_default = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double valve_open_time_default =  ', num2str(rig_config.valve_open_time) ,';'];     text = regexprep(text,expression,replace);

expression =  'const unsigned ao_trial_trig_on = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const unsigned ao_trial_trig_on =  ', num2str(rig_config.ao_trial_trig_on) ,';'];     text = regexprep(text,expression,replace);

expression =  'double dist_thresh = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['double dist_thresh =  ', num2str(rig_config.dist_thresh) ,';'];     text = regexprep(text,expression,replace);

expression =  'const double sound_on_length = (\W*)(\w*)(\W*)(\w*);'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['const double sound_on_length =  ', num2str(rig_config.sound_on_length) ,';'];     text = regexprep(text,expression,replace);


expression =  'unsigned water_trig_on\[\w*\];'; %replace expressions of format [sign][digits][decimal][digits]
replace    = ['unsigned water_trig_on\[', num2str(maze_config.max_num_branches),'\];'];     text = regexprep(text,expression,replace);


% replace maze field names
names = fieldnames(maze_config);
for ij = 1:length(names)
    opt = 0;
    if ismember(ij,[1:4,7:10])
        old_size_str = '';
        new_size_str = '';
        old_val_str = '0';
        new_val_str = num2str(maze_config.(names{ij}));
    elseif ismember(ij,[5,6])
        old_size_str = '\[\]';
        if ij == 5
            opt = 1;
        end
        if maze_config.trial_num_sequence_length == 0
            new_size_str = ['[' num2str(1) ']'];
        else
            new_size_str = ['[' num2str(maze_config.trial_num_sequence_length) ']'];    
        end
        old_val_str = '{}';
        new_val_str = mat2strC(maze_config.(names{ij})-opt,1);
    elseif ismember(ij,[11,13:21])
        old_size_str = '\[\]';
        new_size_str = ['[' num2str(maze_config.num_mazes) ']'];
        old_val_str = '{}';
        if ij == 17
            opt = 1;
        end
        new_val_str = mat2strC(maze_config.(names{ij})-opt,1);
    else
        old_size_str = '\[\]\[\]';
        new_size_str = ['[' num2str(maze_config.num_mazes) '][' num2str(size(maze_config.(names{ij}),2)) ']'];
        old_val_str = '{{}}';
        if ismember(ij,[28,29,32])
            opt = 1;
        end
        new_val_str = mat2strC(maze_config.(names{ij})-opt,0);
    end
    expression =  ['X' names{ij} old_size_str ' = ' old_val_str ';'];
    replace    = [names{ij} new_size_str ' = ' new_val_str ';'];
    text = regexprep(text,expression,replace);
end

% Write out the new file.
fid = fopen(fileOut, 'w');
fwrite(fid, text);
fclose(fid);
