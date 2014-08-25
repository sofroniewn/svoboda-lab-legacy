%% start matlab pool

%matlabpool(4);

%% PROCESS WHISKER VIDEO - generate parameters
base_dir = '/Users/sofroniewn/Documents/DATA/whisking_data/an237723bvH/'; %/Volumes/wdbp/processed/sofroniewn/an237723bvH/2014_06_17-3/';

overwrite = 0;
p = func_wv_params(base_dir,overwrite);

overwrite_WTLA = 1;
WTLA_name = 'WTLA_A.mat';
wl = func_ff_extract_whiskers(base_dir,WTLA_name,p,overwrite_WTLA);
%wl = func_generate_wv_arrays(base_dir,WTLA_name,p,overwrite_WTLA);

wa = func_cleanup_whisker_traces(wl);
wv = func_extract_whisking_variables(wa);
save(fullfile(base_dir,'whisker_variables_A.mat'),'wv');
%%

%%
figure(43)
clf(43)
hold on
%plot(wa.data{1}.theta_interp(2,:))
plot(wa.data{1}.theta_lp(2,:),'r')
%%
figure(43)
clf(43)
hold on
plot(wa.data{3}.theta_lp(1,:))
plot(wa.data{3}.theta_lp(2,:),'r')


%%
figure(43)
clf(43)
hold on
plot(wv.data{5}.theta(2,:))
plot(wv.data{5}.theta_setpoint(2,:),'r')
plot(wv.data{6}.theta_bp(2,:),'g')
