function plot_spk_psth(fig_props,RASTER)

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on


ymax = max(RASTER.psth(:));
ymax = ceil(ymax/5)*5;

if isfield(RASTER,'laser_on')
	laser_on = mean(RASTER.laser_on,2);
	h = rectangle('Position',[laser_on(1),0,laser_on(2) - laser_on(1),ymax]);
	set(h,'EdgeColor','c');
	set(h,'FaceColor','c');

end

num_groups = size(RASTER.psth,1);
col_mat = zeros(num_groups,3);
col_mat(1:end,3) = 1-linspace(0,1,num_groups);

for i_group = 1:num_groups
	plot(RASTER.time,RASTER.psth(i_group,:),'Color',col_mat(i_group,:),'linewidth',2)
end

xlim(RASTER.time_range)
ylabel('Firing rate')
xlabel('Time (s)')
ylim([0 ymax])
set(gca, 'Layer', 'top')


