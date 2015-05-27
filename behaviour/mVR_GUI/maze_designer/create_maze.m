function [maze dat] = create_maze(dat,start_branch)

maze.num_branches = size(dat,1);

maze.wall_gain = 3; % wall ball gain 1 cm to # mm --- default 3

maze.initial.branch_id = start_branch;
maze.initial.branch_fraction = 0.5;

maze.start_wall_left = -15;
maze.start_wall_right = 15;

maze.default_reward_patch = [.1 .9, .2 .8]; %left right, back forward
maze.reward_size = 1;
maze.screen_on = 9999;

maze.initial.corridor_frac = 0.5;
maze.center_width = 15;
maze.dead_end_width = 15;
maze.max_wall_for_pos = 30;

if maze.initial.branch_id > maze.num_branches || isnan(start_branch) || maze.initial.branch_id <= 0
    error('Starting branch must be valid branch id')
end

maze.length = NaN(maze.num_branches,1);
maze.left_angle = NaN(maze.num_branches,1);
maze.right_angle = NaN(maze.num_branches,1);
maze.left_end = NaN(maze.num_branches,1); % 0 implies wall, # > 0 implies another branch
maze.right_end = NaN(maze.num_branches,1); % 0 implies wall, # > 0 implies another branch
maze.split_branch = NaN(maze.num_branches,1); % 0 implies wall, # > 0 implies another branch
maze.reward_branch = NaN(maze.num_branches,1); %%% [0 0] no reward, [0 1], reward spanning cor frac


for ij = 1:maze.num_branches
    maze.length(ij) = dat{ij,1};
    maze.left_angle(ij) = dat{ij,2};
    maze.right_angle(ij) = dat{ij,3};
    maze.left_end(ij) = dat{ij,4};
    if dat{ij,4} == 0 || dat{ij,5} == 0
        dat{ij,4} = 0;
        dat{ij,5} = 0;
    end
    maze.right_end(ij) = dat{ij,5};
    maze.reward_branch(ij) = dat{ij,6};
    maze.split_branch(ij) = maze.left_end(ij) ~= maze.right_end(ij);
end


maze.left_wall_traj = NaN(maze.num_branches,4);
maze.right_wall_traj = NaN(maze.num_branches,4);
maze.parent_branch = NaN(maze.num_branches,1);

