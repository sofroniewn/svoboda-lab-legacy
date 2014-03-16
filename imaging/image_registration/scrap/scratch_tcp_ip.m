% e.g., Send/receive strings:
%    server: jTcpObj = jtcp('accept',21566,'timeout',2000);
%    client: jTcpObj = jtcp('request','127.0.0.1',21566,'timeout',2000);
%    client: jtcp('write',jTcpObj,'Hello, server');
%    server: mssg = jtcp('read',jTcpObj); disp(mssg)
%    server: jtcp('write',jTcpObj,'Hello, client');
%    client: mssg = jtcp('read',jTcpObj); disp(mssg)
%    server: jtcp('close',jTcpObj);
%    client: jtcp('close',jTcpObj);
%
% e.g., Send/receive matrix:
%    server: jTcpObj = jtcp('accept',21566,'timeout',2000);
%    client: jTcpObj = jtcp('request','127.0.0.1',21566,'timeout',2000);
%    client: data = eye(5); jtcp('write',jTcpObj,data);
%    server: mssg = jtcp('read',jTcpObj); disp(mssg)
%    server: jtcp('close',jTcpObj);
%    client: jtcp('close',jTcpObj);
%
% e.g., Send/receive cell array. Cell arrays are converted to class
%       java.lang.Object for transmission; convert back to Matlab cell 
%       array with cell():
%    server: jTcpObj = jtcp('accept',21566,'timeout',2000);
%    client: jTcpObj = jtcp('request','127.0.0.1',21566,'timeout',2000);
%    server: data = {'Hello', [1 2 3], pi}; jtcp('write',jTcpObj,data);
%    client: mssg = jtcp('read',jTcpObj); disp(cell(mssg))
%    server: jtcp('close',jTcpObj);
%    client: jtcp('close',jTcpObj);
%
% e.g., Send/receive uint8 array. uint8 arrays are converted to bytes for
%       transmission and back to int8 when read back into Matlab, so 
%       information is lost. Avoid this by upcasting to double and back 
%       down to uint8 on the other end.
%    server: jTcpObj = jtcp('accept',21566,'timeout',2000);
%    client: jTcpObj = jtcp('request','127.0.0.1',21566,'timeout',2000);
%    server: data = double(imread('ngc6543a.jpg')); jtcp('write',jTcpObj,data);
%    client: mssg = jtcp('read',jTcpObj); image(uint8(mssg))
%    server: jtcp('close',jTcpObj);
%    client: jtcp('close',jTcpObj);
%
% e.g., Send/receive int8 bytes one by one with serialization off. 
%    server: jTcpObj = jtcp('accept',21566,'timeout',2000,'serialize',false);
%    client: jTcpObj = jtcp('request','127.0.0.1',21566,'timeout',2000,'serialize',false);
%    server: jtcp('write',jTcpObj,int8('Hello client'));
%    client: mssg = jtcp('read',jTcpObj); char(mssg)
%    server: jtcp('write',jTcpObj,int8('Hello client, read this with helper class'));
%    client: mssg = jtcp('read',jTcpObj,'helperClassPath','/home/bartlett/matlab/mfiles/network/'); char(mssg)
%    server: jtcp('close',jTcpObj);
%    client: jtcp('close',jTcpObj);

save('/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/test_session.mat','session');

jTcpObj = jtcp('request','127.0.0.1',21566,'timeout',10000);
jTcpObj = jtcp('accept',21566,'timeout',2000);

jtcp('write',jTcpObj,{'Prepare run'});

file_id_name = 'test_';
jtcp('write',jTcpObj,{'file_id_name',file_id_name});


load('/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/behaviour/anm_0227254_2013x12x12_run_02_rig_config.mat')
mssg = tcp_struct_parser(rig_config,'rig_config',1);
jtcp('write',jTcpObj,mssg);

load('/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/behaviour/anm_0227254_2013x12x12_run_02_trial_config.mat')
mssg = tcp_struct_parser(trial_config,'trial_config',1);
jtcp('write',jTcpObj,mssg);


trial_mat_names = {'x_vel','y_vel','cor_pos','cor_width','laser_power','x_mirror_pos','y_mirror_pos', ...
    'trial_num','inter_trial_trig','lick_state','water_earned','running_ind', ...
    'masking_flash_on','scim_state','external_water','scim_logging','test_val'};
jtcp('write',jTcpObj,{'trial_mat_names',trial_mat_names});


load('/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/behaviour/anm_0227254_2013x12x12_run_02_ps_sites.mat')
mssg = tcp_struct_parser(ps_sites,'ps_sites',1);
jtcp('write',jTcpObj,mssg);           


jtcp('write',jTcpObj,{'Start run'});


%load('/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/behaviour/anm_0227254_2013x12x12_run_02_trial_0001.mat');
trial_num = 0;
test_session = load('/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/test_session.mat');
trial_num = trial_num + 1;
test_data = test_session.session.data{trial_num}.trial_matrix;
jtcp('write',jTcpObj,{'trial_data', trial_num, test_data});



%%
jTcpObj = jtcp('request','10.102.22.49',21566,'timeout',2000);



