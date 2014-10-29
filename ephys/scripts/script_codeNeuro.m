
d = all_anm.data{2}.d; 
anm_id = all_anm.names{2};
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
u_ind = find(strcmp(d.u_labels,'trial_num'));
raw_trial_nums = d.u_ck(u_ind,:);
keep_trials = raw_trial_nums(keep_trials_tmp);
[group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type,[]);
groups_RASTER = d.u_ck(1,keep_trials_tmp);
g_tmp = zeros(4000,1);
g_tmp(keep_trials) = groups_RASTER;
groups_RASTER = g_tmp;

mean_ds = 1;
temp_smooth = 80;

all_psth = [];
%tmp = []
clust_id = 1;
    RASTER = get_spk_raster(spike_times_cluster{clust_id}.spike_times_ephys,spike_times_cluster{clust_id}.spike_trials,keep_trials,groups_RASTER,group_ids_RASTER,time_range,mean_ds,temp_smooth);

figure;
plot_spk_raster([],RASTER)

id_type = 'olR';
keep_name = 'running';
constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials_tmp = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
u_ind = find(strcmp(d.u_labels,'trial_num'));
raw_trial_nums = d.u_ck(u_ind,:);
keep_trials = raw_trial_nums(keep_trials_tmp);
[group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type,[]);
groups_RASTER = d.u_ck(1,keep_trials_tmp);
g_tmp = zeros(4000,1);
g_tmp(keep_trials) = groups_RASTER;
groups_RASTER = g_tmp;

group_ids_RASTER = [1];
groups_RASTER(groups_RASTER<=2) = 1;
groups_RASTER(groups_RASTER>2) = 0;
mean_ds = 1;
temp_smooth = 80;

all_psth = [];
%tmp = []
clust_id = 1;
    RASTER = get_spk_raster(spike_times_cluster{clust_id}.spike_times_ephys,spike_times_cluster{clust_id}.spike_trials,keep_trials,groups_RASTER,group_ids_RASTER,time_range,mean_ds,temp_smooth);

figure;
set(gcf,'Position',[   440   713   560    85])
set(gcf,'Color',[1 1 1])
plot_spk_raster([],RASTER)
%axis off

id_type = 'olR';
keep_name = 'running';
constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials_tmp = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
groups = d.u_ck(1,keep_trials_tmp);
group_ids = unique(groups);
inds = d.u_ck(1,:);

    avg_s_tmp = squeeze(mean(d.s_ctk(:,:,ismember(inds,[1,2]) & keep_trials_tmp),3));


figure
run_angle = smooth(avg_s_tmp(6,:),50,'sgolay',1);
hold on
plot(avg_s_tmp(6,:))
plot(run_angle,'r')


figure;
hold on
set(gcf,'Position',[   440   713   560    85])
set(gcf,'Color',[1 1 1])
plot(run_angle,'r')
plot(avg_s_tmp(1,:),'k')
xlim([1 2001])
%axis off



id_type = 'olR';
keep_name = 'running';
clust_id = 1;
figure
set(gcf,'Position',[440   626   204   172])
tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
tuning_curve.col_mat = [0 0 0];
plot_tuning_curve_ephys([],tuning_curve)
axis off
id_type = 'olR';
keep_name = 'running';
clust_id = 8;
figure
set(gcf,'Position',[440   626   204   172])
tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
tuning_curve.col_mat = [0 0 0];
plot_tuning_curve_ephys([],tuning_curve)
axis off
id_type = 'olR';
keep_name = 'running';
clust_id = 10;
figure
set(gcf,'Position',[440   626   204   172])
tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
tuning_curve.col_mat = [0 0 0];
plot_tuning_curve_ephys([],tuning_curve)
axis off
id_type = 'olR';
keep_name = 'running';
clust_id = 13;
figure
set(gcf,'Position',[440   626   204   172])
tuning_curve = get_tuning_curve_ephys(clust_id,d,stim_name,keep_name,exp_type,id_type,time_range,trial_range,run_thresh);
tuning_curve.col_mat = [0 0 0];
plot_tuning_curve_ephys([],tuning_curve)
axis off




id_type = 'olR';
keep_name = 'running';
constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials_tmp = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
u_ind = find(strcmp(d.u_labels,'trial_num'));
raw_trial_nums = d.u_ck(u_ind,:);
keep_trials = raw_trial_nums(keep_trials_tmp);
[group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type,[]);
groups_RASTER = d.u_ck(1,keep_trials_tmp);
g_tmp = zeros(4000,1);
g_tmp(keep_trials) = groups_RASTER;
groups_RASTER = g_tmp;

group_ids_RASTER = [1];
groups_RASTER(groups_RASTER<=2) = 1;
groups_RASTER(groups_RASTER>2) = 0;
mean_ds = 1;
temp_smooth = 80;

