function maze_config = maze_dat_parser(load_dat)

num_mazes = size(load_dat.maze_names,1);
maze_array = cell(num_mazes,1);
num_branches = NaN(num_mazes,1);
for ij = 1:size(load_dat.maze_names,1)
    start_branch = load_dat.start_branch_array{ij};
    start_branch = str2double(start_branch);
    dat = load_dat.dat_array{ij};
    [maze dat] = create_maze(dat,start_branch);
    maze_array{ij} = maze;
    load_dat.dat_array{ij} = dat;
    num_branches(ij) = maze_array{ij}.num_branches;
end
max_num_branches = max(num_branches);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session variables
maze_config.num_mazes = num_mazes;
maze_config.max_num_branches = max_num_branches;
maze_config.trial_random_order = load_dat.trial_vars.random;
if maze_config.trial_random_order == 0
    maze_config.trial_num_sequence_length = numel(eval(load_dat.trial_vars.maze_repeats));
    maze_config.trial_num_sequence = cell2mat(eval(load_dat.trial_vars.maze_ids));
    maze_config.trial_num_repeats = cell2mat(eval(load_dat.trial_vars.maze_repeats));
else
    maze_config.trial_num_sequence_length = 0;
    maze_config.trial_num_sequence = 0;
    maze_config.trial_num_repeats = 0;
end
maze_config.session_timeout = load_dat.trial_vars.session_timeout;
maze_config.session_iti = load_dat.trial_vars.session_iti;
maze_config.session_drink_time = load_dat.trial_vars.session_drink_time;
maze_config.session_continuous_world = load_dat.trial_vars.session_continuous_trials;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% maze variables
maze_config.maze_num_branches = num_branches;
maze_config.maze_reward_patch = NaN(num_mazes,4);
for ij = 1:num_mazes
    maze_config.maze_reward_patch(ij,:) = maze_array{ij}.default_reward_patch;
end
maze_config.maze_reward_size = NaN(num_mazes,1);
for ij = 1:num_mazes
    maze_config.maze_reward_size(ij) = maze_array{ij}.reward_size;
end
maze_config.maze_wall_gain = NaN(num_mazes,1);
for ij = 1:num_mazes
    maze_config.maze_wall_gain(ij) = maze_array{ij}.wall_gain;
end
maze_config.maze_center_width = NaN(num_mazes,1);
for ij = 1:num_mazes
    maze_config.maze_center_width(ij) = maze_array{ij}.center_width;
end
maze_config.maze_screen_on_time = NaN(num_mazes,1);
for ij = 1:num_mazes
    maze_config.maze_screen_on_time(ij) = maze_array{ij}.screen_on;
end
maze_config.maze_initial_branch = NaN(num_mazes,1);
for ij = 1:num_mazes
    maze_config.maze_initial_branch(ij) = maze_array{ij}.initial.branch_id;
end
maze_config.maze_initial_branch_for_fraction = NaN(num_mazes,1);
for ij = 1:num_mazes
    maze_config.maze_initial_branch_for_fraction(ij) = maze_array{ij}.initial.branch_fraction;
end
maze_config.maze_initial_branch_lat_fraction = NaN(num_mazes,1);
for ij = 1:num_mazes
    maze_config.maze_initial_branch_lat_fraction(ij) = maze_array{ij}.initial.corridor_frac;
end
maze_config.maze_initial_for_cord = NaN(num_mazes,1);
for ij = 1:num_mazes
    maze_config.maze_initial_for_cord(ij) = maze_array{ij}.initial.y_cord;
end
maze_config.maze_initial_lat_cord = NaN(num_mazes,1);
for ij = 1:num_mazes
    maze_config.maze_initial_lat_cord(ij) = maze_array{ij}.initial.x_cord;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% branch variables
maze_config.branch_length = zeros(num_mazes,max_num_branches);
for ij = 1:num_mazes
    for ik = 1:num_branches(ij)
        maze_config.branch_length(ij,ik) = maze_array{ij}.length(ik);
    end
end
maze_config.branch_left_angle = zeros(num_mazes,max_num_branches);
for ij = 1:num_mazes
    for ik = 1:num_branches(ij)
        maze_config.branch_left_angle(ij,ik) = maze_array{ij}.left_angle(ik);
    end
end
maze_config.branch_right_angle = zeros(num_mazes,max_num_branches);
for ij = 1:num_mazes
    for ik = 1:num_branches(ij)
        maze_config.branch_right_angle(ij,ik) = maze_array{ij}.right_angle(ik);
    end
end
maze_config.branch_for_start = zeros(num_mazes,max_num_branches);
for ij = 1:num_mazes
    for ik = 1:num_branches(ij)
        maze_config.branch_for_start(ij,ik) = maze_array{ij}.for_maze_cord(ik);
    end
end
maze_config.branch_l_lat_start = zeros(num_mazes,max_num_branches);
for ij = 1:num_mazes
    for ik = 1:num_branches(ij)
        maze_config.branch_l_lat_start(ij,ik) = maze_array{ij}.l_wall_lat(ik);
    end
end
maze_config.branch_r_lat_start = zeros(num_mazes,max_num_branches);
for ij = 1:num_mazes
    for ik = 1:num_branches(ij)
        maze_config.branch_r_lat_start(ij,ik) = maze_array{ij}.r_wall_lat(ik);
    end
end
maze_config.branch_left_end = zeros(num_mazes,max_num_branches);
for ij = 1:num_mazes
    for ik = 1:num_branches(ij)
        maze_config.branch_left_end(ij,ik) = maze_array{ij}.left_end(ik);
    end
end
maze_config.branch_right_end = zeros(num_mazes,max_num_branches);
for ij = 1:num_mazes
    for ik = 1:num_branches(ij)
        maze_config.branch_right_end(ij,ik) = maze_array{ij}.right_end(ik);
    end
end
maze_config.branch_split = zeros(num_mazes,max_num_branches);
for ij = 1:num_mazes
    for ik = 1:num_branches(ij)
        maze_config.branch_split(ij,ik) = maze_array{ij}.split_branch(ik);
    end
end
maze_config.branch_reward = zeros(num_mazes,max_num_branches);
for ij = 1:num_mazes
    for ik = 1:num_branches(ij)
        maze_config.branch_reward(ij,ik) = maze_array{ij}.reward_branch(ik);
    end
end
maze_config.branch_parent = zeros(num_mazes,max_num_branches);
for ij = 1:num_mazes
    for ik = 1:num_branches(ij)
        maze_config.branch_parent(ij,ik) = maze_array{ij}.parent_branch(ik);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
