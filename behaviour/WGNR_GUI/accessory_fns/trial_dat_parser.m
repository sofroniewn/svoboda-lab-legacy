function trial_config = trial_dat_parser(trial_config)

trial_config.processed_dat.vals.laser_calib_flag = trial_config.laser_calibration;
trial_config.processed_dat.vals.random_order_flag = trial_config.random_order;

if trial_config.random_order == 0 && isempty(trial_config.repeating_order) ==1
    error('Need to specify repeating order')
end

if trial_config.random_order == 0 && isempty(trial_config.repeating_numbers) ==1
    error('Need to specify number of repeats')
end

if isempty(trial_config.repeating_order) ~=1
    trial_config.processed_dat.vals.trial_num_sequence_length = numel(eval(trial_config.repeating_order));
    trial_config.processed_dat.str.trial_num_sequence_str = trial_config.repeating_order;
    trial_config.processed_dat.vals.trial_num_sequence = cell2mat(eval(trial_config.repeating_order));
    trial_config.processed_dat.str.trial_num_repeats_str = trial_config.repeating_numbers;
    trial_config.processed_dat.vals.trial_num_repeats = cell2mat(eval(trial_config.repeating_numbers));
else
    trial_config.processed_dat.vals.trial_num_sequence_length = 0;
    trial_config.processed_dat.str.trial_num_sequence_str = '';
    trial_config.processed_dat.vals.trial_num_sequence = 0;
    trial_config.processed_dat.str.trial_num_repeats_str = '';
    trial_config.processed_dat.vals.trial_num_repeats = 0;
end

% Number of trial types
num_trial_types = size(trial_config.dat,1);
trial_config.processed_dat.vals.num_trial_types = num_trial_types;
trial_config.processed_dat.str.num_trial_types = num2str(num_trial_types);

% Generate string of trial types
ind = find(strcmp(trial_config.column_names,'Type'));
tmp_str = ['{'];
for ij = 1:num_trial_types
    if strcmp(trial_config.dat{ij,ind},'Distance')
        tmp_str = [tmp_str '1, '];
    elseif strcmp(trial_config.dat{ij,ind},'Time')
        tmp_str = [tmp_str '0, '];
    else
        error('Unrecognised trial type')
    end
end
tmp_str(end-1:end) = [];
tmp_str = [tmp_str '}'];
trial_config.processed_dat.str.trial_type = tmp_str;
trial_config.processed_dat.vals.trial_type = cell2mat(eval(tmp_str))';

% Generate string of trial durations
ind = find(strcmp(trial_config.column_names,'Duration (cm)'));
tmp_str = ['{'];
for ij = 1:num_trial_types
    tmp_str = [tmp_str num2str(trial_config.dat{ij,ind}) ', '];
end
tmp_str(end-1:end) = [];
tmp_str = [tmp_str '}'];
trial_config.processed_dat.str.trial_dur = tmp_str;
trial_config.processed_dat.vals.trial_dur = cell2mat(eval(tmp_str))';

% Generate string of trial time outs
ind = find(strcmp(trial_config.column_names,'Time out (s)'));
tmp_str = ['{'];
for ij = 1:num_trial_types
    tmp_str = [tmp_str num2str(trial_config.dat{ij,ind}) ', '];
end
tmp_str(end-1:end) = [];
tmp_str = [tmp_str '}'];
trial_config.processed_dat.str.trial_timeout = tmp_str;
trial_config.processed_dat.vals.trial_timeout = cell2mat(eval(tmp_str))';

% Generate string of trial ITIs
ind = find(strcmp(trial_config.column_names,'Inter-trial interval (s)'));
tmp_str = ['{'];
for ij = 1:num_trial_types
    tmp_str = [tmp_str num2str(trial_config.dat{ij,ind}) ', '];
end
tmp_str(end-1:end) = [];
tmp_str = [tmp_str '}'];
trial_config.processed_dat.str.trial_iti = tmp_str;
trial_config.processed_dat.vals.trial_iti = cell2mat(eval(tmp_str))';

% Generate string of left wall enabled
ind = find(strcmp(trial_config.column_names,'Left wall enabled'));
tmp_str = ['{'];
for ij = 1:num_trial_types
    tmp_str = [tmp_str num2str(trial_config.dat{ij,ind}) ', '];
end
tmp_str(end-1:end) = [];
tmp_str = [tmp_str '}'];
trial_config.processed_dat.str.trial_left_wall = tmp_str;
trial_config.processed_dat.vals.trial_left_wall = cell2mat(eval(tmp_str))';


% Generate string of right wall enabled
ind = find(strcmp(trial_config.column_names,'Right wall enabled'));
tmp_str = ['{'];
for ij = 1:num_trial_types
    tmp_str = [tmp_str num2str(trial_config.dat{ij,ind}) ', '];
end
tmp_str(end-1:end) = [];
tmp_str = [tmp_str '}'];
trial_config.processed_dat.str.trial_right_wall = tmp_str;
trial_config.processed_dat.vals.trial_right_wall = cell2mat(eval(tmp_str))';


% Generate string of right wall enabled
ind = find(strcmp(trial_config.column_names,'Corridor reset'));
tmp_str = ['{'];
for ij = 1:num_trial_types
    tmp_str = [tmp_str num2str(trial_config.dat{ij,ind}) ', '];
end
tmp_str(end-1:end) = [];
tmp_str = [tmp_str '}'];
trial_config.processed_dat.str.trial_cor_reset = tmp_str;
trial_config.processed_dat.vals.trial_cor_reset = cell2mat(eval(tmp_str))';

