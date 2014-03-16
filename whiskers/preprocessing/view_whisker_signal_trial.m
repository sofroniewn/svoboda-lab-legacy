%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

whisker_signal_files = dir([base_dir, '*WST.mat']);
vid_file_list = dir([base_dir '*.mp4']);

trajectory_cols = ['r' 'g' 'b' 'c' 'm' 'y'];
trajectory_nums = [0 1];

%%
file_id = ceil(numel(vid_file_list)/2); %specifiy trial
frame_id = 1; %specify frame

load([base_dir whisker_signal_files(file_id).name]);
vid_file = mmread([base_dir vid_file_list(file_id).name],frame_id);
wv_frame = vid_file.frames.cdata;
%% View traced whiskers overlayed on whisker movie image

rotate_on = 0;
face_mask_on = 0;

figure(201)
clf(201)
hold on


 if rotate_on == 1
     wv_frame = imrotate(wv_frame,90);
 else
 end
 
 imshow(wv_frame)

for kk = 1:length(trajectory_nums)
    plotString = [trajectory_cols(kk) '-'];
    
    tid = trajectory_nums(kk);
    ind = ws.trajectoryIDs==tid;
    fittedX = ws.polyFits{ind}{1};
    fittedY = ws.polyFits{ind}{2};
    t = ws.get_time(tid);
    t = 1+round(ws.time{ind}*500);
    frameInds = find(t == frame_id);
    nframes = length(frameInds);
    x = cell(1,nframes);
    y = cell(1,nframes);
    
    q = linspace(0,1);
    
    for k=1:nframes
        f = frameInds(k);
        
        px = fittedX(f,:);
        py = fittedY(f,:);
        x{k} = polyval(px,q);
        y{k} = polyval(py,q);
        hold on
        if rotate_on == 1
            plot(y{k},-x{k}+wv_frame_size(1),plotString,'LineWidth',2)
        else
            plot(x{k},y{k},plotString,'LineWidth',2)
        end
    end
    
end
 if face_mask_on == 1 && rotate_on == 0
    ws.plot_mask(0,'r')
 else
 end
 

title(whisker_signal_files(file_id).name,'Interpreter','none')
if rotate_on == 1
    set(gcf,'Position',[150 146 442 628]);
    set(gca,'XLim',[0 wv_params.imagePixelDimsXY(2)],'YLim',[0 wv_params.imagePixelDimsXY(1)])
else
    set(gcf,'Position', [662   264   714   823]);
    set(gca,'XLim',[0 imagePixelDimsXY(1)],'YLim',[0 imagePixelDimsXY(2)])
end

fig_name = [base_dir 'traced_example'];

plot([20,20+5*wv_params.pix_per_mm],[wv_params.imagePixelDimsXY(2)-20 wv_params.imagePixelDimsXY(2)-20],'Color',[1 1 1],'LineWidth',6)
%plot([20,20],[imagePixelDimsXY(2)-20 imagePixelDimsXY(2)-20 - 15*pix_per_mm],'Color',[1 1 1],'LineWidth',6)
text(5,wv_params.imagePixelDimsXY(2)+15,'5mm')

set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPositionMode','auto')
print('-depsc',fig_name);
print('-dbmp',fig_name);

%% View time projection of traced whiskers overlayed on whisker first frame
trial_frame_lims = [0 10.101]; %% in seconds ....

figure(202)
clf(202)
hold on
%imshow(wv_frame)

for kk = 1:length(trajectory_nums)
    plotStr = [trajectory_cols(kk) '-'];
    ws.plot_fitted_whisker_time_projection(trajectory_nums(kk),plotStr,trial_frame_lims)
end

%title(whisker_signal_files(file_id).name,'Interpreter','none')
%set(gca,'XLim',[0 imagePixelDimsXY(1)],'YLim',[0 imagePixelDimsXY(2)])
set(gcf,'Position',[662   264   714   823]);

%fig_name = [base_dir 'traced_example'];

%plot([20,20+5*pix_per_mm],[imagePixelDimsXY(2)-20 imagePixelDimsXY(2)-20],'Color',[1 1 1],'LineWidth',6)
%plot([20,20],[imagePixelDimsXY(2)-20 imagePixelDimsXY(2)-20 - 15*pix_per_mm],'Color',[1 1 1],'LineWidth',6)

% set(gcf,'PaperOrientation','portrait')
% set(gcf,'PaperPositionMode','auto')
% print('-depsc',fig_name);
% print('-dbmp',fig_name);

%% View time projection of traced whiskers overlayed on whisker first frame
trial_frame_lims = [0 1.01]; %% in seconds ....

figure(203)
clf(203)
hold on

%imshow(wv_frame)

for kk = 1:length(trajectory_nums)
    ws.plot_fitted_whisker_time_projection(trajectory_nums(kk),'k-',trial_frame_lims,{[10 20], [trajectory_cols(kk) '-']})
    %ws.plot_fitted_whisker_time_projection(trajectory_nums(kk),[trajectory_cols(kk) '-'],trial_frame_lims,{poly_roi_lims, [trajectory_cols(kk) '-']})
end

plot([20,20+5*wv_params.pix_per_mm],[wv_params.imagePixelDimsXY(2)-20 wv_params.imagePixelDimsXY(2)-20],'Color',[1 1 1],'LineWidth',6)

%title(whisker_signal_files(file_id).name,'Interpreter','none')
set(gca,'XLim',[0 wv_params.imagePixelDimsXY(1)],'YLim',[0 wv_params.imagePixelDimsXY(2)])
set(gcf,'Position',[662   264   714   823]);