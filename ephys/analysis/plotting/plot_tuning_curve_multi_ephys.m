function plot_tuning_curve_multi_ephys(fig_props,tuning_curve)

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla
hold on

col_mat = zeros(tuning_curve.regressor_obj.num_groups_y,3);
col_mat(:,1) = linspace(1,0,tuning_curve.regressor_obj.num_groups_y);
%col_mat(:,2) = [linspace(0,1,floor(tuning_curve.regressor_obj.num_groups_y/2)) linspace(1,0,ceil(tuning_curve.regressor_obj.num_groups_y/2))];
col_mat(:,3) = linspace(0,1,tuning_curve.regressor_obj.num_groups_y);

if tuning_curve.regressor_obj.num_groups_y == 3
	col_mat(2,2) = 1;
end


hb = bar(tuning_curve.regressor_obj.x_vals,tuning_curve.means');
for ij = 1:tuning_curve.regressor_obj.num_groups_y
	set(hb(ij),'FaceColor',col_mat(ij,:))
	set(hb(ij),'EdgeColor',col_mat(ij,:))
end


max_y = zeros(tuning_curve.regressor_obj.num_groups_y,length(tuning_curve.regressor_obj.x_vals));
plot(tuning_curve.regressor_obj.x_range,[0 0],'k')
for ik = 1:tuning_curve.regressor_obj.num_groups_y
	x_dat = get(get(hb(ik),'Children'),'XData');
	x_dat = mean(x_dat([1 3],:),1);
	    for ij = 1:length(tuning_curve.regressor_obj.x_vals)
		plot([x_dat(ij),x_dat(ij)],[(tuning_curve.means(ik,ij)-tuning_curve.std(ik,ij)/sqrt(length(tuning_curve.data{ik,ij}))), (tuning_curve.means(ik,ij)+tuning_curve.std(ik,ij)/sqrt(length(tuning_curve.data{ik,ij})))],'LineWidth',2,'Color',[0.5 0.5 0.5])
	    max_y(ik,ij) = ceil(tuning_curve.means(ik,ij)+tuning_curve.std(ik,ij)/sqrt(length(tuning_curve.data{ik,ij})));
	end
end

if ~isempty(tuning_curve.model_fit)
	for ik = 1:tuning_curve.regressor_obj.num_groups_y
		col_mat_sm = col_mat(ik,:);
		col_mat_sm = col_mat_sm/2;
      plot(tuning_curve.regressor_obj.x_fit_vals,tuning_curve.model_fit{ik}.curve,'LineWidth',4,'Color',col_mat_sm)
	 end
end

max_y = max_y(:);
max_y = max(max_y(~isnan(max_y)));
if isempty(max_y) || isnan(max_y) || max_y == 0
     max_y = 0.01;
end

  ylim([0 max_y])
  xlim([tuning_curve.regressor_obj.x_range])
  xlabel(tuning_curve.regressor_obj.x_label)
  ylabel(tuning_curve.regressor_obj.z_label)
  text(0.02,.97,tuning_curve.regressor_obj.y_label,'Units','Normalized')
  set(gca,'xtick',tuning_curve.regressor_obj.x_tick)
% % title(title_str)

set(gca,'layer','top')
