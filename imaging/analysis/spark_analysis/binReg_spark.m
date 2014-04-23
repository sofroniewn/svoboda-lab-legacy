function regMat = binReg_spark(regress_var,vals,keep_ind)
	vals =[vals Inf];
	regMat = zeros(length(vals)-1,length(regress_var));
	for i=1:length(vals)-1
		inds = regress_var>=vals(i) & regress_var<vals(i+1);
		regMat(i,inds) = 1;
	end
	regMat(:,~keep_ind) = 0;