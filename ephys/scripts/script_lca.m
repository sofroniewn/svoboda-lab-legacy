%%
clear all
lca_dir = '/Users/sofroniewn/Documents/DATA/scnn1a_calib/';

lca_files = dir([lca_dir '/NickStimArray*.mat']);
%%
% pulse_name{1} = 'p352x10Hz_1';
% pulse_name{2} = 'p512x10Hz_2';
% pulse_name{3} = 'p640x10Hz_3';
% pulse_name{4} = 'p800x10Hz_4';

clear pulse_name
pulse_name{1} = 'p352';
pulse_name{2} = 'p512';
pulse_name{3} = 'p640';
pulse_name{4} = 'p800';

pulse_power = [0.5;1;1.5;2.0];


%%
include_cells = [1:4 6:7];

evk_spikes = cell(length(include_cells),1);
laser_power = cell(length(include_cells),1);
baseline_spikes = cell(length(include_cells),1);
latency_spikes = cell(length(include_cells),1);
normed_spikes = cell(length(include_cells),1);

for ih = 1:length(include_cells)

lca_data = [lca_dir lca_files(include_cells(ih)).name];

load(lca_data)

evk_spikes{ih} = zeros(numel(laserStim.pulseName),1);
baseline_spikes{ih} = zeros(numel(laserStim.pulseName),1);
latency_spikes{ih} = NaN(numel(laserStim.pulseName),1);
laser_power{ih} = NaN(numel(laserStim.pulseName),1);

for ij = 1:numel(laserStim.pulseName)
    evk_spikes{ih}(ij) = sum(laserStim.stimSpikes{ij})/length(laserStim.stimSpikes{ij});
    baseline_spikes{ih}(ij) = sum(laserStim.baselineSpikes{ij})/length(laserStim.baselineSpikes{ij});
    latencies = laserStim.latency1stSpike{ij};
    latencies(latencies==0) = NaN;
    latency_spikes{ih}(ij) = nanmean(latencies);
    
    for ik = 1:numel(pulse_name)
        if strcmp(pulse_name{ik},laserStim.pulseName{ij}(1:4)) == 1 && strcmp('NickStim',laserStim.cycleName{ij}) == 1
           laser_power{ih}(ij) = pulse_power(ik)*laserStim.laserPower(ij)/100;
        else
        end
    end
end

normed_spikes{ih} = evk_spikes{ih} - baseline_spikes{ih};

end


%%
figure(44)
clf(44)
hold on
for ij = 1:length(include_cells)
%scatter(laser_power{ij},evk_spikes{ij} - baseline_spikes{ij})
scatter(laser_power{ij},latency_spikes{ij})

%scatter(laser_power{ij},evk_spikes{ij})
%scatter(laser_power{ij},baseline_spikes{ij})
end
xlim([0 2])

%%
mean_lp = zeros(4,length(include_cells));
std_lp = zeros(4,length(include_cells));
num_lp = zeros(4,length(include_cells));
mean_lat = zeros(4,length(include_cells));
std_lat = zeros(4,length(include_cells));
num_lat = zeros(4,length(include_cells));

for ij=1:4
    for ik = 1:length(include_cells)
        mean_lat(ij,ik) = nanmean(latency_spikes{ik}(laser_power{ik}==pulse_power(ij)/2));
        std_lat(ij,ik) = nanstd(latency_spikes{ik}(laser_power{ik}==pulse_power(ij)/2));
        num_lat(ij,ik) = sum(~isnan(latency_spikes{ik}(laser_power{ik}==pulse_power(ij)/2)));

        mean_lp(ij,ik) = mean(normed_spikes{ik}(laser_power{ik}==pulse_power(ij)/2));
        std_lp(ij,ik) = std(normed_spikes{ik}(laser_power{ik}==pulse_power(ij)/2));
        num_lp(ij,ik) = sum(laser_power{ik}==pulse_power(ij)/2);
    end
end

ste_lp = std_lp./sqrt(num_lp);
ste_lat = std_lat./sqrt(num_lat);
%%
figure(45)
clf(45)
hold on
for ij = 1:length(include_cells)
plot(pulse_power/2,mean_lp(:,ij),'Color',[.4 .4 .4],'LineWidth',3)

    for ik = 1:4
      %  h_plot(ik) = bar(ik,traj{ik}.mean,.5,'FaceColor',traj{ik}.col_mat,'EdgeColor',traj{ik}.col_mat);
      %  num_trials(ik) = traj{ik}.num;
        plot([pulse_power(ik)/2 pulse_power(ik)/2],[mean_lp(ik,ij)-ste_lp(ik,ij),mean_lp(ik,ij)+ste_lp(ik,ij)],'Color','k','LineWidth',3);
        plot(pulse_power(ik)/2 + [-.01 .01],[mean_lp(ik,ij)-ste_lp(ik,ij),mean_lp(ik,ij)-ste_lp(ik,ij)],'Color','k','LineWidth',3);
        plot(pulse_power(ik)/2 +[-.01 .01],[mean_lp(ik,ij)+ste_lp(ik,ij),mean_lp(ik,ij)+ste_lp(ik,ij)],'Color','k','LineWidth',3);
    end


