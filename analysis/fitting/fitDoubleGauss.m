function out = fitDoubleGauss(x,y,initPrs)

% fit sum of two gaussians (one pos, one negative) tuning curve to x,y data

y = y(:);
x = x(:);

badinds = isnan(y) | isnan(x);

opts = optimset('display','off','Algorithm','interior-point');

if isempty(initPrs)
	initPrs = [mean(x) 1 (prctile(y,90)-prctile(y,10)) mean(x) 1 (prctile(y,90)-prctile(y,10))];
end

try

    estPrs = fmincon(@(prs) fitDoubleGauss_errFun(prs,x(~badinds),y(~badinds)),initPrs,[],[],[],[],[0 0 0 0 0 0 -inf],[max(x) 100 inf max(x) 100 inf inf],[],opts);
    out.estPrs = estPrs;
out.predic = fitDoubleGauss_modelFun(x,estPrs);

out.sst = nansum((y-mean(y)).^2);
out.sse = nansum((y-out.predic).^2);
out.r2 = 1 - out.sse/out.sst;
out.sigma = var(y-out.predic);

catch
    estPrs = initPrs;
out.estPrs = estPrs;
out.predic = fitDoubleGauss_modelFun(x,estPrs);

out.sst = nansum((y-mean(y)).^2);
out.sse = nansum((y-out.predic).^2);
out.r2 = -.1;
out.sigma = var(y-out.predic);

end


out.keep_val = max(estPrs(3),estPrs(4));

out.dI = out.keep_val/(out.keep_val + 2*sqrt(out.sse/sum(~badinds)));

