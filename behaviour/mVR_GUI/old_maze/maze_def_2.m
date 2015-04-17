
maze.wall_gain = 1;

maze.initial.branch_id = 2;
maze.initial.branch_fraction = .2;
maze.initial.corridor_frac = .5;


maze.start_wall_right = 15;
maze.start_wall_left = 15;


maze.num_branches = 8;

maze.length = NaN(maze.num_branches,1);
maze.left_wall_angle = NaN(maze.num_branches,1);
maze.right_wall_angle = NaN(maze.num_branches,1);
maze.end_cond = NaN(maze.num_branches,2); % -1 implies wall, 0 implies nothing, # > 0 implies another branch, 2 numbers implies left/right branch
maze.reward_patch = zeros(maze.num_branches,8); % [0 0] no reward, [0 1], reward spanning cor frac

maze.length(1) = 100;
maze.left_wall_angle(1) = -5;
maze.right_wall_angle(1) = -5;
maze.end_cond(1,:) = [2 0]; % -1 implies wall, 0 implies nothing, # > 0 implies another branch, 2 numbers implies left/right branch

maze.length(2) = 100;
maze.left_wall_angle(2) = 0;
maze.right_wall_angle(2) = 0;
maze.end_cond(2,:) = [3 4]; % -1 implies wall, 0 implies nothing, # > 0 implies another branch, 2 numbers implies left/right branch

maze.length(3) = 150;
maze.left_wall_angle(3) = -10;
maze.right_wall_angle(3) = -10;
maze.end_cond(3,:) = [-1 -1]; % -1 implies wall, 0 implies nothing, # > 0 implies another branch, 2 numbers implies left/right branch

maze.length(4) = 100;
maze.left_wall_angle(4) = 10;
maze.right_wall_angle(4) = 10;
maze.end_cond(4,:) = [5 0]; % -1 implies wall, 0 implies nothing, # > 0 implies another branch, 2 numbers implies left/right branch

maze.length(5) = 100;
maze.left_wall_angle(5) = 0;
maze.right_wall_angle(5) = 0;
maze.end_cond(5,:) = [6 7]; % -1 implies wall, 0 implies nothing, # > 0 implies another branch, 2 numbers implies left/right branch

maze.length(6) = 100;
maze.left_wall_angle(6) = -10;
maze.right_wall_angle(6) = -10;
maze.end_cond(6,:) = [8 0]; % -1 implies wall, 0 implies nothing, # > 0 implies another branch, 2 numbers implies left/right branch

maze.length(7) = 150;
maze.left_wall_angle(7) = 10;
maze.right_wall_angle(7) = 10;
maze.end_cond(7,:) = [-1 -1]; % -1 implies wall, 0 implies nothing, # > 0 implies another branch, 2 numbers implies left/right branch

maze.length(8) = 150;
maze.left_wall_angle(8) = 0;
maze.right_wall_angle(8) = 0;
maze.end_cond(8,:) = [9 0]; % -1 implies wall, 0 implies nothing, # > 0 implies another branch, 2 numbers implies left/right branch
maze.reward_patch(8,:) = [.5 .6 .6 .5, .1 .1 .9 .9]; % [0 0] no reward, [0 1], reward spanning cor frac



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


% % make sure each choice correct triple, back - left, right.
% % deal with interection points
% for ij = 1:maze.num_branches
% 	if  maze.branch_choice_matrix(ij,4:5) ~= [0 0]
% 		left_branch = maze.branch_choice_matrix(ij,4);
% 		right_branch = maze.branch_choice_matrix(ij,5);
% 		% assume intersection happens on first stretch of turn - if not can give error ?
% 		line_right_wall_left_turn = maze.branch{left_branch}.right_wall_traj(1:2,:);
% 		line_left_wall_right_turn = maze.branch{right_branch}.left_wall_traj(1:2,:);
		
% 		[xi,yi,ii] = polyxpoly(maze.branch{left_branch}.right_wall_traj(:,1),maze.branch{left_branch}.right_wall_traj(:,2),maze.branch{right_branch}.left_wall_traj(:,1),maze.branch{right_branch}.left_wall_traj(:,2));
% 		if isempty(xi)
% 			error('Unexpected no intersection points')
% 		end
% 		if length(xi) > 1
% 			error('Unexpected multiple intersection points')
% 		end
% 		maze.branch{left_branch}.plot_right_wall_traj = maze.branch{left_branch}.plot_right_wall_traj(ii(1,1):end,:);
% 		maze.branch{right_branch}.plot_left_wall_traj = maze.branch{right_branch}.plot_left_wall_traj(ii(1,2):end,:);
% 		maze.branch{left_branch}.plot_right_wall_traj(1,:) = [xi yi];
% 		maze.branch{right_branch}.plot_left_wall_traj(1,:) = [xi yi];
% 	end
% end



