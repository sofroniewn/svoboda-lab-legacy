function [ps mean_tuning_curves std_tuning_curves] = get_tuning_curve_SNR(ps,curves,x_fit_vals)

mean_tuning_curves = squeeze(mean(curves,3));
std_tuning_curves = sqrt(squeeze(var(curves,[],3)));

ps.std = ps.SNR;

for ij = 1:size(curves,1);


		  baseline = mean(mean_tuning_curves(ij,50:end));
        [pks loc] = max(mean_tuning_curves(ij,:));
        [pksm locm] = min(mean_tuning_curves(ij,:));
        mean_rate = mean(mean_tuning_curves(ij,:));
        loc = x_fit_vals(loc);
        locm = x_fit_vals(locm);
      
	ps.std(ij) = mean(std_tuning_curves(ij,:));

	% ps.touch_baseline_rate(ij) = baseline;
	% ps.touch_peak_rate(ij) = pks;
	% ps.touch_min_rate(ij) = pksm;
	% ps.touch_mean_rate(ij) = mean_rate;
	% ps.touch_max_loc(ij) = loc;
	% ps.touch_min_loc(ij) = locm;


end

ps.mod_up = ps.touch_peak_rate - ps.touch_baseline_rate;
ps.mod_down = ps.touch_baseline_rate - ps.touch_min_rate;

ps.ste = ps.std./sqrt(ps.num_trials);

% figure
% hold on
% ind = 1;
% plot(mean_curves(ind,:))
% plot(mean_curves(ind,:)+std_curves(ind,:),'r')
% plot(mean_curves(ind,:)-std_curves(ind,:),'r')


% figure
% hold on
% plot(mean(mean_curves,1))
