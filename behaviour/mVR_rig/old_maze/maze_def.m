
maze.wall_gain = 1;

maze.initial.branch_id = 3;
maze.initial.branch_fraction = .2;
maze.initial.corridor_frac = .5;


maze.start_wall_right = 15;
maze.start_wall_left = 15;


maze.branch_pattern = [0 1 2 2 4 4];
% Check branch pattern to create choice matrix - 
maze.branch_choice_matrix = check_branch_pattern(maze.branch_pattern);
maze.num_branches = size(maze.branch_choice_matrix,1);

%%%% plot icon based on branch pattern
 figure(2);
 clf(2);
 set(gcf,'position',[343   714   141    92])
 hold on
 treeplot_c(maze.branch_pattern,'','w'); set(gca,'ydir','rev'); set(gca,'visible','off'); set(gcf,'color',[1 1 1])
 set(gca,'visible','off'); set(gcf,'color',[0 0 0])
 set(gcf, 'MenuBar', 'none'); set(gcf, 'ToolBar', 'none');


maze.branch = cell(maze.num_branches,1);
maze.branch{1}.length = [200];
maze.branch{1}.left_wall_angle = [5, 0];
maze.branch{1}.left_wall_angle_frac = [0,.5,1];
maze.branch{1}.right_wall_angle = [5, 0];
maze.branch{1}.right_wall_angle_frac = [0,.5,1];
maze.branch{1}.end_cond = [0];
maze.branch{1}.reward_patch = [];

maze.branch{2}.length = [150];
maze.branch{2}.left_wall_angle = [10];
maze.branch{2}.left_wall_angle_frac = [0,1];
maze.branch{2}.right_wall_angle = [10];
maze.branch{2}.right_wall_angle_frac = [0,1];
maze.branch{2}.end_cond = [1];
maze.branch{2}.reward_patch = [];

maze.branch{3}.length = [400];
maze.branch{3}.left_wall_angle = [-10,5,0];
maze.branch{3}.left_wall_angle_frac = [0,.4,.8,1];
maze.branch{3}.right_wall_angle = [-10,5,0];
maze.branch{3}.right_wall_angle_frac = [0,.4,.8,1];
maze.branch{3}.end_cond = [0];
maze.branch{3}.reward_patch = [];  % {[.4,.5,.5,.4;.1,.1,.9,.9]};

maze.branch{4}.length = [300];
maze.branch{4}.left_wall_angle = [10,0];
maze.branch{4}.left_wall_angle_frac = [0,.5,1];
maze.branch{4}.right_wall_angle = [10,0];
maze.branch{4}.right_wall_angle_frac = [0,.5,1];
maze.branch{4}.end_cond = [0];
maze.branch{4}.reward_patch = {[.8,.9,.9,.8;.1,.1,.9,.9]};

maze.branch{5}.length = [150];
maze.branch{5}.left_wall_angle = [-10];
maze.branch{5}.left_wall_angle_frac = [0, 1];
maze.branch{5}.right_wall_angle = [-10];
maze.branch{5}.right_wall_angle_frac = [0, 1];
maze.branch{5}.end_cond = [1];
maze.branch{5}.reward_patch = [];

% add end conditions, transfer conditions from branch_choice_matrix

% label branches on plot
% check left / right branch assignment done corectly with initial turn angles.


%%% construct full maze
for ij = 1:maze.num_branches
	
	% make sure each branch gets assigned correct parent node
	parent_branch = maze.branch_choice_matrix(ij,3);
	if parent_branch == 0;
		init_left = maze.wall_gain*[-maze.start_wall_left 0];		
		init_right = maze.wall_gain*[maze.start_wall_right 0];		
	else
		init_left = maze.branch{parent_branch}.left_wall_traj(end,:);
		init_right = maze.branch{parent_branch}.right_wall_traj(end,:);
	end

	vals = maze.branch{ij}.left_wall_angle;
	frac = maze.branch{ij}.left_wall_angle_frac;
	traj = [];
	start_val = [0 0];
	for ik = 1:length(frac)-1
    	traj_add = NaN(1,2);
    	traj_add(1) = start_val(1) - maze.wall_gain*sind(vals(ik))*(frac(ik+1) - frac(ik))*maze.branch{ij}.length;
    	traj_add(2) = start_val(2) + cosd(vals(ik))*(frac(ik+1) - frac(ik))*maze.branch{ij}.length;
    	traj = [traj; traj_add];
    	start_val = traj_add;
	end
	maze.branch{ij}.left_wall_traj = [init_left;repmat(init_left,size(traj,1),1) + traj];
	
	vals = maze.branch{ij}.right_wall_angle;
	frac = maze.branch{ij}.right_wall_angle_frac;
	traj = [];
	start_val = [0 0];
	for ik = 1:length(frac)-1
    	traj_add = NaN(1,2);
    	traj_add(1) = start_val(1) - maze.wall_gain*sind(vals(ik))*(frac(ik+1) - frac(ik))*maze.branch{ij}.length;
    	traj_add(2) = start_val(2) + cosd(vals(ik))*(frac(ik+1) - frac(ik))*maze.branch{ij}.length;
    	traj = [traj; traj_add];
    	start_val = traj_add;
	end
	maze.branch{ij}.right_wall_traj = [init_right;repmat(init_right,size(traj,1),1) + traj];

	maze.branch{ij}.plot_right_wall_traj = maze.branch{ij}.right_wall_traj;
	maze.branch{ij}.plot_left_wall_traj = maze.branch{ij}.left_wall_traj;

	maze.branch{ij}.end_branch = maze.branch_choice_matrix(ij,4:5);
