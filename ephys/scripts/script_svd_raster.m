
d = all_anm.data{anm_id}.d;
keep_name = 'running';
id_type = 'olR';
trial_range_end = min(4000,d.anm_params.trial_range_end(1));
trial_range = [d.anm_params.trial_range_start(1):trial_range_end];
run_thresh = d.anm_params.run_thresh;
exp_type = d.anm_params.exp_type;


constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
 
raster_mat = squeeze(d.r_ntk(cluster_id,:,keep_trials))';
sense_mat = squeeze(d.s_ctk(1,:,keep_trials))';
[group_ids groups] = define_group_ids(exp_type,id_type,[]);
groups = d.u_ck(1,keep_trials);

raster_mat_avg = NaN(length(group_ids),size(raster_mat,2));
sense_mat_avg = NaN(length(group_ids),size(raster_mat,2));
for ij = 1:length(group_ids)
  tmp = mean(raster_mat(groups == group_ids(ij),:),1);
  tmps = mean(sense_mat(groups == group_ids(ij),:),1);
  if ~isempty(tmp)
    raster_mat_avg(ij,:) = tmp;
    sense_mat_avg(ij,:) = tmps;
  end
end

temp_smooth = 80;
raster_mat = conv2(raster_mat,ones(1,temp_smooth)/temp_smooth);
raster_mat_avg = conv2(raster_mat_avg,ones(1,temp_smooth)/temp_smooth);


avg_on = NaN(length(group_ids),601);
avg_off = NaN(length(group_ids),601);

for ij = 1:length(group_ids)
 	onset = find(sense_mat_avg(ij,:)<=16,1,'first');
 	 offset = find(sense_mat_avg(ij,:)<=16,1,'last');
  if ~isempty(onset) && ~isempty(offset)
      avg_on(ij,:) = raster_mat_avg(ij,onset-200:onset+400);
      avg_off(ij,:) = raster_mat_avg(ij,offset-400:offset+200);
  end
end
avg_off = flipdim(avg_off,2);

raster_mat_avg = raster_mat_avg(:,80:end-80);

figure(16)
clf(16)
imagesc(raster_mat_avg)
set(gca,'ydir','normal')

%[U,S,V] = svd(raster_mat_avg);
[U,V] = nnmf(raster_mat_avg,1);
U = -U;
V = -V';

figure(17)
clf(17)
hold on
plot(-zscore(U(:,1)))
plot(zscore(mean(raster_mat_avg,2)),'r')

figure(18)
clf(18)
hold on
plot(-zscore(V(:,1)))
plot(zscore(mean(raster_mat_avg,1)),'r')


raster_mat_recon = U(:,1)*V(:,1)';
% 
% figure(19)
% clf(19)
% imagesc(raster_mat_recon)
% set(gca,'ydir','normal')

figure(20)
clf(20)
hold on
plot(nanmean(avg_on))
plot(nanmean(avg_off),'r')




