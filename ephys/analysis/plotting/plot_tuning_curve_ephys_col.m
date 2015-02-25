function plot_tuning_curve_ephys_col(fig_props,tuning_curve)

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on

% c_map = jet(64);
% c_map = c_map/2 + .5;
% colormap(c_map);

if isfield(tuning_curve,'col_mat')
	col_mat = tuning_curve.col_mat;
else
	col_mat = [0 0 1];
end

%tuning_curve.regressor_obj.x_vals = [0:5:30]; %tuning_curve.regressor_obj.x_vals(1:2:end);
%%tuning_curve.means = smooth(tuning_curve.means,3);
%tuning_curve.means = interp1([1:length(tuning_curve.means)],tuning_curve.means,linspace(1,length(tuning_curve.means),7));

max_y = zeros(length(tuning_curve.regressor_obj.x_vals),1);
plot(tuning_curve.regressor_obj.x_range,[0 0],'k')
for ij = 1:length(tuning_curve.regressor_obj.x_vals)
%    plot([tuning_curve.regressor_obj.x_vals(ij),tuning_curve.regressor_obj.x_vals(ij)],[(tuning_curve.means(ij)-tuning_curve.std(ij)/sqrt(length(tuning_curve.data{ij}))), (tuning_curve.means(ij)+tuning_curve.std(ij)/sqrt(length(tuning_curve.data{ij})))],'LineWidth',2,'Color',[0.5 0.5 0.5])
    max_y(ij) = ceil(tuning_curve.means(ij)+tuning_curve.std(ij)/sqrt(length(tuning_curve.data{ij})));
end


max_y = max(max_y(~isnan(max_y)));
if isempty(max_y) || isnan(max_y) || max_y == 0
     max_y = 0.01;
end

%imagesc([tuning_curve.regressor_obj.x_range],[0 max_y],max(tuning_curve.regressor_obj.x_fit_vals) - [tuning_curve.regressor_obj.x_fit_vals])
%imagesc([tuning_curve.regressor_obj.x_range],[0 max_y],max(tuning_curve.regressor_obj.x_fit_vals) - [tuning_curve.regressor_obj.x_fit_vals])

% c_map = zeros(64,3);
% %c_map(:,1) = linspace(253,144,64)/256;
% %c_map(:,2) = linspace(174,185,64)/256;
% %c_map(:,3) = linspace(107,247,64)/256;
% c_map(1:20,1) = linspace(144,(253+144)/2,20)/256;
% c_map(1:20,2) = linspace(185,(174+185)/2,20)/256;
% c_map(1:20,3) = linspace(247,(107+247)/2,20)/256;
% c_map(21:64,1) = linspace((253+144)/2,253,44)/256;
% c_map(21:64,2) = linspace((174+185)/2,174,44)/256;
% c_map(21:64,3) = linspace((107+247)/2,107,44)/256;

% c_map = zeros(64,3);
% c_map(:,1) = linspace(.4,.8,64);
% c_map(:,2) = .8;
% c_map(:,3) = .8;
% c_map = hsv2rgb(c_map);

%c_map = jet(64);
%c_map = c_map/2+.5;

 c_map = zeros(64,3);
 c_map(1:24,1) = linspace(144,(253+144)/2,24)/256;
 c_map(1:24,2) = linspace(185,(174+185)/2,24)/256;
 c_map(1:24,3) = linspace(247,(107+247)/2,24)/256;
 c_map(24:42,1) = linspace((253+144)/2,253,19)/256;
 c_map(24:42,2) = linspace((174+185)/2,174,19)/256;
 c_map(24:42,3) = linspace((107+247)/2,107,19)/256;
 c_map(42:64,1) = linspace(253,239,23)/256;
 c_map(42:64,2) = linspace(174,101,23)/256;
 c_map(42:64,3) = linspace(107,72,23)/256;

%c_map = cbrewer('div','RdYlBu',64);
%c_map = flipdim(c_map,1)/1.5+.33;

% get(hb)
% hbc = get(hb,'Children');
% get(hbc)

for ij = 1:length(tuning_curve.regressor_obj.x_vals)
	ind = 1+round((max(tuning_curve.regressor_obj.x_vals) - tuning_curve.regressor_obj.x_vals(ij))/max(tuning_curve.regressor_obj.x_vals)*size(c_map,1));
	ind(ind>size(c_map,1)) = size(c_map,1);
	col_mat = c_map(ind,:);

hb = bar(tuning_curve.regressor_obj.x_vals(ij),tuning_curve.means(ij));
dd = mean(diff(tuning_curve.regressor_obj.x_vals));
set(hb,'barwidth',dd/4*3) %4.5
set(hb,'FaceColor',col_mat)
set(hb,'EdgeColor',col_mat)
%set(hb,'LineWidth',2)

	%col_mat = [0 0 0];
	%plot(tuning_curve.regressor_obj.x_vals(ij),tuning_curve.means(ij),'Color',col_mat,'Marker','.','MarkerSize',20);
end


if ~isempty(tuning_curve.model_fit)
     plot(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit.curve,'LineWidth',4,'Color','k')
end

%plot(tuning_curve.x_vals,tuning_curve.means,'LineWidth',2)
%plot(tuning_curve.x_vals,(tuning_curve.means+tuning_curve.stds))
%plot(tuning_curve.x_vals,(tuning_curve.means-tuning_curve.stds))
ylim([0 max_y])
xlim([tuning_curve.regressor_obj.x_range]+[-.5 .5])
%xlim([-2.5 32.5])

xlabel(tuning_curve.regressor_obj.x_label)
ylabel(tuning_curve.regressor_obj.y_label)
set(gca,'xtick',tuning_curve.regressor_obj.x_tick)
% title(title_str)

set(gca,'layer','top')