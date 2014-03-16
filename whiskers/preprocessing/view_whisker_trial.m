%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


whisker_trial_files = dir([base_dir, '*WT.mat']);
vid_file_list = dir([base_dir '*.mp4']);

num_files = length(whisker_trial_files);

trajectory_cols = ['r' 'g' 'b' 'c' 'm' 'y'];
trajectory_nums = [0 1];
%%
file_id = 1; %specifiy trial
frame_id = 20; %specify frame

load([base_dir whisker_trial_files(file_id).name]);
vid_file = mmread([base_dir vid_file_list(file_id).name],frame_id);
wv_frame = vid_file.frames.cdata;

%% View traced whiskers overlayed on whisker movie image

figure(201)
clf(201)
hold on

imshow(wv_frame)

for kk = 1:length(trajectory_nums)
    w.plot_whiskers(frame_id-1,trajectory_nums(kk),[],trajectory_cols(kk))
end

title(whisker_trial_files(file_id).name,'Interpreter','none')
set(gca,'XLim',[0 wv_params.imagePixelDimsXY(1)],'YLim',[0 wv_params.imagePixelDimsXY(2)])
                set(gcf,'Position', [662   264   714   823]);


%% View time projection of traced whiskers overlayed on whisker first frame
downsample = 100;
trial_frame_lims = [0 15];

figure(301)
clf(301)
hold on
trajectory_cols = ['r' 'g' 'b' 'c' 'm' 'y'];
trajectory_nums = [0 1];

%imshow(wv_frame)

for kk = 1:length(trajectory_nums)
    w.plot_whisker_time_projection(trajectory_nums(kk),trajectory_cols(kk),trial_frame_lims,downsample)
end

%title(whisker_trial_files(file_id).name,'Interpreter','none')
set(gca,'XLim',[0 wv_params.imagePixelDimsXY(1)],'YLim',[0 wv_params.imagePixelDimsXY(2)])
                set(gcf,'Position', [662   264   714   823]);


