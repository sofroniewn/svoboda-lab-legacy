

new_dir = '/Users/sofroniewn/Documents/DATA/mVR_python';
r = mVR_behaviour_params(session);

s = [];
s.corPos = r.corPos;
s.corWidth = r.corWidth;
s.deadEnd = r.rEnd;
s.trialNum = r.trialNum-1;
s.itiPeriod = r.itiPeriod;
s.trialWater = r.trialWater;
s.xMazePos = r.yMazeCord;
s.yMazePos = r.xMazeCord;
s.xSpeed = r.xSpeed*500;
s.ySpeed = r.ySpeed*500;
savejson('',s,fullfile(new_dir,'covariates.json'));

mazeRaw = session.array.maze{1};

maze = [];
maze.rewardPatch = [[4.7713, -7.4581, 10.5419, 22.7713];[72.8,84,84,72.8]];
maze.branchPatch = zeros(2,4,mazeRaw.num_branches);

for iBranch = 1:mazeRaw.num_branches
	xCord = [mazeRaw.left_wall_traj(iBranch,[1 3])';mazeRaw.right_wall_traj(iBranch,[3 1])'];
	yCord = [mazeRaw.left_wall_traj(iBranch,[2 4])';mazeRaw.right_wall_traj(iBranch,[4 2])'];
	maze.branchPatch(1,:,iBranch) = xCord;
	maze.branchPatch(2,:,iBranch) = yCord;
end
savejson('',maze,fullfile(new_dir,'maze.json'));

