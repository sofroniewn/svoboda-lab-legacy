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
plot(wv.data{5}.theta_bp(2,:),'g')


%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

whisker_fname = fullfile(base_dir,'whiskers','whisker_variables.mat');
load(whisker_fname,'wv','p');


wv_lengths = zeros(numel(wv.data)-1,1);
for ij = 1:numel(wv.data)-1
	wv_lengths(ij) = size(wv.data{ij}.theta_raw,2);
end

switch anm_id
	case '235885'
		reject_trials_wv = [56,57,67,87,101,148,166,312,335,354:417];
		reject_trials_bv = [1:16,50:70,80:90,95:105,142:150,161:168, 303:315, 325:335, 344:403];
	case '245918'
		reject_trials_wv = [1];
		reject_trials_bv = [];
	case '237723'
		reject_trials_wv = [];
		reject_trials_bv = [];
	otherwise
		error('Unrecognized animal id')
end

wv_lengths_mod = wv_lengths;
wv_lengths_mod(reject_trials_wv) = [];
wv_all = 1:length(wv_lengths);
wv_all(reject_trials_wv) = [];

keep = [1:length(session.trial_info.length)];
keep(reject_trials_bv) = [];
wv_all = wv_all(keep);

keep_behaviour = keep;
keep_whiskers = wv_all;

session = add_whiskers_to_session(session,wv,keep_behaviour,keep_whiskers);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


figure(54)
clf(54)
hold on
plot(keep,wv_lengths_mod(keep),'g','Linewidth',2)
%plot(wv_lengths,'r','Linewidth',2)
plot(keep,session.trial_info.length(keep)-500,'b')

wv_lengths_mod(keep) - session.trial_info.length(keep)+500





trial_keep_num = 50;

trial_num = keep(trial_keep_num);
wv_trial_num = wv_all(trial_keep_num)



all_whisker = [];
all_speed = [];

for ij = 1:length(keep)
	trial_num = keep(ij);
	wv_trial_num = wv_all(ij);
	min_length = min(length(wv.data{wv_trial_num}.theta(2,:)),length(session.data{trial_num}.processed_matrix(5,501:end)));
	all_whisker = cat(2,all_whisker,wv.data{wv_trial_num}.theta_amp(2,1:min_length));
	all_speed = cat(2,all_speed,session.data{trial_num}.processed_matrix(5,501:500+min_length));
end

figure(88)
clf(88)
hold on;
plot(zscore(wv.data{wv_trial_num}.theta(2,:))+1)
plot(zscore(session.data{trial_num}.processed_matrix(5,501:end)),'r')









YY = all_whisker;
XX = all_speed;

XX = XX(:);
YY = YY(:);


edges_2d{1} = [0:1:60];
edges_2d{2} = [0:.5:30];
 % edges{2} = [0:1:20];
 %    edges{2} = [0:1:30];

    % %    
  
dat = [XX(:) YY(:)]; 
[n_vals,C]  = hist3(dat,'edges',edges_2d); % Extract histogram data;

 YY_fn_XX = NaN(1,length(C{1}));
 YY_fn_XX_std_1 = NaN(1,length(C{1}));
 YY_fn_XX_std_2 = NaN(1,length(C{1}));
 for ij = 1:length(C{1})-1
     if isempty(dat(dat(:,1)>=edges_2d{1}(ij) & dat(:,1)<edges_2d{1}(ij+1),2))~=1
     Y_q = quantile(dat(dat(:,1)>=edges_2d{1}(ij) & dat(:,1)<edges_2d{1}(ij+1),2),[.25 .5 .75]);
     YY_fn_XX(ij) = Y_q(2);
     YY_fn_XX_std_1(ij) = Y_q(1);
     YY_fn_XX_std_2(ij) = Y_q(3);
     else
     end
  end
  
num_pts  = sum(n_vals');
YY_fn_XX(num_pts<100) = NaN;
YY_fn_XX_std_1(num_pts<100) = NaN;
YY_fn_XX_std_2(num_pts<100) = NaN;
n_vals(num_pts<100,:) = NaN;


figure(88)
clf(88)
hold on;
%plot(all_speed,all_whisker,'.r')
plot(C{1},YY_fn_XX,'k','Linewidth',4)
plot(C{1},YY_fn_XX_std_1,'k','Linewidth',2)
plot(C{1},YY_fn_XX_std_2,'k','Linewidth',2)
xlabel('Running speed (cm/s)')
ylabel('Whisking amplitude (deg)')
xlim([0 60])



whisking_amp_mean = zeros(numel(session.data),1);
for ij = 1:length(whisking_amp_mean)
	whisking_amp_mean(ij) = nanmean(session.data{ij}.processed_matrix(10,:));
end








