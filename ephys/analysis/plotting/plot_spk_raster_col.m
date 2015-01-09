function plot_spk_raster_col(fig_props,RASTER,raster_col_mat,rescale_time,raster_mat_full)


% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on

%set(gcf,'Renderer','painters')

%c_map
%colormap(c_map);

if isfield(RASTER,'laser_on')
	plot(RASTER.laser_on,RASTER.laser_on_trial,'-','Color','c')
end
if ~isempty(raster_mat_full)
		imagesc(RASTER.time_range,RASTER.trial_range,raster_mat_full,[0 30]);
end	

num_groups = numel(RASTER.spikes);

	for i_group = 1:num_groups
		if isempty(rescale_time)
			plot(RASTER.spikes{i_group},RASTER.trials{i_group},'.','Color','k','MarkerSize',10)
		else
			times_i = RASTER.spikes{i_group};
			times_i(times_i<1) = times_i(times_i<1)*rescale_time(i_group);
			times_i(times_i>=1) = times_i(times_i>=1)+rescale_time(i_group)-1;
			plot(times_i,RASTER.trials{i_group},'.','Color','k','MarkerSize',10)
		end
	end
	

ylim(RASTER.trial_range)
xlim(RASTER.time_range)
ylabel('Trial number')
xlabel('Time (s)')
%xlim([0 2.5])
set(gca,'visible','off')

