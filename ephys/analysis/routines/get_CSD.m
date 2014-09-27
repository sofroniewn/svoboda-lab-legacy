function CSD = get_CSD(laser_data,trial_range,power_values,keep_powers,ch_exclude)

keep_inds = ismember(laser_data.trial,trial_range) & ismember(power_values,keep_powers);

laser_onset = find(laser_data.time_window == 0);
avg_vlt = squeeze(mean(laser_data.raw_vlt(keep_inds,:,:),1));
avg_vlt = bsxfun(@minus,avg_vlt,mean(avg_vlt(:,(laser_onset-50):laser_onset),2));

ch_exclude(ch_exclude == 1) = [];
ch_exclude(ch_exclude == size(avg_vlt,1)) = [];

all_chan = [1:size(avg_vlt,1)];
all_chan(ch_exclude) = [];

avg_vlt(end,:) = [];
avg_vlt(1,:) = [];
all_chan(end) = [];
all_chan(1) = [];

CSD.vals = zeros(size(avg_vlt));
for ij = 1:size(avg_vlt,2)
	tmp = avg_vlt(all_chan-1,ij);
	tmp = csaps(all_chan,tmp,.1);
	tmp = fnder(tmp,2);
	tmp = fnval(tmp,[1:size(avg_vlt,1)]);
	CSD.vals(:,ij) = tmp;
end

%offset_shift = repmat(1-[1:size(avg_vlt,1)]'+size(avg_vlt,1),1,size(avg_vlt,2));
offset_shift = repmat(1+[1:size(avg_vlt,1)]',1,size(avg_vlt,2));

CSD.time_range = [-0.005 0.025];
CSD.time_window = laser_data.time_window;
CSD.vlt_trace = -avg_vlt'*10^4+offset_shift';
CSD.vlt_cmap = avg_vlt; %flipdim(avg_vlt,1);
CSD.vals = CSD.vals; %flipdim(CSD.vals,1);

CSD.profile = mean(CSD.vals(:,551:590),2);

% upsample CSD
CSD.profile_chan_interp = [1:1/10:length(CSD.profile)];
CSD.profile_interp = spline([1:length(CSD.profile)],CSD.profile,CSD.profile_chan_interp);