%%% construct full maze
for ij = 1:maze.num_branches
    
    % branch one is always the bottom branch, has no parent branch
    if ij == 1
        maze.parent_branch(ij) = 0;
        init_left = [maze.start_wall_left 0];
        init_right = [maze.start_wall_right 0];
    else
        
        % make sure each branch gets assigned correct parent node
        left_parent_branch = find(maze.left_end(:,1) == ij);
        right_parent_branch = find(maze.right_end(:,1) == ij);
        if isempty(left_parent_branch) && isempty(right_parent_branch)
            error('Each branch apart from the first must have a parent')
        elseif isempty(left_parent_branch)
            maze.parent_branch(ij) = right_parent_branch;
            init_left = (maze.right_wall_traj(maze.parent_branch(ij),3:4)+maze.left_wall_traj(maze.parent_branch(ij),3:4))/2;
            init_left(1) = init_left(1) + maze.center_width/2;
            init_right = maze.right_wall_traj(maze.parent_branch(ij),3:4);
        elseif isempty(right_parent_branch)
            maze.parent_branch(ij) = left_parent_branch;
            init_left = maze.left_wall_traj(maze.parent_branch(ij),3:4);
            init_right = (maze.right_wall_traj(maze.parent_branch(ij),3:4)+maze.left_wall_traj(maze.parent_branch(ij),3:4))/2;
            init_right(1) = init_right(1) - maze.center_width/2;
        elseif left_parent_branch == right_parent_branch
            maze.parent_branch(ij) = right_parent_branch;
            init_left = maze.left_wall_traj(maze.parent_branch(ij),3:4);
            init_right = maze.right_wall_traj(maze.parent_branch(ij),3:4);
        else
            error('Cannot have two different parent branches')
        end
        if maze.parent_branch(ij) >= ij
            error('Cannot have parent branch defined before branch')
        end
    end

    if maze.split_branch(ij)
        cur_width = init_right(1)-init_left(1)+maze.center_width;
        ideal_length = cur_width/(tand(maze.right_angle(ij)) - tand(maze.left_angle(ij)))/maze.wall_gain;
        ideal_length = round(10*ideal_length)/10;
        maze.length(ij) = ideal_length;
        dat{ij,1} = ideal_length;
    end
    
    if maze.left_end(ij) == 0 || maze.right_end(ij) == 0 && maze.split_branch(maze.parent_branch(ij)) == 0
        cur_width = init_right(1)-init_left(1);
        end_width = maze.dead_end_width;
        orig_ang = (maze.left_angle(maze.parent_branch(ij)) + maze.right_angle(maze.parent_branch(ij)))/2;
        maze.length(ij) = maze.max_wall_for_pos/maze.wall_gain;
        lat_displacement = tand(orig_ang)*maze.length(ij)*maze.wall_gain;
        maze.left_angle(ij) = 90-180/pi*atan2(maze.length(ij)*maze.wall_gain,(cur_width - end_width)/2+lat_displacement);
        maze.right_angle(ij) = -(90-180/pi*atan2(maze.length(ij)*maze.wall_gain,(cur_width - end_width)/2-lat_displacement));
        dat{ij,1} = maze.length(ij);
        dat{ij,2} = maze.left_angle(ij);
        dat{ij,3} = maze.right_angle(ij);
    end
    
    if maze.left_end(ij) == 0 || maze.right_end(ij) == 0 && maze.split_branch(maze.parent_branch(ij)) == 1
        cur_width = init_right(1)-init_left(1);
        end_width = maze.dead_end_width;
        orig_ang = (maze.left_angle(maze.parent_branch(ij)) + maze.right_angle(maze.parent_branch(ij)))/2;
        maze.length(ij) = 14;
        lat_displacement = tand(orig_ang)*maze.length(ij)*maze.wall_gain;
        maze.left_angle(ij) = 90-180/pi*atan2(maze.length(ij)*maze.wall_gain,(cur_width - end_width)/2+lat_displacement);
        maze.right_angle(ij) = -(90-180/pi*atan2(maze.length(ij)*maze.wall_gain,(cur_width - end_width)/2-lat_displacement));
        dat{ij,1} = maze.length(ij);
        dat{ij,2} = maze.left_angle(ij);
        dat{ij,3} = maze.right_angle(ij);
    end

    traj_add = NaN(1,2);
    traj_add(1) = maze.wall_gain*tand(maze.left_angle(ij))*maze.length(ij);
    traj_add(2) = maze.length(ij);
    traj_add = init_left + traj_add;
    maze.left_wall_traj(ij,:) = [init_left traj_add];
    
    traj_add = NaN(1,2);
    traj_add(1) = maze.wall_gain*tand(maze.right_angle(ij))*maze.length(ij);
    traj_add(2) = maze.length(ij);
    traj_add = init_right + traj_add;
    maze.right_wall_traj(ij,:) = [init_right traj_add];

end

maze.right_wall_traj = round(10*maze.right_wall_traj)/10;
maze.length = round(10*maze.length)/10;
maze.left_wall_traj = round(10*maze.left_wall_traj)/10;

maze.for_maze_cord = maze.left_wall_traj(:,2);
maze.l_wall_lat = maze.left_wall_traj(:,1);
maze.r_wall_lat = maze.right_wall_traj(:,1);
%maze.width = maze.r_wall_lat - maze.l_wall_lat;

% creat initial position of icon
[init_x init_y] = maze_coordinate_transform(maze,maze.initial.branch_id,maze.initial.branch_fraction,maze.initial.corridor_frac);
maze.initial.x_cord = init_x;
maze.initial.y_cord = init_y;

% check limits
x_vals = [maze.left_wall_traj(:,[1 3]) maze.right_wall_traj(:,[1 3])];
x_vals = x_vals(:);
y_vals = [maze.left_wall_traj(:,[2 4]) maze.right_wall_traj(:,[2 4])];
y_vals = y_vals(:);

if min(y_vals) < 0
    error('Cannot have forward position < 0')
end
if max(y_vals) > 1000
    error('Cannot have forward position > 1000')
end
if min(x_vals) < -500
    error('Cannot have lateral position < -500')
end
if min(y_vals) > 500
    error('Cannot have lateral position > 500')
end

maze.y_lim = 5*ceil(1/5*max([maze.right_wall_traj(:,4);maze.left_wall_traj(:,4)]));
maze.x_lim = [5*floor(1/5*min([maze.left_wall_traj(:,1);maze.left_wall_traj(:,3)]))-5,5*ceil(1/5*max([maze.right_wall_traj(:,1);maze.right_wall_traj(:,3)]))+5];

maze.y_lim = [0 max(maze.y_lim)] +[-20 20];
maze.x_lim = [-max(abs(maze.x_lim)), max(abs(maze.x_lim))];


% if continuous trials check start and end are of same width