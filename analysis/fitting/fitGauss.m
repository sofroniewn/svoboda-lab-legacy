function out = fitGauss(x,y,initPrs)

% fit a gaussian tuning curve to x,y data

y = y(:);
x = x(:);

badinds = isnan(y) | isnan(x);

opts = optimset('display','off','Algorithm','interior-point');

if isempty(initPrs)
	initPrs = [mean(x) 1 (prctile(y,90)-prctile(y,10)) prctile(y,10)];
end

estPrs = fmincon(@(prs) fitGauss_errFun(prs,x(~badinds),y(~badinds)),initPrs,[],[],[],[],[0 0 0 -inf],[max(x) 100 inf inf],[],opts);
out.estPrs = estPrs;
out.predic = fitGauss_modelFun(x,estPrs);

out.sst = nansum((y-mean(y)).^2);
out.sse = nansum((y-out.predic).^2);
out.r2 = 1 - out.sse/out.sst;
out.sigma = var(y-out.predic);

out.dI = estPrs(3)/(estPrs(3) + 2*sqrt(out.sse/sum(~badinds)));