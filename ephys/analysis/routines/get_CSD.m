function CSD = get_CSD(laser_data,trial_range,power_values,keep_powers)

keep_inds = ismember(laser_data.trial,trial_range) & ismember(power_values,keep_powers);

laser_onset = find(laser_data.time_window == 0);
avg_vlt = squeeze(mean(laser_data.raw_vlt(keep_inds,:,:),1));
avg_vlt = bsxfun(@minus,avg_vlt,mean(avg_vlt(:,(laser_onset-50):laser_onset),2));

avg_vlt(end,:) = [];
avg_vlt(1,:) = [];

CSD.vals = zeros(size(avg_vlt));
for ij = 1:size(avg_vlt,2)
	tmp = avg_vlt(:,ij);
	tmp = csaps([1:size(avg_vlt,1)],tmp,.1);
	tmp = fnder(tmp,2);
	tmp = fnval(tmp,[1:size(avg_vlt,1)]);
	CSD.vals(:,ij) = tmp;
end

offset_shift = repmat(1+[1:size(avg_vlt,1)]',1,size(avg_vlt,2));

CSD.time_range = [-0.005 0.025];
CSD.time_window = laser_data.time_window;
CSD.vlt_trace = avg_vlt'*10^4+offset_shift';
CSD.vlt_cmap = flipdim(avg_vlt,1);
CSD.vals = flipdim(CSD.vals,1);