% Generate string of open loop positions
ind = find(strcmp(trial_config.column_names,'Open loop change positions'));
tmp_str_A = ['{'];
num_cor_widths = [];
for ij = 1:num_trial_types
    num_ol_pos(ij) = numel(eval(trial_config.dat{ij,ind}));
end
max_num_ol_pos = max(num_ol_pos);
for ij = 1:num_trial_types
    if num_ol_pos(ij) < max_num_ol_pos
        tmp_str = trial_config.dat{ij,ind};
        tmp_str(end) = [];
        for ik = 1:max_num_ol_pos-num_ol_pos(ij)
            tmp_str = [tmp_str ', 1'];
        end
        tmp_str = [tmp_str '}'];
        tmp_str_A = [tmp_str_A tmp_str ', '];
    else
        tmp_str_A = [tmp_str_A trial_config.dat{ij,ind} ', '];
    end
end
tmp_str_A(end-1:end) = [];
tmp_str_A = [tmp_str_A '}'];
tmp_str_A_cell = eval(tmp_str_A);
tmp = [];
for ij = 1:num_trial_types
    tmp(ij,:) = cell2mat(tmp_str_A_cell{ij});
end
trial_config.processed_dat.str.trial_ol_pos = tmp_str_A;
trial_config.processed_dat.vals.trial_ol_pos = tmp;
trial_config.processed_dat.vals.max_num_ol_pos = max_num_ol_pos;

% Generate cor width values
ind = find(strcmp(trial_config.column_names,'Open loop values'));
tmp_str_B = ['{'];
num_ol_vals = [];
for ij = 1:num_trial_types
    num_ol_vals(ij) = numel(eval(trial_config.dat{ij,ind}));
end
if unique(num_ol_vals - num_ol_pos) ~= 0
    error('Wrong number of ol positions and values')
end
for ij = 1:num_trial_types
    if num_ol_pos(ij) < max_num_ol_pos
        tmp_str = trial_config.dat{ij,ind};
        vals = eval(tmp_str);
        tmp_str(end) = [];
        for ik = 1:max_num_ol_pos-num_ol_pos(ij)
            tmp_str = [tmp_str ', ' num2str(vals{end})];
        end
        tmp_str = [tmp_str '}'];
        tmp_str_B = [tmp_str_B tmp_str ', '];
    else
        tmp_str_B = [tmp_str_B trial_config.dat{ij,ind} ', '];
    end
end
tmp_str_B(end-1:end) = [];
tmp_str_B = [tmp_str_B '}'];
trial_ol_vals_cell = eval(tmp_str_B);
trial_ol_vals = [];
for ij = 1:num_trial_types
    trial_ol_vals(ij,:) = cell2mat(trial_ol_vals_cell{ij});
end
trial_config.processed_dat.str.trial_ol_vals = tmp_str_B;
trial_config.processed_dat.vals.trial_ol_vals = trial_ol_vals;


% Generate string of corridor width positions
ind = find(strcmp(trial_config.column_names,'Corridor width change positions'));
tmp_str_A = ['{'];
num_cor_widths = [];
for ij = 1:num_trial_types
    num_cor_widths(ij) = numel(eval(trial_config.dat{ij,ind}));
end
max_num_cor_widths = max(num_cor_widths);
for ij = 1:num_trial_types
    if num_cor_widths(ij) < max_num_cor_widths
        tmp_str = trial_config.dat{ij,ind};
        tmp_str(end) = [];
        for ik = 1:max_num_cor_widths-num_cor_widths(ij)
            tmp_str = [tmp_str ', 1'];
        end
        tmp_str = [tmp_str '}'];
        tmp_str_A = [tmp_str_A tmp_str ', '];
    else
        tmp_str_A = [tmp_str_A trial_config.dat{ij,ind} ', '];
    end
end
tmp_str_A(end-1:end) = [];
tmp_str_A = [tmp_str_A '}'];
tmp_str_A_cell = eval(tmp_str_A);
tmp = [];
for ij = 1:num_trial_types
    tmp(ij,:) = cell2mat(tmp_str_A_cell{ij});
end
trial_config.processed_dat.str.trial_cor_width_pos = tmp_str_A;
trial_config.processed_dat.vals.trial_cor_width_pos = tmp;
trial_config.processed_dat.vals.max_num_cor_widths_pos = max_num_cor_widths;

% Generate cor width values
ind = find(strcmp(trial_config.column_names,'Corridor width values (mm)'));
tmp_str_B = ['{'];
num_cor_widths_vals = [];
for ij = 1:num_trial_types
    num_cor_widths_vals(ij) = numel(eval(trial_config.dat{ij,ind}));
end
if unique(num_cor_widths - num_cor_widths_vals) ~= 0
    error('Wrong number of corridor width positions and values')
end
max_num_cor_widths_vals = max(num_cor_widths_vals);
for ij = 1:num_trial_types
    if num_cor_widths_vals(ij) < max_num_cor_widths_vals
        tmp_str = trial_config.dat{ij,ind};
        vals = eval(tmp_str);
        tmp_str(end) = [];
        for ik = 1:max_num_cor_widths_vals-num_cor_widths_vals(ij)
            tmp_str = [tmp_str ', ' num2str(vals{end})];
        end
        tmp_str = [tmp_str '}'];
        tmp_str_B = [tmp_str_B tmp_str ', '];
    else
        tmp_str_B = [tmp_str_B trial_config.dat{ij,ind} ', '];
    end
