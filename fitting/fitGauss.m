function out = fitGauss(x,y)

% fit a gaussian tuning curve to x,y data

y = y(:);
x = x(:);

badinds = isnan(y) | isnan(x);

opts = optimset('display','off','Algorithm','interior-point');
initPrs = [mean(x) 1 prctile(y,90)];
estPrs = fmincon(@(prs) fitGauss_errFun(prs,x(~badinds),y(~badinds)),initPrs,[],[],[],[],[min(x) 0 0],[max(x) 100 inf],[],opts);
out.estPrs = estPrs;
out.predic = fitGauss_modelFun(x,estPrs);

out.sst = nansum((y-mean(y)).^2);
out.sse = nansum((y-out.predic).^2);
out.r2 = 1 - out.sse/out.sst;
out.sigma = var(y-out.predic);