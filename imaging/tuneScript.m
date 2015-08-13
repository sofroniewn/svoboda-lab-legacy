load('/Users/sofroniewn/Documents/DATA/results/arrays/corPos.mat');
corPos = corPos(~isnan(sum(corPos,2)),:);
load('/Users/sofroniewn/Documents/DATA/results/arrays/rValueCorPos.mat');
load('/Users/sofroniewn/Documents/DATA/results/arrays/rValueSpeed.mat');

keep_cells = rValueCorPos > .1  & rValueSpeed < .1;

x_fit_vals = linspace(0,30,60);
edges = linspace(0,30,15);
tuneCurve = zeros(size(corPos,1),length(x_fit_vals));

for iSource = 1:size(corPos,1)
[iSource size(corPos,1)]
p = 10^-1;
full_y = corPos(iSource,:);
curve = csaps(edges,full_y,p,x_fit_vals);        
%baseline = nanmean(full_y(edges>22));            
%weight = full_y - baseline;
%[mod_depth_up ind_up] = max(weight);
%[mod_depth_down ind_down] = min(weight);
%initPrs = [baseline mod_depth_up 0 edges(ind_up) 1 edges(ind_down), 1];
%model_fit = fitDoubleSigmoid(edges,full_y,initPrs);
%curve = fitDoubleSigmoid_modelFun(x_fit_vals,model_fit.estPrs);
tuneCurve(iSource,:) = curve;
end

tuneCurve = tuneCurve(keep_cells,:);

[max_val max_loc] = max(tuneCurve,[],2);
[ord ind] = sort(max_loc');
corPosNorm = zscore(tuneCurve,[],2);
tc_sort = corPosNorm(ind,:);
tc_sort(tc_sort>3) = 3;
tc_sort(tc_sort<-2) = -2;

figure(22)
clf(22)
set(gcf,'Position',[394   366   516   440])
imagesc(tc_sort)
%cmap = cbrewer('seq','Greys',64);
cmap = cbrewer('div','RdYlBu',64);
cmap = flipdim(cmap,1);
colormap(cmap);
set(gca,'visible','off')

sum(keep_cells) % is 987