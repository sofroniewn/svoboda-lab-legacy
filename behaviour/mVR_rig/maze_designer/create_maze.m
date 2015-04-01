function maze = create_maze(dat)

maze.num_branches = size(dat,1);

maze.wall_gain = 1;

maze.initial.branch_id = 2;
maze.initial.branch_fraction = .2;
maze.initial.corridor_frac = .5;

if maze.initial.branch_id > maze.num_branches
	maze.initial.branch_id = 1;
end

maze.start_wall_right = 15;
maze.start_wall_left = 15;

maze.length = NaN(maze.num_branches,1);
maze.left_wall_angle = NaN(maze.num_branches,1);
maze.right_wall_angle = NaN(maze.num_branches,1);
maze.end_cond = NaN(maze.num_branches,2); % -1 implies wall, 0 implies nothing, # > 0 implies another branch, 2 numbers implies left/right branch
maze.reward_patch = zeros(maze.num_branches,8); % [0 0] no reward, [0 1], reward spanning cor frac


for ij = 1:maze.num_branches
	maze.length(ij) = dat{ij,1};
	maze.left_wall_angle(ij) = dat{ij,2};
	maze.right_wall_angle(ij) = dat{ij,3};
	maze.end_cond(ij,:) = [dat{ij,4} dat{ij,5}];
	if dat{ij,6}
		maze.reward_patch(ij,:) = [.5 .6 .6 .5, .1 .1 .9 .9];
	end
end


maze.left_wall_traj = NaN(maze.num_branches,4);
maze.right_wall_traj = NaN(maze.num_branches,4);
maze.parent_branch = NaN(maze.num_branches,1);

%%% construct full maze
for ij = 1:maze.num_branches
	
	% make sure each branch gets assigned correct parent node
	parent_branch = find(maze.end_cond(:,1) == ij);
	if isempty(parent_branch)
		parent_branch = find(maze.end_cond(:,2) == ij);
	end

	if isempty(parent_branch);
		maze.parent_branch(ij) = 0;
		init_left = maze.wall_gain*[-maze.start_wall_left 0];		
		init_right = maze.wall_gain*[maze.start_wall_right 0];		
	else
		maze.parent_branch(ij) = parent_branch;
		init_left = maze.left_wall_traj(parent_branch,3:4);
		init_right = maze.right_wall_traj(parent_branch,3:4);
	end

	traj_add = NaN(1,2);
    traj_add(1) = maze.wall_gain*sind(maze.left_wall_angle(ij))*maze.length(ij);
    traj_add(2) = cosd(maze.left_wall_angle(ij))*maze.length(ij);
    traj_add = init_left + traj_add;
    maze.left_wall_traj(ij,:) = [init_left traj_add];

	traj_add = NaN(1,2);
    traj_add(1) = maze.wall_gain*sind(maze.right_wall_angle(ij))*maze.length(ij);
    traj_add(2) = cosd(maze.right_wall_angle(ij))*maze.length(ij);
    traj_add = init_right + traj_add;
    maze.right_wall_traj(ij,:) = [init_right traj_add];

  end

	maze.plot_right_wall_traj = maze.right_wall_traj;
	maze.plot_left_wall_traj = maze.left_wall_traj;

%%% check left right turns
for ij = 1:maze.num_branches
	if maze.end_cond(ij,2)>0
		if maze.right_wall_angle(maze.end_cond(ij,1)) > maze.left_wall_angle(maze.end_cond(ij,2))
			maze.end_cond(ij,:) = maze.end_cond(ij,[2 1]);
		end
		% remove intersection point at branch
 		[xi,yi,ii] = polyxpoly(maze.right_wall_traj(maze.end_cond(ij,1),[1 3])',maze.right_wall_traj(maze.end_cond(ij,1),[2 4])',maze.left_wall_traj(maze.end_cond(ij,2),[1 3])',maze.left_wall_traj(maze.end_cond(ij,2),[2 4])');
 		if isempty(xi)
 			error('Unexpected no intersection points')
 		end
 		maze.plot_right_wall_traj(maze.end_cond(ij,1),1:2) = [xi yi];
 		maze.plot_left_wall_traj(maze.end_cond(ij,2),1:2) = [xi yi];
	end
end
