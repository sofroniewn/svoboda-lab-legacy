function h_all = plot_maze(h_ax,maze,show_branch_labels,show_mouse,adjust_axes)

h_all = [];
hold on
plot_filled = 1;
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
        set(h_patch(ij),'Parent',h_ax);
        h_all = [h_all;h_patch(ij)];
    else
		h_patch(ij,1) = plot(h_ax,maze.left_wall_traj(ij,[1 3])',maze.left_wall_traj(ij,[2 4])','Color',[.99 .99 .99],'LineWidth',2);
		h_patch(ij,2) = plot(h_ax,maze.right_wall_traj(ij,[1 3])',maze.right_wall_traj(ij,[2 4])','Color',[.99 .99 .99],'LineWidth',2);
    	h_all = [h_all;h_patch(ij,:)'];
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
			set(h,'LineWidth',2);
            set(h,'Parent',h_ax);
            h_all = [h_all;h];
            if stripes > 0
                %%%%%%%%%%%%%%%%%% to add
            end
    end
	if show_branch_labels
		[init_x init_y] = maze_coordinate_transform(maze,ij,.5,.5);
		text(init_x,init_y,sprintf('%d',ij),'FontSize',20,'Color',[0 .75 0],'BackGroundColor',[.99 .99 .99])
	end
end

% plot mouse
if show_mouse
	init_x = maze.initial.x_cord;
	init_y = maze.initial.y_cord;
	plot(h_ax,[init_x init_x],[init_y init_y-(maze.y_lim(2)+20)/30],'Color',[0.2 0.2 0.2],'LineWidth',4);
	plot(h_ax,init_x,init_y,'^','MarkerSize',14,'MarkerEdgeColor',[0.2 0.2 0.2],'MarkerFaceColor',[.6 .6 .6],'LineWidth',2);
end

if adjust_axes
	xlim(maze.x_lim)
	ylim(maze.y_lim)
end