end
tmp_str_B(end-1:end) = [];
tmp_str_B = [tmp_str_B '}'];
trial_cor_widths_vals_cell = eval(tmp_str_B);
trial_cor_widths_vals = [];
for ij = 1:num_trial_types
    trial_cor_widths_vals(ij,:) = cell2mat(trial_cor_widths_vals_cell{ij});
end
trial_config.processed_dat.str.trial_cor_widths_vals = tmp_str_B;
trial_config.processed_dat.vals.trial_cor_widths_vals = trial_cor_widths_vals;


% Generate string of turn positions
ind = find(strcmp(trial_config.column_names,'Turn change positions'));
trial_turn_pos_str = ['{'];
num_turns = [];
for ij = 1:num_trial_types
    num_turns(ij) = numel(eval(trial_config.dat{ij,ind}));
end
max_num_turns = max(num_turns);
for ij = 1:num_trial_types
    if num_turns(ij) < max_num_turns
        tmp_str = trial_config.dat{ij,ind};
        tmp_str(end) = [];
        for ik = 1:max_num_turns-num_turns(ij)
            tmp_str = [tmp_str ', 1'];
        end
        tmp_str = [tmp_str '}'];
        trial_turn_pos_str = [trial_turn_pos_str tmp_str ', '];
    else
        trial_turn_pos_str = [trial_turn_pos_str trial_config.dat{ij,ind} ', '];
    end
end
trial_turn_pos_str(end-1:end) = [];
trial_turn_pos_str = [trial_turn_pos_str '}'];
trial_turn_pos_cell = eval(trial_turn_pos_str);
trial_turn_pos = [];
for ij = 1:num_trial_types
    trial_turn_pos(ij,:) = cell2mat(trial_turn_pos_cell{ij});
end
trial_config.processed_dat.str.trial_turn_pos = trial_turn_pos_str;
trial_config.processed_dat.vals.trial_turn_pos = trial_turn_pos;
trial_config.processed_dat.vals.max_num_turns = max_num_turns - 1;

% Generate string of turn values
ind = find(strcmp(trial_config.column_names,'Turn values (deg)'));
trial_turn_vals_str = ['{'];
num_turns_vals = [];
for ij = 1:num_trial_types
    num_turns_vals(ij) = numel(eval(trial_config.dat{ij,ind}));
end
if unique(num_turns - num_turns_vals) ~= 1
    error('Wrong number of turn positions and values')
end
max_num_turns_vals = max(num_turns_vals);
for ij = 1:num_trial_types
    if num_turns_vals(ij) < max_num_turns_vals
        tmp_str = trial_config.dat{ij,ind};
        tmp_str(end) = [];
        for ik = 1:max_num_turns_vals-num_turns_vals(ij)
            tmp_str = [tmp_str ', 0'];
        end
        tmp_str = [tmp_str '}'];
        trial_turn_vals_str = [trial_turn_vals_str tmp_str ', '];
    else
        trial_turn_vals_str = [trial_turn_vals_str trial_config.dat{ij,ind} ', '];
    end
end
trial_turn_vals_str(end-1:end) = [];
trial_turn_vals_str = [trial_turn_vals_str '}'];
trial_turn_vals_cell = eval(trial_turn_vals_str);
trial_turn_vals = [];
for ij = 1:num_trial_types
    trial_turn_vals(ij,:) = cell2mat(trial_turn_vals_cell{ij});
end
trial_config.processed_dat.str.trial_turn_vals = trial_turn_vals_str;
trial_config.processed_dat.vals.trial_turn_vals = trial_turn_vals;

% Generate string of gain change positions
ind = find(strcmp(trial_config.column_names,'Gain change positions'));
trial_gain_pos_str = ['{'];
num_gain_changes = [];
for ij = 1:num_trial_types
    num_gain_changes(ij) = numel(eval(trial_config.dat{ij,ind}));
end
max_num_gain_changes = max(num_gain_changes);
for ij = 1:num_trial_types
    if num_gain_changes(ij) < max_num_gain_changes
        tmp_str = trial_config.dat{ij,ind};
        tmp_str(end) = [];
        for ik = 1:max_num_gain_changes-num_gain_changes(ij)
            tmp_str = [tmp_str ', 1'];
        end
        tmp_str = [tmp_str '}'];
        trial_gain_pos_str = [trial_gain_pos_str tmp_str ', '];
    else
        trial_gain_pos_str = [trial_gain_pos_str trial_config.dat{ij,ind} ', '];
    end
end
trial_gain_pos_str(end-1:end) = [];
trial_gain_pos_str = [trial_gain_pos_str '}'];
trial_gain_pos_cell = eval(trial_gain_pos_str);
trial_gain_pos = [];
for ij = 1:num_trial_types
    trial_gain_pos(ij,:) = cell2mat(trial_gain_pos_cell{ij});
end
trial_config.processed_dat.str.trial_gain_pos = trial_gain_pos_str;
trial_config.processed_dat.vals.trial_gain_pos = trial_gain_pos;
trial_config.processed_dat.vals.max_num_gain_changes = max_num_gain_changes - 1;

% Generate string of gain values
ind = find(strcmp(trial_config.column_names,'Gain values'));
trial_gain_vals_str = ['{'];
num_gain_vals = [];
for ij = 1:num_trial_types
    num_gain_vals(ij) = numel(eval(trial_config.dat{ij,ind}));
end
if unique(num_gain_changes - num_gain_vals) ~= 1
    error('Wrong number of gain change positions and values')
