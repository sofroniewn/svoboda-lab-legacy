%% POWER THROUGH OBJECTIVE
% 930nm - zoom 51-0
% power in mW, 635nm correction, percent setting on scanimage

save_path = 'E:\wgnr\Calibration\Scim_calibration\Figures';

percent_setting = [0 5 10:10:100];
power = [0.4 2.5 5 9.8 14.4 18.8 23.2 28 32 36 39 42];

no_pockels_percent_setting = [10 30 50 100];
no_pockels_power = [6.9 17.5 31 53];


figure(80)
clf(80)
set(gcf,'Position',[208         378        1301         720])
hold on
%plot(percent_setting,power,'LineWidth',2,'Color','k')
%plot(no_pockels_percent_setting,no_pockels_power,'LineWidth',2,'Color','k')

h_p(2) = plot(percent_setting,power,'LineWidth',3,'Marker','x','Markeredgecolor','b','LineStyle','none','MarkerSize',14);
h_p(1) = plot(no_pockels_percent_setting,no_pockels_power,'LineWidth',3,'Marker','x','Markeredgecolor','g','LineStyle','none','MarkerSize',14);

xlim([0 100])
ylim([0 60])
set(gca,'FontSize',18)
xlabel('Percent power on Scan Image','FontSize',18)
ylabel('Power (mW)','FontSize',18)
title('Power through objective at 930nm','FontSize',18)
legend_handle = legend(h_p,'Pockels blanking off','Pockels blanking on');
set(legend_handle, 'Location', 'SouthEast')

fig_name = [save_path '\power_through_objective'];
set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPositionMode','auto')
print('-dbmp',fig_name);
%% POWER AT DIFFERENT WAVELENGTHS
% 30% on Scan Image - zoom 51-0 - no pockels blanking
% power in mW, 635nm correction,nm settings of laser

save_path = 'E:\wgnr\Calibration\Scim_calibration\Figures';

laser_wavelenth = [880:10:im_scale];
power = [27.1 24.6 19.6 18.5 19.1 17.5 12.6 10.3 10.5 10.5 9.5 7.6 6.2];

figure(80)
clf(80)
set(gcf,'Position',[208         378        1301         720])
hold on
%plot(percent_setting,power,'LineWidth',2,'Color','k')
%plot(no_pockels_percent_setting,no_pockels_power,'LineWidth',2,'Color','k')

h_p(1) = plot(laser_wavelenth,power,'LineWidth',3,'Marker','x','Markeredgecolor','b','LineStyle','none','MarkerSize',14);

xlim([880 im_scale])
ylim([0 30])
set(gca,'FontSize',18)
xlabel('Wavelength laser (nm)','FontSize',18)
ylabel('Power (mW)','FontSize',18)
title('Power through objective at 30% and pockels blanking off','FontSize',18)

fig_name = [save_path '\power_at_diff_wavelengths'];
set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPositionMode','auto')
print('-dbmp',fig_name);
%% POWER Through path
% 820 nm, 100% on Scan Image - zoom 51-0 - no pockels blanking
% power in mW, 635nm correction
save_path = 'E:\wgnr\Calibration\Scim_calibration\Figures';

out_of_laser_power = 670; 
after_beam_splitter_power = 600; 
after_pockels = 510; 
out_of_objective = 120;

figure(80)
clf(80)
set(gcf,'Position',[208         378        1301         720])
hold on

h = bar([1 2 3 4],[out_of_laser_power after_beam_splitter_power after_pockels out_of_objective]);

xlim([0.5 4.5])
%ylim([0 30])
set(gca,'FontSize',18)
set(gca,'xtick',[1 2 3 4])
set(gca,'xticklabel',{'after laser';'after beamsplitter';'after pockels cell';'after objective'})

%xlabel('Wavelength laser (nm)','FontSize',18)
ylabel('Power (mW)','FontSize',18)
title('Power along beam path at 100nm, pockels 100% and pockels blanking off','FontSize',18)

fig_name = [save_path '\power_along_beam_path'];
set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPositionMode','auto')
print('-dbmp',fig_name);
%% Percent Tranmission along beampath
% 820 nm, 100% on Scan Image - zoom 51-0 - no pockels blanking
% power in mW, 635nm correction
save_path = 'E:\wgnr\Calibration\Scim_calibration\Figures';

out_of_laser_power = 670; 
after_beam_splitter_power = 600; 
after_pockels = 510; 
out_of_objective = 120;

figure(80)
clf(80)
set(gcf,'Position',[208         378        1301         720])
hold on

h = bar([1 2 3],[after_beam_splitter_power after_pockels out_of_objective]/after_beam_splitter_power*100);

xlim([0.5 3.5])
%ylim([0 30])
set(gca,'FontSize',18)
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel',{'after beamsplitter';'after pockels cell';'after objective'})

%xlabel('Wavelength laser (nm)','FontSize',18)
ylabel('Transmission (%)','FontSize',18)
title('Transmission along beam path at im_scalenm, pockels 100% and pockels blanking off','FontSize',18)

fig_name = [save_path '\transmission_along_beam_path'];
set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPositionMode','auto')
print('-dbmp',fig_name);