all_psth = [];
%tmp = []
clust_id = 13;
    RASTER = get_spk_raster(spike_times_cluster{clust_id}.spike_times_ephys,spike_times_cluster{clust_id}.spike_trials,keep_trials,groups_RASTER,group_ids_RASTER,time_range,mean_ds,temp_smooth);

figure;
set(gcf,'Position',[   440   713   560    85])
set(gcf,'Color',[1 1 1])
plot_spk_raster([],RASTER)
id_type = 'olR';
keep_name = 'running';
constrain_trials = define_keep_trials_ephys(keep_name,id_type,exp_type,trial_range,run_thresh);
keep_trials_tmp = apply_trial_constraints(d.u_ck,d.u_labels,constrain_trials);
u_ind = find(strcmp(d.u_labels,'trial_num'));
raw_trial_nums = d.u_ck(u_ind,:);
keep_trials = raw_trial_nums(keep_trials_tmp);
[group_ids_RASTER groups_RASTER] = define_group_ids(exp_type,id_type,[]);
groups_RASTER = d.u_ck(1,keep_trials_tmp);
g_tmp = zeros(4000,1);
g_tmp(keep_trials) = groups_RASTER;
groups_RASTER = g_tmp;

group_ids_RASTER = [1];
groups_RASTER(groups_RASTER<=2) = 1;
groups_RASTER(groups_RASTER>2) = 0;
mean_ds = 1;
temp_smooth = 80;

all_psth = [];
%tmp = []
clust_id = 1;
    RASTER = get_spk_raster(spike_times_cluster{clust_id}.spike_times_ephys,spike_times_cluster{clust_id}.spike_trials,keep_trials,groups_RASTER,group_ids_RASTER,time_range,mean_ds,temp_smooth);
plot_spk_raster([],RASTER)


filename ='/Users/sofroniewn/Movies/virtual_corridor.mp4';

A = mmread(filename);

figure
imshow(A.frames(1).cdata)





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

avg = squeeze(mean(im_session.reg.align_mean(:,:,3,1,:),5));

figure;
imshow(avg/500)


X = squeeze(im_session.reg.align_mean(:,:,:,1,:))/500;
X = X(:,:,3,:);
X = X(:,:,:,1:20);
X = repmat(X,[1,1,3,1]);
mov = immovie(X,[]);


    X = squeeze(im_session.reg.align_mean(:,:,3,1,:));


writerObj = VideoWriter('/Users/sofroniewn/Movies/test8.avi');
writerObj.FrameRate = 10;
open(writerObj);
figure
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[0 0 512-40 512-40])
set(gca,'Position',[0 0 1 1])
colormap('gray')
for k = 1:size(X,3) 
    image(X(20:end-20,20:end-20,k)/10)
    num_s = (k-1)*10;
h_str = text(.86,.96,sprintf('%d s',num_s),'Color',[.99 .99 .99],'FontSize',20,'Units','Normalized');
axis off
axis equal
   frame = getframe;
   writeVideo(writerObj,frame);
end

close(writerObj);



writerObj = VideoWriter('/Users/sofroniewn/Movies/test_conv2.avi');
writerObj.FrameRate = 5;
open(writerObj);
figure
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[0 0 512-40 512-40])
set(gca,'Position',[0 0 1 1])
streaming_mode = 1;
c_lim_overlay = [500];
clim = [30 400];
plot_planes = 3;
chan_num = 1;
ref = im_session.ref;
num_s = 0;
h_str = text(.9,.9,sprintf('%d s',num_s),'Color',[.99 .99 .99],'FontSize',20,'Units','Normalized');
for trial_num = 1:58
open(writerObj);
[im_comb a cmap_str] = plot_spark_regression_tune_overlay(im_session,ref,trial_num,chan_num,plot_planes,clim,c_lim_overlay,streaming_mode);
imshow(im_comb(20:end-20,20:end-20,:));
num_s = (trial_num-1)*10;
h_str = text(.87,.96,sprintf('%d s',num_s),'Color',[.99 .99 .99],'FontSize',20,'Units','Normalized');

%set(h_str,'string',sprintf('%d s',num_s))
axis off
axis equal
   frame = getframe;
   writeVideo(writerObj,frame);
end

close(writerObj);




streaming_mode = 1;
c_lim_overlay = [500];
clim = [30 400];
plot_planes = 3;
chan_num = 1;
ref = im_session.ref;

trial_num = 58;
[im_comb clim cmap_str] = plot_spark_regression_tune_overlay(im_session,ref,trial_num,chan_num,plot_planes,clim,c_lim_overlay,streaming_mode);
figure; image(im_comb)
h = text(0,1,sprintf('%d s',num_s),'Color',[.99 .99 .99],'FontSize',20,'Units','Normalized');