end
max_num_gain_vals = max(num_gain_vals);
for ij = 1:num_trial_types
    if num_gain_vals(ij) < max_num_gain_vals
        tmp_str = trial_config.dat{ij,ind};
        tmp_str(end) = [];
        for ik = 1:max_num_gain_vals-num_gain_vals(ij)
            tmp_str = [tmp_str ', 1'];
        end
        tmp_str = [tmp_str '}'];
        trial_gain_vals_str = [trial_gain_vals_str tmp_str ', '];
    else
        trial_gain_vals_str = [trial_gain_vals_str trial_config.dat{ij,ind} ', '];
    end
end
trial_gain_vals_str(end-1:end) = [];
trial_gain_vals_str = [trial_gain_vals_str '}'];
trial_gain_vals_cell = eval(trial_gain_vals_str);
trial_gain_vals = [];
for ij = 1:num_trial_types
    trial_gain_vals(ij,:) = cell2mat(trial_gain_vals_cell{ij});
end
trial_config.processed_dat.str.trial_gain_vals = trial_gain_vals_str;
trial_config.processed_dat.vals.trial_gain_vals = trial_gain_vals;

% Generate string of test periods
ind = find(strcmp(trial_config.column_names,'Test trial period'));
trial_test_pos_str = ['{'];
num_test_pos = [];
for ij = 1:num_trial_types
    num_test_pos(ij) = numel(eval(trial_config.dat{ij,ind}));
end
max_num_test_pos = max(num_test_pos);
if unique(num_test_pos) ~= 2
    error('Wrong number of test period positions')
end
for ij = 1:num_trial_types
    trial_test_pos_str = [trial_test_pos_str trial_config.dat{ij,ind} ', '];
end
trial_test_pos_str(end-1:end) = [];
trial_test_pos_str = [trial_test_pos_str '}'];
trial_test_pos_cell = eval(trial_test_pos_str);
trial_test_pos = [];
for ij = 1:num_trial_types
    trial_test_pos(ij,:) = cell2mat(trial_test_pos_cell{ij});
end
trial_config.processed_dat.str.trial_test_pos = trial_test_pos_str;
trial_config.processed_dat.vals.trial_test_pos = trial_test_pos;
trial_config.processed_dat.vals.max_num_test_pos = max_num_test_pos;

% Generate string of water enabled
ind = find(strcmp(trial_config.column_names,'Water enabled'));
trial_water_str = ['{'];
for ij = 1:num_trial_types
    trial_water_str = [trial_water_str num2str(trial_config.dat{ij,ind}) ', '];
end
trial_water_str(end-1:end) = [];
trial_water_str = [trial_water_str '}'];
trial_water = cell2mat(eval(trial_water_str))';
trial_config.processed_dat.str.trial_water = trial_water_str;
trial_config.processed_dat.vals.trial_water = trial_water;

% Generate string of water positions
ind = find(strcmp(trial_config.column_names,'Water trial position'));
trial_water_pos_str = ['{'];
num_water_pos = [];
for ij = 1:num_trial_types
    num_water_pos(ij) = numel(eval(trial_config.dat{ij,ind}));
end
max_num_water_pos = max(num_water_pos);
for ij = 1:num_trial_types
    if num_water_pos(ij) < max_num_water_pos
        tmp_str = trial_config.dat{ij,ind};
        tmp_str(end) = [];
        for ik = 1:max_num_water_pos-num_water_pos(ij)
            tmp_str = [tmp_str ', 1'];
        end
        tmp_str = [tmp_str '}'];
        trial_water_pos_str = [trial_water_pos_str tmp_str ', '];
    else
        trial_water_pos_str = [trial_water_pos_str trial_config.dat{ij,ind} ', '];
    end
end
trial_water_pos_str(end-1:end) = [];
trial_water_pos_str = [trial_water_pos_str '}'];
trial_water_pos_cell = eval(trial_water_pos_str);
trial_water_pos = [];
for ij = 1:num_trial_types
    trial_water_pos(ij,:) = cell2mat(trial_water_pos_cell{ij});
end
trial_config.processed_dat.str.trial_water_pos = trial_water_pos_str;
trial_config.processed_dat.vals.trial_water_pos = trial_water_pos;
trial_config.processed_dat.vals.max_num_water = max_num_water_pos;

% Generate string of water ranges
ind = find(strcmp(trial_config.column_names,'Water corridor min'));
trial_water_range_str = ['{'];
num_water_range = [];
for ij = 1:num_trial_types
    num_water_range(ij) = numel(eval(trial_config.dat{ij,ind}));
end
max_num_water_range = max(num_water_range);
if unique(num_water_range - num_water_pos) ~= 0
    error('Wrong number of water range positions')
end
for ij = 1:num_trial_types
    if num_water_range(ij) < max_num_water_range
        tmp_str = trial_config.dat{ij,ind};
        tmp_str(end) = [];
        for ik = 1:max_num_water_range-num_water_range(ij)
            tmp_str = [tmp_str ', 0'];
        end
        tmp_str = [tmp_str '}'];
        trial_water_range_str = [trial_water_range_str tmp_str ', '];
    else
        trial_water_range_str = [trial_water_range_str trial_config.dat{ij,ind} ', '];
    end
end
trial_water_range_str(end-1:end) = [];
trial_water_range_str = [trial_water_range_str '}'];
trial_water_range_cell = eval(trial_water_range_str);
trial_water_range = [];
for ij = 1:num_trial_types
    trial_water_range(ij,:) = cell2mat(trial_water_range_cell{ij});
