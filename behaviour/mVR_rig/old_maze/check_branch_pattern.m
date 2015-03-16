function branch_choice_matrix = check_branch_pattern(branch_pattern)

if branch_pattern(1) ~= 0 && branch_pattern(2) ~= 1
	error('First branch has to be from zero node')
end

[C,ia,ic] = unique(branch_pattern);
for ij = 1:length(C)
	num_repeats = sum(branch_pattern == C(ij));
	if C(ij) > 1 && num_repeats ~= 2
			error('Tree must be binary after first node')
	end
	if (C(ij) == 0 || C(ij) == 1) & ~num_repeats == 1
			error('Only one parent node')
	end
end

% for each branch - give it's start & end node, it's parent branch, and it's left and right branch (zeros if they don't exist);
% then also whether it is a left branch -1, a right branch 1, or the root branch, 0;
num_branches = length(branch_pattern)-1;
branch_choice_matrix = NaN(num_branches,6);
for ij = 1:num_branches
	end_node = ij;
	start_node = branch_pattern(end_node+1)-1;
	branch_choice_matrix(ij,1:2) = [start_node end_node];
end
for ij = 1:num_branches
	start_node = branch_choice_matrix(ij,1);
	end_node = branch_choice_matrix(ij,2);
	start_branch = find(branch_choice_matrix(:,2)==start_node);
	if ~isempty(start_branch)
		branch_choice_matrix(ij,3) = start_branch;
	else
		branch_choice_matrix(ij,3) = 0;		
	end
	new_branches = find(branch_choice_matrix(:,1)==end_node);
	if ~isempty(new_branches)
		if length(new_branches) ~= 2
			error('Tree must be binary after first node')
		end
		branch_choice_matrix(ij,4:5) = new_branches';
	else
		branch_choice_matrix(ij,4:5) = [0 0];		
	end
end

for ij = 1:num_branches
	left_branch = find(branch_choice_matrix(:,4) == ij);
	right_branch = find(branch_choice_matrix(:,5) == ij);
	if ij == 1;
		branch_choice_matrix(ij,6) = 0;
	else
		if isempty(left_branch) && isempty(right_branch)
			error('Branch must be either left or right')
		end
		if isempty(left_branch)
			branch_choice_matrix(ij,6) = 1;
		else
			branch_choice_matrix(ij,6) = -1;
		end
	end
end

