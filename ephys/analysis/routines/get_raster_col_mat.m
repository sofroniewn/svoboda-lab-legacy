function [raster_mat raster_mat_full raster_mat_rescale_full raster_col_mat rescale_time] = get_raster_col_mat(d)

exp_type = d.anm_params.exp_type

id_type = 'olR';
[group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type,[]);
    group_ids_RASTER
    
raster_mat = zeros(length(group_ids_RASTER),size(d.s_ctk,2));
raster_mat_rescale = zeros(length(group_ids_RASTER),size(d.s_ctk,2));
for ij = 1:length(group_ids_RASTER)
	keep_trials = d.u_ck(1,:) == group_ids_RASTER(ij);
	raster_mat(ij,:) = mean(d.s_ctk(1,:,keep_trials),3); % wall pos
%	rescale_time(ij) = mean(d.u_ck(11,keep_trials)); % wall_pos avg
	rescale_time(ij) = mean(mean(squeeze(d.s_ctk(1,750:1250,keep_trials)))); % wall_pos avg
	if rescale_time(ij) == 30
	raster_mat_rescale(ij,:) = 30;
	else
	ind = round(500*(30-rescale_time(ij))/30);
	raster_mat_rescale(ij,1:ind) = linspace(30,rescale_time(ij),ind);
	raster_mat_rescale(ij,ind+1:end) = rescale_time(ij);
	end
end

raster_mat_full = squeeze(d.s_ctk(1,:,ismember(d.u_ck(1,:),group_ids_RASTER)))';
raster_mat_full = max(raster_mat_full(:)) - raster_mat_full;

ids = d.u_ck(1,ismember(d.u_ck(1,:),group_ids_RASTER));
[a b ind] = unique(ids);
raster_mat_rescale_full = raster_mat_rescale(ind,:);
raster_mat_rescale_full = max(raster_mat_rescale_full(:)) - raster_mat_rescale_full;


raster_mat = ceil(10*(max(raster_mat(:)) - raster_mat))+1;
num_col = max(raster_mat(:));
c_map = jet(num_col);
%num_groups = numel(RASTER.spikes);
c_map = zeros(num_col,3);
c_map(1:end,3) = linspace(0,1,num_col);


raster_col_mat = zeros(length(group_ids_RASTER),size(d.s_ctk,2),3);

raster_col_mat = c_map(raster_mat,:);

raster_col_mat = reshape(raster_col_mat,length(group_ids_RASTER),size(d.s_ctk,2),3);


rescale_time = (max(rescale_time)-rescale_time)/max(rescale_time);
rescale_time(rescale_time==0) = 1;

whos