end
trial_config.processed_dat.str.trial_water_range_min = trial_water_range_str;
trial_config.processed_dat.vals.trial_water_range_min = trial_water_range;

% Generate string of water ranges
ind = find(strcmp(trial_config.column_names,'Water corridor max'));
trial_water_range_str = ['{'];
num_water_range = [];
for ij = 1:num_trial_types
    num_water_range(ij) = numel(eval(trial_config.dat{ij,ind}));
end
max_num_water_range = max(num_water_range);
if unique(num_water_range - num_water_pos) ~= 0
    error('Wrong number of water range positions')
end
for ij = 1:num_trial_types
    if num_water_range(ij) < max_num_water_range
        tmp_str = trial_config.dat{ij,ind};
        tmp_str(end) = [];
        for ik = 1:max_num_water_range-num_water_range(ij)
            tmp_str = [tmp_str ', 0'];
        end
        tmp_str = [tmp_str '}'];
        trial_water_range_str = [trial_water_range_str tmp_str ', '];
    else
        trial_water_range_str = [trial_water_range_str trial_config.dat{ij,ind} ', '];
    end
end
trial_water_range_str(end-1:end) = [];
trial_water_range_str = [trial_water_range_str '}'];
trial_water_range_cell = eval(trial_water_range_str);
trial_water_range = [];
for ij = 1:num_trial_types
    trial_water_range(ij,:) = cell2mat(trial_water_range_cell{ij});
end
trial_config.processed_dat.str.trial_water_range_max = trial_water_range_str;
trial_config.processed_dat.vals.trial_water_range_max = trial_water_range;

% Generate string of water range types
ind = find(strcmp(trial_config.column_names,'Water range'));
trial_water_range_type_str = ['{'];
for ij = 1:num_trial_types
    if strcmp(trial_config.dat{ij,ind},'Wall distance (mm)')
        trial_water_range_type_str = [trial_water_range_type_str '0, '];
    elseif strcmp(trial_config.dat{ij,ind},'Corridor range (fraction)')
        trial_water_range_type_str = [trial_water_range_type_str '1, '];
    elseif strcmp(trial_config.dat{ij,ind},'Run position (cm)')
        trial_water_range_type_str = [trial_water_range_type_str '2, '];
    else
        error('Unrecognised water range type')
    end
end
trial_water_range_type_str(end-1:end) = [];
trial_water_range_type_str = [trial_water_range_type_str '}'];
trial_water_range_type = cell2mat(eval(trial_water_range_type_str))';
trial_config.processed_dat.str.trial_water_range_type = trial_water_range_type_str;
trial_config.processed_dat.vals.trial_water_range_type = trial_water_range_type;

% Generate string of drop sizes
ind = find(strcmp(trial_config.column_names,'Water drop size (ms)'));
trial_water_range_str = ['{'];
num_water_range = [];
for ij = 1:num_trial_types
    num_water_range(ij) = numel(eval(trial_config.dat{ij,ind}));
end
max_num_water_range = max(num_water_range);
if unique(num_water_range - num_water_pos) ~= 0
    error('Wrong number of water range positions')
end
for ij = 1:num_trial_types
    if num_water_range(ij) < max_num_water_range
        tmp_str = trial_config.dat{ij,ind};
        tmp_str(end) = [];
        for ik = 1:max_num_water_range-num_water_range(ij)
            tmp_str = [tmp_str ', 0'];
        end
        tmp_str = [tmp_str '}'];
        trial_water_range_str = [trial_water_range_str tmp_str ', '];
    else
        trial_water_range_str = [trial_water_range_str trial_config.dat{ij,ind} ', '];
    end
end
trial_water_range_str(end-1:end) = [];
trial_water_range_str = [trial_water_range_str '}'];
trial_water_range_cell = eval(trial_water_range_str);
trial_water_range = [];
for ij = 1:num_trial_types
    trial_water_range(ij,:) = cell2mat(trial_water_range_cell{ij});
end
trial_config.processed_dat.str.trial_water_drop_size = trial_water_range_str;
trial_config.processed_dat.vals.trial_water_drop_size = trial_water_range;

% Generate string of masking flash conditions types
ind = find(strcmp(trial_config.column_names,'Masking flash'));
trial_mf_type_str = ['{'];
for ij = 1:num_trial_types
    if strcmp(trial_config.dat{ij,ind},'Off')
        trial_mf_type_str = [trial_mf_type_str '0, '];
    elseif strcmp(trial_config.dat{ij,ind},'Blue')
        trial_mf_type_str = [trial_mf_type_str '1, '];
    elseif strcmp(trial_config.dat{ij,ind},'Yellow')
        trial_mf_type_str = [trial_mf_type_str '2, '];
    else
        error('Unrecognised masking flash type')
    end
end
trial_mf_type_str(end-1:end) = [];
trial_mf_type_str = [trial_mf_type_str '}'];
trial_mf_type = cell2mat(eval(trial_mf_type_str))';
trial_config.processed_dat.str.trial_mf_type = trial_mf_type_str;
trial_config.processed_dat.vals.trial_mf_type = trial_mf_type;

% Generate string of mf periods
ind = find(strcmp(trial_config.column_names,'Mf trial period'));
trial_mf_pos_str = ['{'];
num_mf_pos = [];
for ij = 1:num_trial_types
    num_mf_pos(ij) = numel(eval(trial_config.dat{ij,ind}));
end
if unique(num_mf_pos) ~= 2
    error('Wrong number of mf period positions')