end


% calculate forward and lateral position given, frac, frac coordinates and branch id

% make sure each choice correct triple, back - left, right.
% deal with interection points
for ij = 1:maze.num_branches
	if  maze.branch_choice_matrix(ij,4:5) ~= [0 0]
		left_branch = maze.branch_choice_matrix(ij,4);
		right_branch = maze.branch_choice_matrix(ij,5);
		% assume intersection happens on first stretch of turn - if not can give error ?
		line_right_wall_left_turn = maze.branch{left_branch}.right_wall_traj(1:2,:);
		line_left_wall_right_turn = maze.branch{right_branch}.left_wall_traj(1:2,:);
		
		[xi,yi,ii] = polyxpoly(maze.branch{left_branch}.right_wall_traj(:,1),maze.branch{left_branch}.right_wall_traj(:,2),maze.branch{right_branch}.left_wall_traj(:,1),maze.branch{right_branch}.left_wall_traj(:,2));
		if isempty(xi)
			error('Unexpected no intersection points')
		end
		if length(xi) > 1
			error('Unexpected multiple intersection points')
		end
		maze.branch{left_branch}.plot_right_wall_traj = maze.branch{left_branch}.plot_right_wall_traj(ii(1,1):end,:);
		maze.branch{right_branch}.plot_left_wall_traj = maze.branch{right_branch}.plot_left_wall_traj(ii(1,2):end,:);
		maze.branch{left_branch}.plot_right_wall_traj(1,:) = [xi yi];
		maze.branch{right_branch}.plot_left_wall_traj(1,:) = [xi yi];
	end
end



%% plot maze
figure(1);
clf(1)
set(gcf,'Position',[12    10   332   796])
hold on
plot_filled = 1;
for ij = 1:maze.num_branches
	if plot_filled
		h = patch([maze.branch{ij}.left_wall_traj(:,1);flipdim(maze.branch{ij}.right_wall_traj(:,1),1)],[maze.branch{ij}.left_wall_traj(:,2);flipdim(maze.branch{ij}.right_wall_traj(:,2),1)],'r');
		set(h,'FaceColor',[.99 .99 .99]);
		set(h,'EdgeColor',[.99 .99 .99]);
	else
	plot(maze.branch{ij}.plot_left_wall_traj(:,1),maze.branch{ij}.plot_left_wall_traj(:,2),'Color',[.99 .99 .99],'LineWidth',2)
	plot(maze.branch{ij}.plot_right_wall_traj(:,1),maze.branch{ij}.plot_right_wall_traj(:,2),'Color',[.99 .99 .99],'LineWidth',2)
	end
end

for ij = 1:maze.num_branches
	% plot dead ends
	if maze.branch{ij}.end_cond == 1
		end_x = [maze.branch{ij}.plot_left_wall_traj(end,1);maze.branch{ij}.plot_right_wall_traj(end,1)];
		end_y = [maze.branch{ij}.plot_left_wall_traj(end,2);maze.branch{ij}.plot_right_wall_traj(end,2)];
		branch_fraction = 1 - 20/maze.branch{ij}.length;
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
	if ~isempty(maze.branch{ij}.reward_patch)
		for ih = 1:numel(maze.branch{ij}.reward_patch)
			reward_patch = maze.branch{ij}.reward_patch{ih};
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
	end
end

branch_id = maze.initial.branch_id;
branch_fraction = maze.initial.branch_fraction;
corridor_fraction = maze.initial.corridor_frac;
[init_x init_y] = maze_coordinate_transform(maze,branch_id,branch_fraction,corridor_fraction);


% plot mouse
plot(init_x,init_y,'^','MarkerSize',25,'MarkerEdgeColor',[.5 0 1],'MarkerFaceColor',[.5 0 1]);
plot([init_x init_x],[init_y init_y-25],'Color',[.5 0 1],'LineWidth',4);


% clean up figure
set(gca,'visible','off'); set(gcf,'color',[0 0 0])
set(gcf, 'MenuBar', 'none'); set(gcf, 'ToolBar', 'none');



