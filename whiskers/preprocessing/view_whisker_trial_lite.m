%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vid_dir_base = 'W:\processed\sofroniewn\';

animal_name = '159346';
cur_date = '120605';
run_num = '1';
vid_dir = [vid_dir_base animal_name 'w\' '20' cur_date(1:2) '_' cur_date(3:4) '_' cur_date(5:6) '-' run_num '\'];

vid_file_list = dir([vid_dir '*.mp4']);

files = dir([vid_dir, '*WL.mat']);
nfiles = length(files);

trajectory_nums = [0 1 2 3 4 5];
trajectory_cols = ['r' 'c' 'y' 'g' 'b' 'm'];

%trajectory_nums = [0 1 ];
%trajectory_cols = ['r' 'g' ];

poly_roi_lims = [25 80];

%%

file_id = 5; %specifiy trial

load(horzcat(vid_dir,files(file_id).name));

%% View whisker angle
figure(401)
clf(401)
hold on

for kk = 1:length(trajectory_nums)
    wl.plot_whisker_angle(trajectory_nums(kk),[trajectory_cols(kk) '-'])
   % wl.plot_whisker_curvature(trajectory_nums(kk),[trajectory_cols(kk) '-'])
end

title(files(file_id).name,'Interpreter','none')

    set(gcf,'Position',[150 219 1115 555]);
    set(gca,'XLim',[0 ceil(4999/500)],'YLim',[-90 90])


%% View whisker anlge
figure(402)
clf(402)
hold on
trajectory_cols_2 = ['r' 'r' 'r' 'k' 'k' 'k'];

for kk = 1:length(trajectory_nums)
     tid = trajectory_nums(kk);
     [y, t] = wl.get_position(tid);
     %[y, t] = wl.get_curvature(tid);
     t = 1+round(t*500);
     plot(t,y,[trajectory_cols_2(kk) '-'])
end

title(files(file_id).name,'Interpreter','none')
set(gcf,'Position',[150 219 1115 555]);
set(gca,'XLim',[0 4999],'YLim',[-90 90])

%% View whisker anlge
figure(403)
clf(403)
hold on

theta = nan(5000,length(trajectory_nums));

for kk = 1:length(trajectory_nums)
     tid = trajectory_nums(kk);
     [y, t] = wl.get_position(tid);
     %[y, t] = wl.get_curvature(tid);
     t = 1+round(t*500);
     theta(t,kk) = y;
end

theta_R = nanmean(theta(:,1:3),2);
theta_L = nanmean(theta(:,4:6),2);

frames_R = ~isnan(theta_R);
frames_L = ~isnan(theta_L);

plot(find(frames_R),theta_R(frames_R),'r');
plot(find(frames_L),theta_L(frames_L),'g');

title(files(file_id).name,'Interpreter','none')
set(gcf,'Position',[150 219 1115 555]);
set(gca,'XLim',[0 4999],'YLim',[-90 90])



