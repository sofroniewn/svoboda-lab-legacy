function plot_spk_raster(fig_props,RASTER)

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on

if isfield(RASTER,'laser_on')
	plot(RASTER.laser_on,RASTER.laser_on_trial,'-','Color','c')
end

num_groups = numel(RASTER.spikes);
col_mat = zeros(num_groups,3);
col_mat(1:end,3) = 1-linspace(0,1,num_groups);
%col_mat = [1 0 0];
for i_group = 1:num_groups
	plot(RASTER.spikes{i_group},RASTER.trials{i_group},'.','Color',col_mat(i_group,:),'MarkerSize',10)
end

ylim(RASTER.trial_range)
xlim(RASTER.time_range)
ylabel('Trial number')
xlabel('Time (s)')


