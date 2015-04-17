function [x_cord y_cord] = maze_coordinate_transform(maze,branch_id,branch_fraction,corridor_fraction)

if branch_fraction > .99
	branch_fraction = .99;
end

y_cord = (maze.branch{branch_id}.left_wall_traj(1,2) + maze.branch{branch_id}.right_wall_traj(1,2))/2 + branch_fraction*maze.branch{branch_id}.length;


[xi,yi,ii] = polyxpoly(maze.branch{branch_id}.right_wall_traj(:,1),maze.branch{branch_id}.right_wall_traj(:,2),maze.branch{branch_id}.right_wall_traj(1,1)+[-100 100],[y_cord y_cord]);
right_wall_pos = xi;
if isempty(xi)
    error('Unexpected no intersection points')
end
if length(xi) > 1
    error('Unexpected multiple intersection points')
end


[xi,yi,ii] = polyxpoly(maze.branch{branch_id}.left_wall_traj(:,1),maze.branch{branch_id}.left_wall_traj(:,2),maze.branch{branch_id}.left_wall_traj(1,1)+[-100 100],[y_cord y_cord]);
left_wall_pos = xi;
if isempty(xi)
    error('Unexpected no intersection points')
end
if length(xi) > 1
    error('Unexpected multiple intersection points')
end

x_cord = left_wall_pos + (right_wall_pos - left_wall_pos)*corridor_fraction;
