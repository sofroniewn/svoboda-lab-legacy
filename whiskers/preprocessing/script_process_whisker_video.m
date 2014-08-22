%% start matlab pool

%matlabpool(4);

%% PROCESS WHISKER VIDEO - generate parameters
base_dir = cell(1,1);
% base_dir{1} = 'Y:\processed\sofroniewn\an220126bvG\2014_01_14-1\';
% base_dir{2} = 'Y:\processed\sofroniewn\an220126bvG\2014_01_14-2\';
% base_dir{3} = 'Y:\processed\sofroniewn\an220126bvG\2014_01_15-1\';
% base_dir{4} = 'Y:\processed\sofroniewn\an220125bvG\2014_01_14-1\';
% base_dir{5} = 'Y:\processed\sofroniewn\an220125bvG\2014_01_15-2\';
% base_dir{6} = 'Y:\processed\sofroniewn\an217490bvG\2014_01_14-1\';
% base_dir{7} = 'Y:\processed\sofroniewn\an217490bvG\2014_01_15-1\';
% base_dir{8} = 'Y:\processed\sofroniewn\an217490bvG\2014_01_15-2\';
% base_dir{9} = 'Y:\processed\sofroniewn\an217489bvG\2014_01_14-2\';
% base_dir{10} = 'Y:\processed\sofroniewn\an217489bvG\2014_01_15-1\';

base_dir{1} = '/Volumes/wdbp/processed/sofroniewn/an237723bvH/2014_06_17-3/';

ik = 1;
%for ik = 1:1
%clear all
%close all
%drawnow
base_dir{ik}
overwrite = 0;
nLeft = 1;
nRight = 1;

[wv_params] = func_wv_params(base_dir{ik},nLeft,nRight,overwrite);

%close all

% Extract whisker traces with Dan's packages
wv_params.face_parameter = {'top';'bottom'}; %;'bottom';'bottom';'bottom';'bottom'}; %{'bottom','top'};
%wv_params.poly_roi_lims = [25 80] + 25;
wv_params.file_list = [];
wv_params.overwrite_WTLA = 0;
wv_params.WTLA_name = 'WTLA_A.mat';
wl = func_generate_wv_arrays(wv_params);
%
wa = func_cleanup_whisker_traces(wl);
%
wv = func_extract_whisking_variables(wa);

save(fullfile(base_dir{ik},'whisker_variables_A.mat'),'wv');
%end
%%
figure(43)
clf(43)
hold on
plot(wa.data{2}.theta_interp(1,:))
plot(wa.data{2}.theta_lp(1,:),'r')
%%
figure(43)
clf(43)
hold on
plot(wa.data{23}.theta_lp(1,:))
plot(wa.data{23}.theta_lp(2,:),'r')


%%
figure(43)
clf(43)
hold on
plot(wv.data{2}.theta(1,:))
plot(wv.data{2}.theta_setpoint(1,:),'r')
plot(wv.data{2}.theta_bp(1,:),'g')






%% Quality control whiskers data
%clear all
% anm_name = '174754';
% current_date = '121216';
% data_drive_name = 'F';
% accept_all = 1;
% 
% anm_name = '171981';
% current_date = '130423';
% data_drive_name = 'P';
% run_num = '1';
% accept_all = 1;
% 
% qualtiy_control_whisker_timeseries(data_drive_name,anm_name,current_date,run_num,accept_all);
%% Quality control whiskers data
clear all
% anm_name = '174754';
% current_date = '121216';
% data_drive_name = 'F';
anm_name = '171981';
current_date = '130423';
data_drive_name = 'P';
run_num = '1';

over_write = 0;
plot_on = 1;

compute_whisker_variables(data_drive_name,anm_name,current_date,over_write,plot_on);

%% Extract whisker timeseries to trial data
clear all
data_drive_name = 'E';
anm_name = '189448';
current_date = '130124';

anm_name = '172934';
current_date = '121203';
data_drive_name = 'F';

anm_name = '174754';
current_date = '121216';
data_drive_name = 'F';

extract_whisker_timeseries(data_drive_name,anm_name,current_date);


%% Plot traced example frame
%clear all
anm_name = '174752';
current_date = '130517';
data_drive_name = 'P';
run_num = '2';

file_num = 2;
frame_num = 1742;

plot_wv_traced_example(data_drive_name,anm_name,current_date,run_num,file_num,frame_num,1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%
%load('P:\wgnr\anm_data\an174752\2013_05_17\video\run_1\vid_wv_1\vid_WTLA.mat')
Whisker.view_WhiskerTrialLiteArray(wl,0)
