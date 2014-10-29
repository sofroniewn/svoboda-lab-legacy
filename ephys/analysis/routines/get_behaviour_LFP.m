function [l_ctk l_labels] = get_behaviour_LFP(d,lfp_data);

l_ctk = zeros(5,size(d.s_ctk,2),size(d.s_ctk,3));

l_labels = {'raw_vlt', 'theta', 'gamma','phase_t','phase_g'};

u_ind = find(strcmp(d.u_labels,'trial_num'));
raw_trial_nums = d.u_ck(u_ind,:);

for ij = 1:size(d.s_ctk,3)
	trial_id = raw_trial_nums(ij);
	lfp_ind = find(lfp_data.trial==trial_id);
    num_inds = min(size(d.s_ctk,2),length(lfp_data.raw_vlt{lfp_ind}));
	l_ctk(1,1:num_inds,ij) = lfp_data.raw_vlt{lfp_ind}(1:num_inds);
	l_ctk(2,1:num_inds,ij) = lfp_data.flt_vlt_theta{lfp_ind}(1:num_inds);
	l_ctk(3,1:num_inds,ij) = lfp_data.flt_vlt_gamma{lfp_ind}(1:num_inds);
	l_ctk(4,1:num_inds,ij) = angle(hilbert(l_ctk(2,1:num_inds,ij)));
	l_ctk(5,1:num_inds,ij) = angle(hilbert(l_ctk(3,1:num_inds,ij)));
end
