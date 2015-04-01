function plot_maze(maze,params)

hold on
plot_filled = 1;
show_branch_labels = params.show_branch_labels;
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
		branch_fraction = 1 - 10/maze.length(ij);
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


x_lim = [5*floor(1/5*min([maze.left_wall_traj(:,1);maze.left_wall_traj(:,3)]))-5,5*ceil(1/5*max([maze.right_wall_traj(:,1);maze.right_wall_traj(:,3)]))+5];
y_lim = 5*ceil(1/5*max([maze.right_wall_traj(:,4);maze.left_wall_traj(:,4)]));

xlim([-max(abs(x_lim)), max(abs(x_lim))])
ylim([0 y_lim])

