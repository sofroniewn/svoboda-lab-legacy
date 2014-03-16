valve_open = 1;
lick_state = 1;
inter_trial_trig = 1;
scim_state = 1;
masking_flash_on = 1;
running_ind = 0;
test_val = 1;
cur_trial_num = 38;

log_state_a = valve_open + 2*lick_state + 4*inter_trial_trig;
            log_state_b = scim_state + 2*masking_flash_on + 4*running_ind;
            log_state_c = test_val + 2*0 + 4*0;
            log_cur_state = im_scale0*log_state_c+im_scale*log_state_b+100*log_state_a + cur_trial_num;
            %%
            global session
       %%
speed = [];
for ij = 1:103;
    speed = [speed ; session.data{ij}.processed_matrix(5,:)'];
end
%%
B = ones(50,1)/50;
speed = conv(speed,B);
speed(speed<2) = [];
       %%
figure(23)
clf(23)
hold on
hist(speed,20)
%plot(speed,'g')
       
       
       
       
             %%
figure(23)
clf(23)
hold on
hist((session.data{2}.trial_matrix(3,:)+im_scale*session.data{2}.trial_matrix(4,:))/100,100)
        
       
       
       %%
       2.62-2.45
       2.77-2.62
       
       
       
       
            %%
            
             AA = mod(log_cur_state,100);
%     A = floor(mod(log_cur_state,100)/10);
%     B = floor(mod(log_cur_state,im_scale)/100);
%     C = floor(mod(log_cur_state,im_scale0)/im_scale);

    A = mod(floor(log_cur_state/100),10);
    B = mod(floor(log_cur_state/im_scale),10);
    C = mod(floor(log_cur_state/im_scale0),10);
    
    v = mod(A,2)
    l = mod(floor(A/2),2)
    iti = mod(floor(A/4),2)    
    
    [cur_trial_num AA]
        [log_state_a A]
        [log_state_b B]
        [log_state_c C]
 
        %%
        laser_power = 45.3;
        max_galvo_pos = 5;
        x_mirror_pos = 2.6;
        y_mirror_pos = -1.2;
        
                    log_photo_stim = floor(10*laser_power)*im_scale0 + floor((x_mirror_pos+max_galvo_pos)*10)*100 + floor((y_mirror_pos+max_galvo_pos)*10);

    
                    
LP = floor(log_photo_stim/im_scale0)/10
    X = floor(mod(log_photo_stim,im_scale0)/100)/10 - 5
    Y = floor(mod(log_photo_stim,100))/10 - 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    
global session                    
%%     
trial_num = 15;
figure(1)
clf(1)
hold on
plot(session.data{trial_num}.trial_matrix(14,:))
plot(session.data{trial_num}.trial_matrix(9,:),'r')
plot(session.data{trial_num}.processed_matrix(7,:),'.g')

session.trial_info.scim_num_trigs(trial_num);
%%
load('Y:\users\Sofroniewn\DATA_IM_RIG\TEST\data_C.mat')
%%
num_files = numel(scim_info)-1;

for ij = 1:num_files
    scim_trigs = find(session.data{ij}.processed_matrix(6,:));
    numPlanes = scim_info{ij}.improps.numPlanes;
    frame_shift = mod(session.trial_info.scim_cum_trigs(ij),numPlanes);
    if frame_shift ~=0
        frame_shift = numPlanes - frame_shift;
    end
    scim_trigs = scim_trigs(1+frame_shift:numPlanes:end);
    session.data{ij}.processed_matrix(7,:) = 0*session.data{ij}.processed_matrix(7,:);
    session.data{ij}.processed_matrix(7,scim_trigs) = 1;
    session.trial_info.scim_num_frames(ij) = length(find(session.data{ij}.processed_matrix(7,:)));
    session.trial_info.firstFrameNumberRelTrigger(ij) = session.trial_info.scim_cum_trigs(ij) + frame_shift + 1;
end
%%
display([]);
display(['Start alignment ']);
for ij = 1:num_files
    scim_info{ij}.improps.nvols = scim_info{ij}.improps.nframes/scim_info{ij}.improps.numPlanes;
    
    % Check if trial has logging enabled
    if session.trial_info.scim_logging(ij) == 1
        % Check if start frame relative to onset trigger is correct
        if scim_info{ij}.improps.firstFrameNumberRelTrigger ~= session.trial_info.firstFrameNumberRelTrigger(ij)
            warning(['Not aligned trigger start trial ' num2str(ij)])
        end
        
        % Check if number of volumes is either correct or one extra
        if scim_info{ij}.improps.nvols == session.trial_info.scim_num_frames(ij) || scim_info{ij}.improps.nvols - 1 == session.trial_info.scim_num_frames(ij)
            % Check if number of volumes is one extra
            if scim_info{ij}.improps.nvols - 1 == session.trial_info.scim_num_frames(ij)
               % If have one extra volume add it to the end of the current
               % trial
                session.data{ij}.processed_matrix(7,end) = 1;
                session.trial_info.scim_num_frames(ij) = session.trial_info.scim_num_frames(ij)+1;
               % If next file exists remove first volume from that one
               if ij+1 <= num_files
                ind = find(session.data{ij+1}.processed_matrix(7,:) == 1,1,'first');
                session.data{ij+1}.processed_matrix(7,ind) = 0;
                session.trial_info.scim_num_frames(ij+1) = session.trial_info.scim_num_frames(ij+1)-1;
                session.trial_info.firstFrameNumberRelTrigger(ij+1) = session.trial_info.firstFrameNumberRelTrigger(ij+1) + scim_info{ij}.improps.numPlanes;
               end
            end
        else
            warning(['Not aligned num vols ' num2str(ij)])
        end
    end
end
display(['End alignment']);


%%
num_files = numel(scim_info);
frame_info = zeros(num_files,6);
for ij = 1:num_files
        scim_info{ij}.improps.nvols = scim_info{ij}.improps.nframes/scim_info{ij}.improps.numPlanes; 
        
%      if scim_info{ij}.improps.startOffsetMS > frame_rate
%          % IF time for next frame to arrive after new file trigger is larger than
%          % one frame rate, this file will have an extra frame trigger at the
%          % beginning corresponding that needs to be ignored and the file
%          % before hand will be missing one frame trigger that needs to be
%          % added to the end.
%          % To do the updating in real-time for a current trial, load the improps,
%          % If startOffSetMS > frame_rate delete first frame trigger
%          % Check number of frames, if one frame trigger short add an extra
%          % frame_trigger at the end. Othwerwise num frames should match num
%          % frame triggers. Otherwise something is broken
%          session.data{ij-1}.processed_matrix(6,end) = 1;
%          ind = find(session.data{ij}.processed_matrix(6,:) == 1,1,'first');
%          session.data{ij}.processed_matrix(6,ind) = 0;
%          session.trial_info.num_scim_trigs(ij-1) = session.trial_info.num_scim_trigs(ij-1)+1;
%          session.trial_info.num_scim_trigs(ij)= session.trial_info.num_scim_trigs(ij)-1;
%      end
    scim_info{ij}.improps.nvols = scim_info{ij}.improps.nframes/scim_info{ij}.improps.numPlanes; 
    frame_info(ij,1) = ij;
    frame_info(ij,2) = scim_info{ij}.improps.nvols;
    frame_info(ij,3) = scim_info{ij}.improps.startOffsetMS;
    frame_info(ij,4) = scim_info{ij}.improps.startOffsetMS > scim_info{ij}.improps.numPlanes*scim_info{ij}.improps.frameRate;
    frame_info(ij,5) = scim_info{ij}.improps.firstFrameNumberRelTrigger;
    frame_info(ij,6) = scim_info{ij}.improps.nframes;

end


frame_diff = frame_info(:,2) - session.trial_info.scim_num_frames(1:num_files);

[frame_info(:,1:4) session.trial_info.scim_num_frames(1:num_files) frame_diff session.trial_info.scim_logging(1:num_files)]


%%
starts = 1+4*ceil(session.trial_info.scim_cum_trigs/4)
%%
[diff(frame_info(:,5))-frame_info(1:end-1,6)]
%%
[frame_info(:,5:6), session.trial_info.firstFrameNumberRelTrigger session.trial_info.scim_num_frames]
%%

log_fname = 'E:\Documents and Settings\user\My Documents\WGNR\NEW_GUI\DATA\anm_0227254\2013_12_09\run_01\behaviour\anm_0227254_2013x12x09_run_01_log.txt';
log_fname = 'E:\Documents and Settings\user\My Documents\WGNR\WGNR_matlab\DATA\Son\121013\anm229334\anm229334_121013_3_log.txt'
% log_fname = 'E:\Documents and Settings\user\My Documents\WGNR\WGNR_matlab\DATA\Son\120913\anm229334\anm229334_120913_1_log.txt'
  log_fname = 'E:\Documents and Settings\user\My Documents\WGNR\WGNR_matlab\DATA\Son\120113\anm229334\anm229334_120113_1_log.txt'
% log_fname = 'E:\Documents and Settings\user\My Documents\WGNR\WGNR_matlab\DATA\Son\120813\anm227057\anm227057_120813_1_log.txt'
% log_fname = 'E:\Documents and Settings\user\My Documents\WGNR\WGNR_matlab\DATA\Son\120913\anm227057\anm227057_120913_1_log.txt'
% log_fname = 'E:\Documents and Settings\user\My Documents\WGNR\WGNR_matlab\DATA\Son\121013\anm227057\anm227057_121013_1_log.txt'

 % log_fname = 'E:\Documents and Settings\user\My Documents\WGNR\WGNR_matlab\DATA\Son\112713\anm229334\anm229334_112713_2_log.txt'
% log_fname = 'E:\Documents and Settings\user\My Documents\WGNR\WGNR_matlab\DATA\Son\112713\anm227057\anm227057_112713_2_log.txt'
% log_fname = 'E:\Documents and Settings\user\My Documents\WGNR\WGNR_matlab\DATA\131014\131014_Anm_225103_Run_1_log.txt'

% log_fname = 'E:\Documents and Settings\user\My Documents\WGNR\WGNR_matlab\DATA\Son\121013\anm227057\anm227057_121013_1_log.txt'

fid = fopen(log_fname);
                raw = fscanf(fid,'%f');
                fclose(fid);
                
             
                
               
                raw_cam_steps = raw(2:4:end);
               
                
               
            cam_vel_step = zeros(length(raw_cam_steps),4);
            zz = raw_cam_steps;
            
            cam_vel_step(:,4) = round(zz/36^3);
            zz = zz - cam_vel_step(:,4)*36^3;
            cam_vel_step(:,3) = round(zz/36^2);
            zz = zz - cam_vel_step(:,3)*36^2;
            cam_vel_step(:,2) = round(zz/36^1);
            zz = zz - cam_vel_step(:,2)*36^1;
            cam_vel_step(:,1) = round(zz);
            zz = zz - cam_vel_step(:,1);
            zz = unique(zz);
            
            if zz~=0
                error('Ball motion code not right')
            else
            end

%%
A_calib_str = '{{-0.0665, -3.8941, 0.0835, 0.0428}, {0.0566, 0.0558, 0.1107, 4.0800}, {-2.0361, 0, -2.2392, 0}}'; % Ball motion calibration matrix
tmp = eval(A_calib_str);
A_inv = [];
for ij = 1:3
    A_inv(ij,:) = cell2mat(tmp{ij});
end
A_inv = A_inv/500;
    d_ball_pos = cam_vel_step*A_inv';
    d_ball_pos = d_ball_pos(:,1:2);
speed = 500*sum(d_ball_pos.^2,2).^(1/2);
B = ones(50,1)/50;
speed = conv(speed,B);
speed(speed<5) = [];
%%
figure(403)
hist(speed,50)
%%
figure
B = ones(50,1)/50;
hold on
plot(conv(cam_vel_step(:,1),B),'r')
plot(conv(cam_vel_step(:,2),B),'g')
plot(conv(cam_vel_step(:,3),B),'b')
plot(conv(cam_vel_step(:,4),B),'k')










