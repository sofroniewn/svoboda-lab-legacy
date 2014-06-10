



keep_inds = l4_sc{1}.tuning_param.estPrs(:,3) > 1 & l4_sc{1}.tuning_param.r2 > .1;
vals = l4_sc{1}.tuning_param.estPrs(keep_inds,1);

[x y] = hist(vals,[0:.5:25]);

figure(43);
clf(43)
hold on
plot(y,cumsum(x)/sum(x),'m')

keep_inds = l23_sc{1}.tuning_param.estPrs(:,3) > 1 & l23_sc{1}.tuning_param.r2 > .1;
vals = l23_sc{1}.tuning_param.estPrs(keep_inds,1);

[x y] = hist(vals,[0:.5:25]);

plot(y,cumsum(x)/sum(x),'g')

ylim([0 1])

set(gca,'ytick',[0:.2:1])