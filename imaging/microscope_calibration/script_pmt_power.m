%% PMT power calculation
% fluorescein, 930nm - zoom 51-0

save_path = 'E:\wgnr\Calibration\Scim_calibration\Figures';
data_path_root = 'Y:\imreg\sofroniewn\an189448\Scim_calibration\Power_range\2013_01_25\PMT_power_range_';
%%
PMT_powers = [550 575 600 620:10:720 740 765];
SNR_vals = zeros(1,length(PMT_powers));

for ij = 1:length(PMT_powers)
data_path = [data_path_root num2str(PMT_powers(ij)) '_001.tif'];
im = load_image(data_path);
im_red = 31+im(40:512-40,40:512-40,20:420);
mean_val = mean(im_red(:));
std_val = std(im_red(:));
SNR = mean_val/std_val;
[PMT_powers(ij) SNR]
SNR_vals(ij) = SNR;
end
save([data_path_root 'SNR_vals.mat'],'PMT_powers','SNR_vals')
%%
figure(80)
clf(80)
set(gcf,'Position',[208         378        1301         720])
hold on

h_p(1) = plot(PMT_powers/im_scale,SNR_vals,'LineWidth',3,'Marker','x','Markeredgecolor','b','LineStyle','none','MarkerSize',14);

xlim([.55 .77])
%ylim([0 30])
set(gca,'FontSize',18)
xlabel('PMT power','FontSize',18)
ylabel('SNR','FontSize',18)
title('SNR values for different PMT powers','FontSize',18)

fig_name = [save_path '\PMT_power_SNR'];
set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPositionMode','auto')
print('-dbmp',fig_name);

