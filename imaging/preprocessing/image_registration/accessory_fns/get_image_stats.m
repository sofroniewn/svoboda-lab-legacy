function im_stats = get_image_stats(base_name)

cur_files = dir(fullfile(base_name,'scanimage','summary','*_summary_*.mat'));

im_stats.num_frames = zeros(numel(cur_files),1);
im_stats.firstFrame = zeros(numel(cur_files),1);
im_stats.scim_trial = zeros(numel(cur_files),1);
im_stats.num_planes = zeros(1,1);
im_stats.num_chan = zeros(1,1);
im_stats.height = zeros(1,1);
im_stats.width = zeros(1,1);

for ij = 1:numel(cur_files)
	fprintf('FILE %d/%d\n',ij,numel(cur_files));
	load(fullfile(base_name,'scanimage','summary',cur_files(ij).name));
	if ij == 1
		im_stats.num_planes = im_summary.props.num_planes;
		im_stats.num_chan = im_summary.props.num_chan;
		im_stats.height = im_summary.props.height;
		im_stats.width = im_summary.props.width;	
	end
	im_stats.num_frames(ij) = im_summary.props.num_frames;
	im_stats.firstFrame(ij) = im_summary.props.firstFrame;
	im_stats.scim_trial(ij) = im_summary.props.scim_trial;
end