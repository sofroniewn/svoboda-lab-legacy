function plot_spk_raster(fig_props,RASTER,raster_col_mat,rescale_time,raster_mat_full)


% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on

%set(gcf,'Renderer','painters')

if isfield(RASTER,'laser_on')
	plot(RASTER.laser_on,RASTER.laser_on_trial,'-','Color','c')
end
if ~isempty(raster_mat_full)
	imagesc([0 4],[1 max(RASTER.trials{end})],raster_mat_full);
end	


num_groups = numel(RASTER.spikes);
col_mat = zeros(num_groups,3);
col_mat(1:end,3) = 1-linspace(0,1,num_groups);
%col_mat = [1 0 0];
if isempty(raster_col_mat)
	for i_group = 1:num_groups
		if isempty(rescale_time)
			plot(RASTER.spikes{i_group},RASTER.trials{i_group},'.','Color',col_mat(i_group,:),'MarkerSize',10)
		else
			times = RASTER.spikes{i_group};
			times(times<1) = times(times<1)*rescale_time(i_group);
			times(times>=1) = times(times>=1)+rescale_time(i_group)-1;
			plot(times,RASTER.trials{i_group},'.','Color',col_mat(i_group,:),'MarkerSize',10)
		end
	end
else
	for i_group = 1:num_groups
		times = RASTER.spikes{i_group};
		if isempty(rescale_time)
		else
			times(times<1) = times(times<1)*rescale_time(i_group);
			times(times>=1) = times(times>=1)+rescale_time(i_group)-1;
		end

		ind = round(500*times)+1;
		ind(ind<=0) = 1;
		ind(ind>=size(raster_col_mat,2)) = size(raster_col_mat,2);
		scatter(times,RASTER.trials{i_group},[],squeeze(raster_col_mat(i_group,ind,:)),'Marker','.','SizeData',40);
	end	
end

ylim(RASTER.trial_range)
xlim(RASTER.time_range)
ylabel('Trial number')
xlabel('Time (s)')


