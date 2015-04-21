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
		h_patch(ij,1) = plot(maze.left_wall_traj(ij,[1 3])',maze.left_wall_traj(ij,[2 4])','Color',[.99 .99 .99],'LineWidth',2);
		h_patch(ij,2) = plot(maze.right_wall_traj(ij,[1 3])',maze.right_wall_traj(ij,[2 4])','Color',[.99 .99 .99],'LineWidth',2);
	end
end

stripes = 0;
for ij = 1:maze.num_branches
	% plot reward patches
	if maze.reward_branch(ij)
			reward_patch = [maze.default_reward_patch(1:2) maze.default_reward_patch(2) maze.default_reward_patch(1) maze.default_reward_patch(3) maze.default_reward_patch(3) maze.default_reward_patch(4) maze.default_reward_patch(4)];
            end_vals = NaN(4,2);
            for ik = 1:4
				[init_x init_y] = maze_coordinate_transform(maze,ij,reward_patch(ik),reward_patch(4+ik));
				end_vals(ik,1) = init_x; end_vals(ik,2) = init_y;
            end
			h = patch(end_vals(:,1),end_vals(:,2),'b');
			set(h,'FaceColor',[.2 .2 .75]);
			set(h,'EdgeColor',[.2 .2 .75]);
			set(h,'LineWidth',2)
            if stripes > 0
                
            end
    end
	if show_branch_labels
		[init_x init_y] = maze_coordinate_transform(maze,ij,.5,.5);
		text(init_x,init_y,sprintf('%d',ij),'FontSize',20,'Color',[0 .75 0],'BackGroundColor',[.99 .99 .99])
	end
end


x_lim = [5*floor(1/5*min([maze.left_wall_traj(:,1);maze.left_wall_traj(:,3)]))-5,5*ceil(1/5*max([maze.right_wall_traj(:,1);maze.right_wall_traj(:,3)]))+5];
y_lim = 5*ceil(1/5*max([maze.right_wall_traj(:,4);maze.left_wall_traj(:,4)]));

init_x = maze.initial.x_cord;
init_y = maze.initial.y_cord;

% plot mouse
plot([init_x init_x],[init_y init_y-(y_lim+40)/25],'Color',[0.2 0.2 0.2],'LineWidth',4);
plot(init_x,init_y,'^','MarkerSize',25,'MarkerEdgeColor',[0.2 0.2 0.2],'MarkerFaceColor',[.6 .6 .6],'LineWidth',2);

xlim([-max(abs(x_lim)), max(abs(x_lim))])
ylim([0 y_lim]+[-20 20])