end
for ij = 1:num_trial_types
    trial_mf_pos_str = [trial_mf_pos_str trial_config.dat{ij,ind} ', '];
end
trial_mf_pos_str(end-1:end) = [];
trial_mf_pos_str = [trial_mf_pos_str '}'];
trial_mf_pos_cell = eval(trial_mf_pos_str);
trial_mf_pos = [];
for ij = 1:num_trial_types
    trial_mf_pos(ij,:) = cell2mat(trial_mf_pos_cell{ij});
end
trial_config.processed_dat.str.trial_mf_pos = trial_mf_pos_str;
trial_config.processed_dat.vals.trial_mf_pos = trial_mf_pos;

% Generate string of mf pulse duration
ind = find(strcmp(trial_config.column_names,'Mf pulse duration (ms)'));
trial_mf_pulse_dur_str = ['{'];
for ij = 1:num_trial_types
    val = trial_config.dat{ij,ind};
    if val == 1
        val = 0;
    end
    if mod(val,2) == 1
        error('Odd mf pulse durations not allowed')
    else
        val = val/2;
    end
    trial_mf_pulse_dur_str = [trial_mf_pulse_dur_str num2str(val) ', '];
end
trial_mf_pulse_dur_str(end-1:end) = [];
trial_mf_pulse_dur_str = [trial_mf_pulse_dur_str '}'];
trial_mf_pulse_dur = cell2mat(eval(trial_mf_pulse_dur_str))';
trial_config.processed_dat.str.trial_mf_pulse_dur = trial_mf_pulse_dur_str;
trial_config.processed_dat.vals.trial_mf_pulse_dur = trial_mf_pulse_dur;

% Generate string of mf inter pulse interval
ind = find(strcmp(trial_config.column_names,'Mf inter-pulse-interval (ms)'));
trial_mf_pulse_iti_str = ['{'];
for ij = 1:num_trial_types
    val = trial_config.dat{ij,ind};
    if val == 1
        val = 0;
    end
    if mod(val,2) == 1
        error('Odd mf pulse iti not allowed')
    else
        val = val/2;
    end
    trial_mf_pulse_iti_str = [trial_mf_pulse_iti_str num2str(val) ', '];
end
trial_mf_pulse_iti_str(end-1:end) = [];
trial_mf_pulse_iti_str = [trial_mf_pulse_iti_str '}'];
trial_mf_pulse_iti = cell2mat(eval(trial_mf_pulse_iti_str))';
trial_config.processed_dat.str.trial_mf_pulse_iti = trial_mf_pulse_iti_str;
trial_config.processed_dat.vals.trial_mf_pulse_iti = trial_mf_pulse_iti;


% Generate string of photo stim conditions
ind = find(strcmp(trial_config.column_names,'Photostimulation'));
trial_ps_type_str = ['{'];
for ij = 1:num_trial_types
    if strcmp(trial_config.dat{ij,ind},'Off')
        trial_ps_type_str = [trial_ps_type_str '0, '];
    elseif strcmp(trial_config.dat{ij,ind},'Blue')
        trial_ps_type_str = [trial_ps_type_str '1, '];
    elseif strcmp(trial_config.dat{ij,ind},'Yellow')
        trial_ps_type_str = [trial_ps_type_str '2, '];
    else
        error('Unrecognised masking flash type')
    end
end
trial_ps_type_str(end-1:end) = [];
trial_ps_type_str = [trial_ps_type_str '}'];
trial_ps_type = cell2mat(eval(trial_ps_type_str))';
trial_config.processed_dat.str.trial_ps_type = trial_ps_type_str;
trial_config.processed_dat.vals.trial_ps_type = trial_ps_type;

% Generate string of ps periods
ind = find(strcmp(trial_config.column_names,'Ps trial period'));
trial_ps_pos_str = ['{'];
num_ps_pos = [];
for ij = 1:num_trial_types
    num_ps_pos(ij) = numel(eval(trial_config.dat{ij,ind}));
end
if unique(num_ps_pos) ~= 2
    error('Wrong number of ps period positions')
end
for ij = 1:num_trial_types
    trial_ps_pos_str = [trial_ps_pos_str trial_config.dat{ij,ind} ', '];
end
trial_ps_pos_str(end-1:end) = [];
trial_ps_pos_str = [trial_ps_pos_str '}'];
trial_ps_pos_cell = eval(trial_ps_pos_str);
trial_ps_pos = [];
for ij = 1:num_trial_types
    trial_ps_pos(ij,:) = cell2mat(trial_ps_pos_cell{ij});
end
trial_config.processed_dat.str.trial_ps_pos = trial_ps_pos_str;
trial_config.processed_dat.vals.trial_ps_pos = trial_ps_pos;

% Generate string of ps pulse duration
ind = find(strcmp(trial_config.column_names,'Ps pulse duration (ms)'));
trial_ps_pulse_dur_str = ['{'];
for ij = 1:num_trial_types
    val = trial_config.dat{ij,ind};
    if val == 1
        val = 0;
    end
    if mod(val,2) == 1
        error('Odd ps pulse durations not allowed')
    else
        val = val/2;
    end
    trial_ps_pulse_dur_str = [trial_ps_pulse_dur_str num2str(val) ', '];
end
trial_ps_pulse_dur_str(end-1:end) = [];
trial_ps_pulse_dur_str = [trial_ps_pulse_dur_str '}'];
trial_ps_pulse_dur = cell2mat(eval(trial_ps_pulse_dur_str))';
trial_config.processed_dat.str.trial_ps_pulse_dur = trial_ps_pulse_dur_str;
trial_config.processed_dat.vals.trial_ps_pulse_dur = trial_ps_pulse_dur;

