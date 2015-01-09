r_anm_wall = [];
r_anm_run = [];

for i_anm = 7 %1:numel(all_anm.data)
d = all_anm.data{i_anm}.d; 
anm_id = all_anm.names{i_anm};
spike_times_cluster = d.spike_times_cluster.spike_times_cluster;
    [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
    run_thresh = anm_params.run_thresh;
    trial_range_start = anm_params.trial_range_start;
    trial_range_end = anm_params.trial_range_end;
    cell_reject = anm_params.cell_reject;
    exp_type = anm_params.exp_type;
    layer_4_CSD = anm_params.layer_4;
    boundaries = anm_params.boundaries;
    boundary_labels = anm_params.boundary_labels;
    layer_4 = anm_params.layer_4_corr;
trial_range = trial_range_start(1):min(4000,trial_range_end(1));

time_range = [0 4];

  
id_type = 'olR';
keep_name = 'running';
constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials_tmp = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
groups = d.u_ck(1,keep_trials_tmp);
group_ids = unique(groups);
inds = d.u_ck(1,:);

avg_s = zeros(size(d.s_ctk,1),size(d.s_ctk,2),length(group_ids));
avg_r = zeros(size(d.r_ntk,1),size(d.r_ntk,2),length(group_ids));
for ij = 1:length(group_ids)
    sum(inds == ij & keep_trials_tmp)
    avg_s(:,:,ij) = squeeze(mean(d.s_ctk(:,:,inds == group_ids(ij) & keep_trials_tmp),3));
    avg_r(:,:,ij) = squeeze(mean(d.r_ntk(:,:,inds == group_ids(ij) & keep_trials_tmp),3));
end

 %avg_s = d.s_ctk(:,:,keep_trials_tmp);
 %avg_r = d.r_ntk(:,:,keep_trials_tmp);

avg_r = convn(avg_r,ones(1,temp_smooth,1)/temp_smooth,'same');

avg_r = avg_r(:,50:end-50,:);
avg_s = avg_s(:,50:end-50,:);
avg_r = permute(avg_r,[3 2 1]);
avg_s = permute(avg_s,[3 2 1]);

keep_cell = d.p_nj(:,4)<70;
%keep_cell = (d.p_nj(:,15)-d.p_nj(:,13))<2;

sum(keep_cell)
avg_r = avg_r(:,:,keep_cell);

d_F = fdesign.lowpass('N,Fc',4,1,500);
H_bp = design(d_F,'butter');
[b a] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);

