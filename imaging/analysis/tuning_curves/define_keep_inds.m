function keep_inds = define_keep_inds(x_vars)

	global session_bv;
    total_num_inds = length(eval(x_vars{1}.str));
	data_mat = false(size(x_vars,1),total_num_inds);
    start_ind = 1;
    for ij = 1:size(x_vars,1)
        x_var = eval(x_vars{ij}.str);
        switch x_vars{ij}.type
            case 'range'
                data_mat(ij,:) = x_vars{ij}.vals(1) <= x_var & x_var <= x_vars{ij}.vals(2);
            case 'equal'
                data_mat(ij,:) = ismember(x_var,x_vars{ij}.vals);
        end                
    end
    keep_inds = all(data_mat,1);