end
xlim([0.2 1.05])
ylim([0 2.5])
xlabel('Power (mW)','FontSize',18,'FontWeight','Bold')
ylabel('# Stimulus evoked spikes','FontSize',18,'FontWeight','Bold')
 
set(gca,'Xtick',[0.25;.5;.75;1])

set(gca,'FontSize',18,'FontWeight','Bold')
  
fig_fname = [lca_dir 'cell_summary'];

set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'PaperOrientation', 'portrait');
print('-depsc', fig_fname);
%%
figure(48)
clf(48)
hold on
for ij = 1:length(include_cells)
plot(pulse_power/2,mean_lat(:,ij),'Color',[.4 .4 .4],'LineWidth',3)

    for ik = 1:4
      %  h_plot(ik) = bar(ik,traj{ik}.mean,.5,'FaceColor',traj{ik}.col_mat,'EdgeColor',traj{ik}.col_mat);
      %  num_trials(ik) = traj{ik}.num;
        plot([pulse_power(ik)/2 pulse_power(ik)/2],[mean_lat(ik,ij)-ste_lat(ik,ij),mean_lat(ik,ij)+ste_lat(ik,ij)],'Color','k','LineWidth',3);
        plot(pulse_power(ik)/2 + [-.01 .01],[mean_lat(ik,ij)-ste_lat(ik,ij),mean_lat(ik,ij)-ste_lat(ik,ij)],'Color','k','LineWidth',3);
        plot(pulse_power(ik)/2 +[-.01 .01],[mean_lat(ik,ij)+ste_lat(ik,ij),mean_lat(ik,ij)+ste_lat(ik,ij)],'Color','k','LineWidth',3);
    end


end
xlim([0.2 1.05])
%ylim([0 2.5])
xlabel('Power (mW)','FontSize',18,'FontWeight','Bold')
ylabel('Latency to first spike (ms)','FontSize',18,'FontWeight','Bold')
 
set(gca,'Xtick',[0.25;.5;.75;1])

set(gca,'FontSize',18,'FontWeight','Bold')
  
fig_fname = [lca_dir 'cell_latency_summary'];

set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'PaperOrientation', 'portrait');
print('-depsc', fig_fname);



%%
figure(146)
clf(146)
set(gcf,'Color',[1 1 1])
fig_pos = [106   454   265   201];
set(gcf, 'Position',fig_pos)
hold on
mm_lp = mean(mean_lp,2);
mste_lp = std(mean_lp,[],2)/sqrt(length(include_cells));

    for ik = 1:4
      bar(pulse_power(ik),10*mm_lp(ik),.24,'FaceColor',[.4 .4 .4],'EdgeColor',[.4 .4 .4]);
    
        plot([pulse_power(ik) pulse_power(ik)],10*[mm_lp(ik)-mste_lp(ik),mm_lp(ik)+mste_lp(ik)],'Color','k','LineWidth',3);
        plot(pulse_power(ik) + 2*[-.01 .01],10*[mm_lp(ik)+mste_lp(ik),mm_lp(ik)+mste_lp(ik)],'Color','k','LineWidth',3);
        plot(pulse_power(ik) +2*[-.01 .01],10*[mm_lp(ik)-mste_lp(ik),mm_lp(ik)-mste_lp(ik)],'Color','k','LineWidth',3);
    end

xlim([0 2.25])
ylim(10*[0 1.5])

%xlabel('Power (mW)','FontSize',20,'FontWeight','Bold')
%ylabel('# Stimulus evoked spikes','FontSize',20,'FontWeight','Bold')

set(gca,'LineWidth',2)
set(gca,'FontSize',20,'FontWeight','Bold')
 set(gca,'Xtick',2*[0;0.25;.5;.75;1])
 set(gca,'layer','top')
set(gca,'LineWidth',2)
set(gca,'box','off')
set(gca,'TickDir','out')




fig_fname = [lca_dir 'pop_summary_NEW'];

set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'PaperOrientation', 'portrait');
print('-depsc', fig_fname);

fig_folder = ['./DATA/COMP_THESIS/FIGS/Chpt_4/'];
fig_fname = [fig_folder '/ACITVATION_calib'];
if exist(fig_folder,'dir') ~= 7
    mkdir(fig_folder);
else
end
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'PaperOrientation', 'portrait');
print('-depsc', fig_fname);
%%

pp=spapi(4,pulse_power'/2,mm_lp) 
%%
range = [.1:.1:1];
v = fnval(pp,range) 
figure(33)
clf(33)
hold on
plot(range,v)
plot(pulse_power'/2,mm_lp,'r')


%%
samp = [0.4; 0.8];

evk_prop = fnval(pp,samp) ;

[r,m,b] = regression(pulse_power(2:4)'/2,mm_lp(2:4)');


evk_prop = [evk_prop;m*1.2+b];

evk_rate = evk_prop*10