for ij = 1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)/500));
    norm_traj_x = traj(250,1);
    norm_traj_y = traj(250,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
    tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = -[0;tmp];
    
    avg_s(ij,:,6) = tmp;
end

run_angle = avg_s(:,1:20:1300,6);
run_angle = run_angle(:);
wall_pos = avg_s(:,1:20:1300,1);
wall_pos = wall_pos(:);
speed = avg_s(:,1:20:1300,4);
speed = speed(:);

wall_pos(wall_pos>30) = 30;
run_angle = run_angle(wall_pos>=6&wall_pos<=16 & speed>5);

norm_act = reshape(avg_r(:,1:20:1300,:),size(avg_r,1)*130/2,size(avg_r,3));
% norm_act_2 = zeros(size(norm_act));
% for ij = 1:size(avg_r,3)
%     tmp = avg_r(:,1:10:1300,ij);
%     norm_act_2(:,ij) = tmp(:);
% end
norm_act = norm_act(wall_pos>=6&wall_pos<=16 & speed>5,:);
wall_pos = wall_pos(wall_pos>=6&wall_pos<=16 & speed>5);

% run_angle = mean(avg_s(:,600:700,6),2);
% wall_pos = mean(avg_s(:,600:700,1),2);
% traj = squeeze(cumsum(avg_s(:,:,4:5),2))/500;

% wall_pos(wall_pos>20) = 20;
% run_angle = run_angle(wall_pos>=0&wall_pos<=20 & traj(:,700,1)>15);
% norm_act = squeeze(mean(avg_r(:,100:700,:),2));
% norm_act = norm_act(wall_pos>=0&wall_pos<=20 & traj(:,700,1)>15,:);
% wall_pos = wall_pos(wall_pos>=0&wall_pos<=20 & traj(:,700,1)>15);


w_run = regress(run_angle,norm_act);
w_wall = regress(wall_pos,norm_act);






 

figure(i_anm)
clf(i_anm)
subplot(1,2,1)
hold on
col_vec = norm_act*w_wall;
plot(wall_pos,col_vec,'.k')
dat = [wall_pos(:) col_vec(:)]; 
edges_2d{1} = [0:.5:30];
edges_2d{2} = [0:.5:30];
[n_vals,C]  = hist3(dat,'edges',edges_2d); % Extract histogram data;
xx = bsxfun(@plus, n_vals, edges_2d{2});
YY_fn_XX = sum(bsxfun(@times,edges_2d{2}',n_vals'))./sum(n_vals');
YY_fn_XX_std = sqrt(arrayfun(@(x) var(edges_2d{2},n_vals(x,:)),1:numel(edges_2d{1}))); 
num_pts  = sum(n_vals');
%YY_fn_XX(num_pts<5) = NaN;
%YY_fn_XX_std(num_pts<5) = NaN;
plot(C{1},YY_fn_XX,'r','LineWidth',2)
xlim([6 16])
ylim([6 16])
mdl = LinearModel.fit(wall_pos,col_vec)
r_anm_wall(i_anm) = mdl.Rsquared.Ordinary;
subplot(1,2,2)
hold on
col_vec = norm_act*w_run;
edges_2d{1} = [-.04:.001:.04];
edges_2d{2} = [-.04:.001:.04];
plot(col_vec,run_angle,'.k')
mdl = LinearModel.fit(col_vec,run_angle)
r_anm_run(i_anm) = mdl.Rsquared.Ordinary;
dat = [col_vec(:) run_angle(:)]; 
[n_vals,C]  = hist3(dat,'edges',edges_2d); % Extract histogram data;
xx = bsxfun(@plus, n_vals, edges_2d{2});
YY_fn_XX = sum(bsxfun(@times,edges_2d{2}',n_vals'))./sum(n_vals');
YY_fn_XX_std = sqrt(arrayfun(@(x) var(edges_2d{2},n_vals(x,:)),1:numel(edges_2d{1}))); 
num_pts  = sum(n_vals');
%YY_fn_XX(num_pts<5) = NaN;
%YY_fn_XX_std(num_pts<5) = NaN;
plot(C{1},YY_fn_XX,'r','LineWidth',2)
xlim([-.04 .04]/2)
ylim([-.04 .04]/2)



%r_anm_wall(4) = [];
%r_anm_run(4) = [];


% figure
% subplot(1,2,1)
% hold on
% bar(1,mean(r_anm_wall))
% plot(1,r_anm_wall,'.r')
% subplot(1,2,2)
% hold on
% bar(1,mean(r_anm_run))
% plot(1,r_anm_run,'.r')


id_type = 'olR';
keep_name = 'running';
constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials_tmp = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
groups = d.u_ck(1,keep_trials_tmp);
group_ids = unique(groups);
inds = d.u_ck(1,:);

avg_s = zeros(size(d.s_ctk,1),size(d.s_ctk,2),length(group_ids));
avg_r = zeros(size(d.r_ntk,1),size(d.r_ntk,2),length(group_ids));
for ij = 1:length(group_ids)
    sum(inds == ij & keep_trials_tmp)
    avg_s(:,:,ij) = squeeze(mean(d.s_ctk(:,:,inds == group_ids(ij) & keep_trials_tmp),3));
    avg_r(:,:,ij) = squeeze(mean(d.r_ntk(:,:,inds == group_ids(ij) & keep_trials_tmp),3));
end

% avg_s = d.s_ctk(:,:,keep_trials_tmp);
% avg_r = d.r_ntk(:,:,keep_trials_tmp);

avg_r = convn(avg_r,ones(1,temp_smooth,1)/temp_smooth,'same');

avg_r = avg_r(:,50:end-50,:);
avg_s = avg_s(:,50:end-50,:);
avg_r = permute(avg_r,[3 2 1]);
avg_s = permute(avg_s,[3 2 1]);

keep_cell = d.p_nj(:,4)>70;
%keep_cell = (d.p_nj(:,15)-d.p_nj(:,13))>2;
sum(keep_cell)

avg_r = avg_r(:,:,keep_cell);

d_F = fdesign.lowpass('N,Fc',4,1,500);
H_bp = design(d_F,'butter');
[b a] = sos2tf(H_bp.sosMatrix,H_bp.scaleValues);

for ij = 1:size(avg_s,1)
    traj = squeeze(cumsum(avg_s(ij,:,4:5)/500));
    norm_traj_x = traj(250,1);
    norm_traj_y = traj(250,2);
    rot = [norm_traj_x norm_traj_y;norm_traj_y -norm_traj_x]/sqrt(norm_traj_x^2 + norm_traj_y^2);
    traj = traj*rot;

    tmp = traj(:,2);
    tmp = [zeros(500,1);tmp;repmat(tmp(end),1000,1)];
    tmp = filtfilt(b,a,tmp);
    tmp = tmp(501:end-1000);
    tmp = diff(tmp);
    tmp = -[0;tmp];
    
    avg_s(ij,:,6) = tmp;
end

run_angle = avg_s(:,1:20:1300,6);
run_angle = run_angle(:);
wall_pos = avg_s(:,1:20:1300,1);
wall_pos = wall_pos(:);
speed = avg_s(:,1:20:1300,4);
speed = speed(:);

wall_pos(wall_pos>30) = 30;
run_angle = run_angle(wall_pos>=6&wall_pos<=16 & speed>5);

norm_act = reshape(avg_r(:,1:20:1300,:),size(avg_r,1)*130/2,size(avg_r,3));
% norm_act_2 = zeros(size(norm_act));
% for ij = 1:size(avg_r,3)
%     tmp = avg_r(:,1:10:1300,ij);
%     norm_act_2(:,ij) = tmp(:);
% end
norm_act = norm_act(wall_pos>=6&wall_pos<=16 & speed>5,:);
wall_pos = wall_pos(wall_pos>=6&wall_pos<=16 & speed>5);



w_run = regress(run_angle,norm_act);
w_wall = regress(wall_pos,norm_act);




figure(i_anm+20)
clf(i_anm+20)
subplot(1,2,1)
hold on
edges_2d{1} = [0:.5:30];
edges_2d{2} = [0:.5:30];
col_vec = norm_act*w_wall;
plot(wall_pos,col_vec,'.k')
dat = [wall_pos(:) col_vec(:)]; 
[n_vals,C]  = hist3(dat,'edges',edges_2d); % Extract histogram data;
xx = bsxfun(@plus, n_vals, edges_2d{2});
YY_fn_XX = sum(bsxfun(@times,edges_2d{2}',n_vals'))./sum(n_vals');
YY_fn_XX_std = sqrt(arrayfun(@(x) var(edges_2d{2},n_vals(x,:)),1:numel(edges_2d{1}))); 
num_pts  = sum(n_vals');
%YY_fn_XX(num_pts<5) = NaN;
%YY_fn_XX_std(num_pts<5) = NaN;
plot(C{1},YY_fn_XX,'r','LineWidth',2)
%plot(C{1},YY_fn_XX-YY_fn_XX_std./sqrt(num_pts),'r','LineWidth',2)
%plot(C{1},YY_fn_XX+YY_fn_XX_std./sqrt(num_pts),'r','LineWidth',2)
xlim([6 16])
ylim([6 16])

mdl = LinearModel.fit(wall_pos,col_vec)
r_anm_wall(i_anm) = mdl.Rsquared.Ordinary;
subplot(1,2,2)
hold on
edges_2d{1} = [-.04:.001:.04];
edges_2d{2} = [-.04:.001:.04];
col_vec = norm_act*w_run;
plot(col_vec,run_angle,'.k')
mdl = LinearModel.fit(col_vec,run_angle)
r_anm_run(i_anm) = mdl.Rsquared.Ordinary;
dat = [col_vec(:) run_angle(:)]; 
[n_vals,C]  = hist3(dat,'edges',edges_2d); % Extract histogram data;
xx = bsxfun(@plus, n_vals, edges_2d{2});
YY_fn_XX = sum(bsxfun(@times,edges_2d{2}',n_vals'))./sum(n_vals');
YY_fn_XX_std = sqrt(arrayfun(@(x) var(edges_2d{2},n_vals(x,:)),1:numel(edges_2d{1}))); 
num_pts  = sum(n_vals');
%YY_fn_XX(num_pts<5) = NaN;
%YY_fn_XX_std(num_pts<5) = NaN;
plot(C{1},YY_fn_XX,'r','LineWidth',2)
%plot(C{1},YY_fn_XX-YY_fn_XX_std./sqrt(num_pts),'r','LineWidth',2)
%plot(C{1},YY_fn_XX+YY_fn_XX_std./sqrt(num_pts),'r','LineWidth',2)

xlim([-.04 .04]/2)
ylim([-.04 .04]/2)

end


