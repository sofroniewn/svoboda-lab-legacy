function trial_info_dat = extract_trial_info

global session

num_cols = 4;
trial_info_dat = cell(size(session.trial_config.dat,1)+1,num_cols);

for ij = 1:size(session.trial_config.dat,1)
trial_info_dat{ij,1} = session.trial_config.dat{ij,1};
trial_info_dat{ij,2} = sum(session.trial_info.inds==ij);
trial_info_dat{ij,3} = sum(session.trial_info.completed(session.trial_info.inds==ij));
trial_info_dat{ij,4} = sum(session.trial_info.rewarded(session.trial_info.inds==ij));
end

trial_info_dat{end,1} = 'TOTAL';
trial_info_dat{end,2} = length(session.trial_info.inds);
trial_info_dat{end,3} = sum(session.trial_info.completed == 1);
trial_info_dat{end,4} = sum(session.trial_info.rewarded == 1);