% Generate string of ps inter pulse interval
ind = find(strcmp(trial_config.column_names,'Ps inter-pulse-interval (ms)'));
trial_ps_pulse_iti_str = ['{'];
for ij = 1:num_trial_types
    val = trial_config.dat{ij,ind};
    if val == 1
        val = 0;
    end
   if mod(val,2) == 1
       error('Odd ps pulse iti not allowed')
   else
       val = val/2;
   end
    trial_ps_pulse_iti_str = [trial_ps_pulse_iti_str num2str(val) ', '];
end
trial_ps_pulse_iti_str(end-1:end) = [];
trial_ps_pulse_iti_str = [trial_ps_pulse_iti_str '}'];
trial_ps_pulse_iti = cell2mat(eval(trial_ps_pulse_iti_str))';
trial_config.processed_dat.str.trial_ps_pulse_iti = trial_ps_pulse_iti_str;
trial_config.processed_dat.vals.trial_ps_pulse_iti = trial_ps_pulse_iti;

% Generate string of Ps peak power
ind = find(strcmp(trial_config.column_names,'Ps peak power'));
trial_ps_peak_power_str = ['{'];
for ij = 1:num_trial_types
    trial_ps_peak_power_str = [trial_ps_peak_power_str num2str(trial_config.dat{ij,ind}) ', '];
end
trial_ps_peak_power_str(end-1:end) = [];
trial_ps_peak_power_str = [trial_ps_peak_power_str '}'];
trial_ps_peak_power = cell2mat(eval(trial_ps_peak_power_str))';
trial_config.processed_dat.str.trial_ps_peak_power = trial_ps_peak_power_str;
trial_config.processed_dat.vals.trial_ps_peak_power = trial_ps_peak_power;

% Generate string of Ps stop thresh
ind = find(strcmp(trial_config.column_names,'Ps stop thresh'));
trial_ps_stop_thresh_str = ['{'];
for ij = 1:num_trial_types
    trial_ps_stop_thresh_str = [trial_ps_stop_thresh_str num2str(trial_config.dat{ij,ind}) ', '];
end
trial_ps_stop_thresh_str(end-1:end) = [];
trial_ps_stop_thresh_str = [trial_ps_stop_thresh_str '}'];
trial_ps_stop_thresh = cell2mat(eval(trial_ps_stop_thresh_str))';
trial_config.processed_dat.str.trial_ps_stop_thresh = trial_ps_stop_thresh_str;
trial_config.processed_dat.vals.trial_ps_stop_thresh = trial_ps_stop_thresh;

% Generate string of Ps closed loop
ind = find(strcmp(trial_config.column_names,'Ps closed loop'));
trial_ps_closed_loop_str = ['{'];
for ij = 1:num_trial_types
    trial_ps_closed_loop_str = [trial_ps_closed_loop_str num2str(trial_config.dat{ij,ind}) ', '];
end
trial_ps_closed_loop_str(end-1:end) = [];
trial_ps_closed_loop_str = [trial_ps_closed_loop_str '}'];
trial_ps_closed_loop = cell2mat(eval(trial_ps_closed_loop_str))';
trial_config.processed_dat.str.trial_ps_closed_loop = trial_ps_closed_loop_str;
trial_config.processed_dat.vals.trial_ps_closed_loop = trial_ps_closed_loop;

% Generate string of Ps sites
ind = find(strcmp(trial_config.column_names,'Ps dither (um)'));
trial_dither_mag = zeros(num_trial_types,1);
for ij = 1:num_trial_types
    trial_dither_mag(ij,1) = trial_config.dat{ij,ind};
end
ind = find(strcmp(trial_config.column_names,'Ps hemisphere'));
trial_num_ps_centers = zeros(num_trial_types,1);
trial_num_ps_hemi = zeros(num_trial_types,1);
for ij = 1:num_trial_types
    if strcmp(trial_config.dat{ij,ind},'Bilateral') == 1
        trial_num_ps_centers(ij,1) = 2;
        trial_num_ps_hemi(ij,1) = 0;
    elseif strcmp(trial_config.dat{ij,ind},'Left') == 1
        trial_num_ps_centers(ij,1) = 1;
        trial_num_ps_hemi(ij,1) = 1;
    elseif strcmp(trial_config.dat{ij,ind},'Right') == 1
        trial_num_ps_centers(ij,1) = 1;
        trial_num_ps_hemi(ij,1) = -1;
    else
        error('Unrecognised photostim hemisphere')
    end
end
trial_num_ps_spots = zeros(num_trial_types,1);
trial_num_ps_spots_str = ['{'];
for ij = 1:num_trial_types
    if trial_dither_mag(ij,1) > 0
        trial_num_ps_spots(ij,1) = trial_num_ps_centers(ij,1)*5;
    else
        trial_num_ps_spots(ij,1) = trial_num_ps_centers(ij,1);
    end
    trial_num_ps_spots_str = [trial_num_ps_spots_str num2str(trial_num_ps_spots(ij,1)) ', '];
    [trial_num_ps_spots(ij,1) trial_ps_pulse_dur(ij)];
