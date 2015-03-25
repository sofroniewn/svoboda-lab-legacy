function [x_cord y_cord] = maze_coordinate_transform(maze,branch_id,branch_fraction,corridor_fraction)


y_cord = (maze.left_wall_traj(branch_id,2) + maze.right_wall_traj(branch_id,2))/2 + branch_fraction*maze.length(branch_id);

left_wall_pos = maze.left_wall_traj(branch_id,1) + branch_fraction*maze.wall_gain*sind(maze.left_wall_angle(branch_id))*maze.length(branch_id);
right_wall_pos = maze.right_wall_traj(branch_id,1) + branch_fraction*maze.wall_gain*sind(maze.right_wall_angle(branch_id))*maze.length(branch_id);

x_cord = left_wall_pos + (right_wall_pos - left_wall_pos)*corridor_fraction;
