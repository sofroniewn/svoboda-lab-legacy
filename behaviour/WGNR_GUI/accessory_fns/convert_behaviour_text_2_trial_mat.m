function convert_behaviour_text_2_trial_mat(data_dir,wgnr_dir)

load('/Users/sofroniewn/Dropbox/nicholas/behaviour/an217489/2013_07_19/behaviour/run_1/130719_Anm_217489_Run_1_data_v3.mat')

wgnr_dir

run([PathName,FileName]);

% NEED PS SITES
% NEED TRIAL_CONFIG
% NEED RIG_CONFIG

% save out "trial num"
% save out "trial_mat_names"
% save out "trial_matrix"

trial_mat_names = {'x_vel','y_vel','cor_pos','cor_width','laser_power','x_mirror_pos','y_mirror_pos', ...
    'trial_num','inter_trial_trig','lick_state','water','running_ind', ...
    'masking_flash_on','scim_state','undefined','scim_logging','test_val'};

figure(1)
clf(1)
hold on
plot(data.cl_dir_state.data(data.test_period.data>0),data.cor_pos.data(data.test_period.data>0),'.r')
%plot(2-data.cl_gf_state.data) %% plot of running ind

%figure(1)
%clf(1)
%hold on
%plot(smooth(data.speed.data/10,500),'r')
%plot(2-data.cl_gf_state.data) %% plot of running ind


trial_end_times = data.trial_period.stop_inds; % vector containing trial end times
trial_start = 1;

x_vel = data.d_ball_pos_x.data;
y_vel = data.d_ball_pos_y.data;
cor_pos = data.cor_pos.data;
cor_width = 30*ones(data.num_reads,1);
laser_power = data.laser_power.data;
x_mirror_pos = data.x_mirror_pos.data;
y_mirror_pos = data.y_mirror_pos.data;
trial_num = ones(data.num_reads,1); % NEED TO EDIT along with trial config
inter_trial_trig = 1-data.trial_period.data;
lick_state = data.licks.data;
water = data.water.data;
running_ind = 2-data.cl_gf_state.data;
masking_flash_on = data.masking_flash.data;
scim_state = data.scim_trig;
undefined = zeros(data.num_reads,1);
scim_logging = ones(data.num_reads,1); % NEED TO EDIT - check if any scim frames during trial
test_val = data.test_period.data;
cl_dir_state = data.cl_dir_state.data;

% total trial type 19
% trials 200 cm long
% 12 second timeout
% 1 second iti
%
% reset corridor position
%
% 7 different closed loop turn types --- types 1-7
% 30 mm wide corridor both walls on
% turns ±16.7, ±11.3, ±5.7 and 0
% turns during middle 1/2
% test period middle 1/2
% cl_dir_state = 1-7
%
% 12 different open loop turn types - left wall off ---- types 8-19
%  {0,2,4,6,8,10,12,14,16,20,25,30}
%  cl_dir_state = 9
% 8 seconds long - time
% 1/8 still, then 1/8 moves into position, then 1/2 still, then 1/8 out position then 1/8 still
% out of position is 30 mm
%
%
% water time 100ms
% water range 2 - 28 mm
% water distance frac .9