%% plot maze
figure(1);
clf(1)
set(gcf,'Position',[12    10   332   796])
% clean up figure
set(gca,'visible','off'); set(gcf,'color',[0 0 0])
set(gcf, 'MenuBar', 'none'); set(gcf, 'ToolBar', 'none');
hold on
plot_filled = 1;
show_branch_labels = 0;
if plot_filled
	h_patch = NaN(maze.num_branches,1);
else
	h_patch = NaN(maze.num_branches,2);
end

for ij = 1:maze.num_branches
	if plot_filled
		h_patch(ij) = patch([maze.left_wall_traj(ij,[1 3])';maze.right_wall_traj(ij,[3 1])'],[maze.left_wall_traj(ij,[2 4])';maze.right_wall_traj(ij,[4 2])'],'r');
		set(h_patch(ij),'FaceColor',[.99 .99 .99]);
		set(h_patch(ij),'EdgeColor',[.99 .99 .99]);
	else
		h_patch(ij,1) = plot(maze.plot_left_wall_traj(ij,[1 3])',maze.plot_left_wall_traj(ij,[2 4])','Color',[.99 .99 .99],'LineWidth',2);
		h_patch(ij,2) = plot(maze.plot_right_wall_traj(ij,[1 3])',maze.plot_right_wall_traj(ij,[2 4])','Color',[.99 .99 .99],'LineWidth',2);
	end
end

for ij = 1:maze.num_branches
	% plot dead ends
	if maze.end_cond(ij,:) == [-1 -1];
		end_x = [maze.plot_left_wall_traj(ij,3);maze.plot_right_wall_traj(ij,3)];
		end_y = [maze.plot_left_wall_traj(ij,4);maze.plot_right_wall_traj(ij,4)];
		branch_fraction = 1 - 20/maze.length(ij);
		[init_x init_y] = maze_coordinate_transform(maze,ij,branch_fraction,1);
		end_x = [end_x;init_x]; end_y = [end_y;init_y];
		[init_x init_y] = maze_coordinate_transform(maze,ij,branch_fraction,0);
		end_x = [end_x;init_x]; end_y = [end_y;init_y];
		h = patch(end_x,end_y,'r');
		set(h,'FaceColor',[.99 0 0]);
		set(h,'EdgeColor',[.99 0 0]);
		set(h,'LineWidth',2)
	end

	% plot reward patches
	if any(maze.reward_patch(ij,:))
			reward_patch = [maze.reward_patch(ij,1:4);maze.reward_patch(ij,5:8)];
			end_vals = NaN(4,2);
			for ik = 1:4
				[init_x init_y] = maze_coordinate_transform(maze,ij,reward_patch(1,ik),reward_patch(2,ik));
				end_vals(ik,1) = init_x; end_vals(ik,2) = init_y;
			end
			h = patch(end_vals(:,1),end_vals(:,2),'b');
			set(h,'FaceColor',[0 0 .75]);
			set(h,'EdgeColor',[0 0 .75]);
			set(h,'LineWidth',2)
	end

	if show_branch_labels
		[init_x init_y] = maze_coordinate_transform(maze,ij,.5,.5);
		text(init_x,init_y,sprintf('%d',ij),'FontSize',20,'Color',[0 .75 0],'BackGroundColor',[.99 .99 .99])
	end
end

branch_id = maze.initial.branch_id;
branch_fraction = maze.initial.branch_fraction;
corridor_fraction = maze.initial.corridor_frac;
[init_x init_y] = maze_coordinate_transform(maze,branch_id,branch_fraction,corridor_fraction);

% plot mouse
plot(init_x,init_y,'^','MarkerSize',25,'MarkerEdgeColor',[.5 0 1],'MarkerFaceColor',[.5 0 1]);
plot([init_x init_x],[init_y init_y-25],'Color',[.5 0 1],'LineWidth',4);