end
trial_num_ps_spots_str(end-1:end) = [];
trial_num_ps_spots_str = [trial_num_ps_spots_str '}'];
max_num_ps_spots = max(trial_num_ps_spots);
trial_config.processed_dat.vals.trial_num_ps_hemi = trial_num_ps_hemi;
trial_config.processed_dat.vals.trial_num_ps_centers = trial_num_ps_centers;
trial_config.processed_dat.vals.trial_dither_mag = trial_dither_mag;
trial_config.processed_dat.vals.max_num_ps_spots = max_num_ps_spots;
trial_config.processed_dat.vals.trial_num_ps_spots = trial_num_ps_spots;
trial_config.processed_dat.str.trial_num_ps_spots = trial_num_ps_spots_str;





% ind = find(strcmp(trial_config.column_names,'Ps site'));
% trial_ps_x_pos_str = ['{'];
% trial_ps_y_pos_str = ['{'];
% for ij = 1:num_trial_types
%     if strcmp(trial_config.dat{ij,ind},'S1')
%         x_cord = ps_sites.S1_x;
%         y_cord = ps_sites.S1_y;
%     elseif strcmp(trial_config.dat{ij,ind},'S2')
%         x_cord = ps_sites.S2_x;
%         y_cord = ps_sites.S2_y;
%     elseif strcmp(trial_config.dat{ij,ind},'V1')
%         x_cord = ps_sites.V1_x;
%         y_cord = ps_sites.V1_y;
%     elseif strcmp(trial_config.dat{ij,ind},'M1')
%         x_cord = ps_sites.M1_x;
%         y_cord = ps_sites.M1_y;
%     elseif strcmp(trial_config.dat{ij,ind},'M2')
%         x_cord = ps_sites.M2_x;
%         y_cord = ps_sites.M2_y;
%     elseif strcmp(trial_config.dat{ij,ind},'vM1')
%         x_cord = ps_sites.vM1_x;
%         y_cord = ps_sites.vM1_y;
%     elseif strcmp(trial_config.dat{ij,ind},'PPC')
%         x_cord = ps_sites.PPC_x;
%         y_cord = ps_sites.PPC_y;
%     elseif strcmp(trial_config.dat{ij,ind},'Zero')
%         x_cord = ps_sites.Zero_x;
%         y_cord = ps_sites.Zero_y;
%     else
%         error('Unrecognised photostim site')
%     end
%     x_mir_vect = x_cord*ones(1,trial_num_ps_spots(ij,1));
%     y_mir_vect = y_cord*ones(1,trial_num_ps_spots(ij,1));
%     if trial_num_ps_hemi(ij,1) == 0
%         x_mir_vect(trial_num_ps_spots(ij,1)/2+1:end) = -x_mir_vect(trial_num_ps_spots(ij,1)/2+1:end);
%         if trial_dither_mag(ij,1) > 0
%             x_mir_vect = x_mir_vect + trial_dither_mag(ij,1)*[ps_sites.dither_x ps_sites.dither_x]/1000;
%             y_mir_vect = y_mir_vect + trial_dither_mag(ij,1)*[ps_sites.dither_y ps_sites.dither_y]/1000;
%         end
%     else
%         x_mir_vect = trial_num_ps_hemi(ij,1)*x_mir_vect;
%         if trial_dither_mag(ij,1) > 0
%             x_mir_vect = x_mir_vect + trial_dither_mag(ij,1)*[ps_sites.dither_x]/1000;
%             y_mir_vect = y_mir_vect + trial_dither_mag(ij,1)*[ps_sites.dither_y]/1000;
%         end
%     end
%
%     if trial_num_ps_spots(ij) < max_num_ps_spots
%         for ik = 1:max_num_ps_spots-trial_num_ps_spots(ij)
%             x_mir_vect = [x_mir_vect 0];
%             y_mir_vect = [y_mir_vect 0];
%         end
%     end
%     trial_ps_x_pos_str = [trial_ps_x_pos_str '{'];
%     trial_ps_y_pos_str = [trial_ps_y_pos_str '{'];
%     for ik = 1:max_num_ps_spots
%         trial_ps_x_pos_str = [trial_ps_x_pos_str num2str(x_mir_vect(ik)) ', '];
%         trial_ps_y_pos_str = [trial_ps_y_pos_str num2str(y_mir_vect(ik)) ', '];
%     end
%     trial_ps_x_pos_str(end-1:end) = [];
%     trial_ps_y_pos_str(end-1:end) = [];
%     trial_ps_x_pos_str = [trial_ps_x_pos_str '}, '];
%     trial_ps_y_pos_str = [trial_ps_y_pos_str '}, '];
% end
%
% trial_ps_x_pos_str(end-1:end) = [];
% trial_ps_y_pos_str(end-1:end) = [];
% trial_ps_x_pos_str = [trial_ps_x_pos_str '}'];
% trial_ps_y_pos_str = [trial_ps_y_pos_str '}'];
% trial_ps_x_pos_cell = eval(trial_ps_x_pos_str);
% trial_ps_y_pos_cell = eval(trial_ps_y_pos_str);
% trial_ps_x_pos = [];
% trial_ps_y_pos = [];
% for ij = 1:num_trial_types
%     trial_ps_x_pos(ij,:) = cell2mat(trial_ps_x_pos_cell{ij});
%     trial_ps_y_pos(ij,:) = cell2mat(trial_ps_y_pos_cell{ij});
% end
% trial_config.processed_dat.str.trial_ps_x_pos = trial_ps_x_pos_str;
% trial_config.processed_dat.vals.trial_ps_x_pos = trial_ps_x_pos;
% trial_config.processed_dat.str.trial_ps_y_pos = trial_ps_y_pos_str;
% trial_config.processed_dat.vals.trial_ps_y_pos = trial_ps_y_pos;
