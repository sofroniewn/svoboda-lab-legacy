function plot_spk_psth(fig_props,RASTER)

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on


num_groups = numel(RASTER.spikes);
col_mat = zeros(num_groups,3);
col_mat(1:end,3) = 1-linspace(0,1,num_groups);

for i_group = 1:num_groups
	plot(RASTER.time,RASTER.psth{i_group},'Color',col_mat(i_group,:))
end

xlim(RASTER.time_range)
ylabel('Firing rate')
xlabel('Time (s)')


