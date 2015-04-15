classdef maze_class
    %Maze class
    %
    
    properties
    maze.num_branches = size(dat,1);

    maze.wall_gain = 1;
    maze.initial.branch_id = start_branch;
    maze.initial.branch_fraction = .5;
    maze.initial.corridor_frac = .5;
    maze.initial.x_cord = 0;
    maze.initial.y_cord = 0;

    maze.start_wall_right = 15;
    maze.start_wall_left = 15;
    maze.default_reward_patch = [.1 .9 .9 .1, .2 .2 .8 .8];

    maze.length = NaN(maze.num_branches,1);
    maze.left_angle = NaN(maze.num_branches,1);
    maze.right_angle = NaN(maze.num_branches,1);
    maze.left_end = NaN(maze.num_branches,1); % 0 implies wall, # > 0 implies another branch
    maze.right_end = NaN(maze.num_branches,1); % 0 implies wall, # > 0 implies another branch
    maze.split_branch = NaN(maze.num_branches,1); % 0 implies wall, # > 0 implies another branch
    maze.reward_branch = NaN(maze.num_branches,1); %%% [0 0] no reward, [0 1], reward spanning cor frac
    maze.parent_branch = NaN(maze.num_branches,1);

    maze.left_wall_traj = NaN(maze.num_branches,4);
    maze.right_wall_traj = NaN(maze.num_branches,4);

    end
    
    methods
        
    end
    
end


