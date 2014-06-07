%%analysis_im_ephys


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Across epoch rasters & PSTHs and tuning curves

type_nam = 'corPos';


trial_range = [0 Inf];
t_window_ms = 200; % 200 ms window

roi_id = 2;

tuning_curve = generate_tuning_curve(roi_id,type_nam,trial_range,t_window_ms)
plot_tuning_curves(tuning_curve)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure(7)
clf(7)
[AX,H1,H2] = plotyy([1:10],rand(10,1),[1:10],rand(10,1))
    set(H1,'Color','k');
    set(H2,'Color','r');
    set(AX(1),'YColor','k');
	set(AX(2),'YColor','r');
	axes(AX(1))
	ylabel('dff')
	axes(AX(2))
	ylabel('pos')
	 %   set(AX(1),'YLabel','dff');
%	set(AX(2),'YLabel','pos');



summary_ca = generate_neuron_summary;


tuning_param = summary_ca{1}.tuning_param;
col_mat = [0 0 1];
fig_id = 4;
tuning_param.title = ['Tuning to ' tuning_param.stim_type_name];
plot_summary_tuning(fig_id,tuning_param,col_mat)
set(gcf,'Position',[720    -1   345   239])


figure(4)
clf(4)
hold on
h_plot = plot(10+rand(10,1),rand(10,1),'.')
set(h_plot,'ButtonDownFcn',@update_tuning_summary_plot)

%
dcm_obj = datacursormode(4);
set(dcm_obj,'Enable','on')
set(4,'WindowButtonDownFcn',@update_tuning_summary_plot)

figure;
plot(summary_ca{1}.tuning_param.dI,summary_ca{1}.tuning_param.r2,'.')

norm = summary_ca{1}.tuning_param.estPrs(:,4);
norm(norm<.1) = .1;
figure;
plot(summary_ca{1}.tuning_param.estPrs(:,3)./norm,summary_ca{1}.tuning_param.r2,'.')


figure(5);
clf(5);
set(gcf,'Position',[720    -1   345   239])
plot(summary_ca{1}.tuning_param.estPrs(:,1),summary_ca{1}.tuning_param.r2,'.')


figure;
plot(summary_ca{1}.tuning_param.dI,summary_ca{1}.tuning_param.r2,'.')

figure;
plot(summary_ca{2}.tuning_param.estPrs(:,1),summary_ca{2}.tuning_param.r2,'.')


figure;
plot(summary_ca{1}.tuning_param.r2,summary_ca{2}.tuning_param.r2,'.')



keep_roi = summary_ca{1}.tuning_param.r2 > .1 | summary_ca{2}.tuning_param.r2 > .1;

figure;
plot(summary_ca{1}.tuning_param.estPrs(keep_roi,1),summary_ca{2}.tuning_param.estPrs(keep_roi,1),'.','Color','r')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stim_type_name = 'corPos';
keep_type_name = 'base';

roi_id = 116;
tuning_curve = generate_tuning_curve(roi_id,stim_type_name,keep_type_name,trial_range);


full_x = [];
full_y = [];
for ij = 1:length(tuning_curve.x_vals)
	full_x = [full_x;repmat(tuning_curve.x_vals(ij),length(tuning_curve.data{ij}),1)];
	full_y = [full_y;tuning_curve.data{ij}'];
end

model_fit = fitGauss(full_x,full_y);
model_fit.curve = fitGauss_modelFun(tuning_curve.x_vals,model_fit.estPrs);

figure;
hold on
plot(tuning_curve.x_vals,tuning_curve.means)
plot(tuning_curve.x_vals,model_fit.curve,'r')




