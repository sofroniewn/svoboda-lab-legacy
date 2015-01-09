function perf = decode_tuning_linear(f_nc)
% Decode from tuning curve matrix f_nc, firing rate of neuron n condition c

% given f_nc, find u_nc and sigma2_nc for gaussian tuning
u_nc = zscore(f_nc,[],2);
sigma2_nc = ones(size(u_nc))/3;

% repeat for n_Reps
n_Reps = 50;
error_rc = zeros(n_Reps,size(f_nc,2));

for iC = 1:size(f_nc,2)
	% repeat for each condition iC
	for iReps = 1:n_Reps
		% for each rep draw a firing rate vector h_n from condition iC
		%h_n = normrnd(mu,sigma,size(f_nc,1),1);
		h_n = normrnd(u_nc(:,iC),sigma2_nc(:,iC));

		% for each neuron and each condition what is the probability of firing rate h_n
		h_nc = repmat(h_n,1,size(f_nc,2));
		p_nc = 1./sqrt(2*pi.*sigma2_nc).*exp(-(h_nc-u_nc).^2./sqrt(2*pi.*sigma2_nc));

		[b,bint,r,rint,stats] = regress([1:size(f_nc,2)]',u_nc');

		% get likelihood of each condition by summing log probability across neurons
%		L_c = sum(log(p_nc),1);
		
		p_c = prod(p_nc,1);
		p_c = p_c/sum(p_c);
		% find condition with max log likelihood
%		[val c] = max(L_c);
%		error_rc(iReps,iC) = iC-c;
		error_rc(iReps,iC) = sqrt(sum(p_c.*([1:size(f_nc,2)]-iC).^2));

	end
end

% error_rc(abs(error_rc)>0) = 1;
% error_rc = 1 - error_rc;

% evaluate decoder performance
%perf = mean(error_rc(:));
perf = mean(error_rc,1);
