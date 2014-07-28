%% PROCESS VOLTAGE TRACES
clear all
close all
drawnow

base_dir = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0221172/2014_02_21/run_09';
base_dir = '/Users/sofroniewn/Documents/DATA/ephys_ex/artifact/run_06/'

f_name = [base_dir '/ephys/raw/anm_235584_2014x05x22_run_09_trial_40.bin'];
f_name = [base_dir '/ephys/raw/anm_anm_235585_2014x06x04_run_06_trial_1.bin'];

%f_name = '/Volumes/svoboda/users/Sofroniewn/EPHYS_RIG/DATA/anm_231090/2014_04_24/run_01/ephys/raw/anm_anm_231090_2014x04x24_run_01_trial_2.bin';

ch_common_noise = [3, 27:29, 32]; % Channels to be used for common noise subtratction
ch_common_noise = [1:32];
[p d] = func_process_voltage(f_name,ch_common_noise);
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOR PLOTTING
screen_size = get(0,'ScreenSize');
screen_position_left = [1, 1, screen_size(3)/2, screen_size(4)];
screen_position_right = [1+screen_size(3)/2, 1, screen_size(3)/2, screen_size(4)];
screen_position_across = [1, screen_size(4)*2/3, screen_size(3), screen_size(4)/3];

%% ACCESSARY CHANNELS
figure(31)
clf(31)
set(gcf,'Position',screen_position_across)
hold on
plot(d.TimeStamps,10*d.aux_chan(:,1),'k')
plot(d.TimeStamps,d.aux_chan(:,2)/2,'r')
plot(d.TimeStamps,d.aux_chan(:,3),'g')
set(gca,'position',[ 0.1300    0.1100    0.7750    0.8150])
xlim([0 d.TimeStamps(end)*1.1])

%% INDIVIDUAL CHANNEL RAW VOLTAGES
ch_id = 16;
figure(31)
clf(31)
set(gcf,'Position',screen_position_across)
hold on
plot(d.TimeStamps,d.vlt_chan(:,ch_id))
plot(d.TimeStamps,-(d.aux_chan(:,1)-d.aux_chan(1,1))/10000,'k')
text(d.TimeStamps(end)*1.05,0,num2str(ch_id))
set(gca,'position',[ 0.1300    0.1100    0.7750    0.8150])
xlim([0 d.TimeStamps(end)*1.1])

%% ACROSS CHANNEL RAW VOLTAGES
figure(32)
clf(32)
set(gcf,'Position',screen_position_right)
hold on
for ij = 1:p.ch_ids.num_spike
	plot(d.TimeStamps,d.vlt_chan(:,ij)+ij/400)
	text(d.TimeStamps(end)*1.05,ij/400,num2str(ij))
end
plot(d.TimeStamps,.15*d.aux_chan(:,1)/200+(ij+1)/400,'k')
text(d.TimeStamps(end)*1.05,(ij+1)/400,'Laser')
ylim([0 17.5]/200)
xlim([0 d.TimeStamps(end)*1.1])
set(gca,'position',[ 0.05    0.050    0.90    0.90])

%% ACROSS CHANNEL FILTERED DENOISED VOLTAGES
figure(35)
clf(35)
set(gcf,'Position',screen_position_left)
hold on
for ij = 1:p.ch_ids.num_spike
	plot(d.TimeStamps,d.ch_MUA(:,ij)+ij/4000)
	if ismember(ij,p.ch_noise)
	    col = 'r';
	else
	    col = 'k';
	end
text(d.TimeStamps(end)*1.05,ij/4000,num2str(ij),'color',col)
end
plot(d.TimeStamps,.15*d.aux_chan(:,1)/2000+(ij+1)/4000,'k')
text(d.TimeStamps(end)*1.05,.05*(ij+1)/200,'Laser')
ylim([0 1.75]/200)
xlim([0 d.TimeStamps(end)*1.1])
set(gca,'position',[ 0.05    0.050    0.90    0.90])

%% INDIVIDUAL CHANNEL FILETERED / DENOISED
ch_id = 16;
figure(34)
clf(34)
set(gcf,'Position',screen_position_across)
hold on
plot(d.TimeStamps,d.vlt_chan(:,ch_id))
plot(d.TimeStamps,d.ch_MUA(:,ch_id),'g')
%plot(d.TimeStamps,d.commonNoise(:,1),'k')
plot(d.TimeStamps,(d.aux_chan(:,1)-d.aux_chan(1,1))/10000,'k')
text(d.TimeStamps(end)*1.05,0,num2str(ch_id))
set(gca,'position',[ 0.1300    0.1100    0.7750    0.8150])
%ylim([-.3 .3]*10^(-3))
xlim([0 d.TimeStamps(end)*1.1])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        ex_trace = vlt_chan(:,i_ch);
       if ~isempty(ch_ids.artifact)
            ex_trace = interp1(find(~aux_chan(:,ch_ids.blank)),ex_trace(~aux_chan(:,ch_ids.blank)),[1:length(ex_trace)]);
       end
        ch_tmp = timeseries(ex_trace,TimeStamps);  
        ch_tmp = idealfilter(ch_tmp,filter_range,'pass');


aa = d.vlt_chan(:,ch_id);

a_sm = smooth(aa',100,'sgolay',2);
a_dm = aa - a_sm;

figure;
hold on
%plot(a_dm)
plot(aa)
plot(a_sm,'r')

