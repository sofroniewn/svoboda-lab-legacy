function out = fitGS2D(x,y,z,initPrs)

% fit a gaussian tuning curve to x,y,z data

y = y(:);
x = x(:);
z = z(:);

badinds = isnan(y) | isnan(x);

opts = optimoptions('fminunc','display','off');
if isempty(initPrs)
	initPrs = [mean(x) 1 mean(y) 1 (prctile(z,90)-prctile(z,10)) prctile(z,10)];
end
warning('off','all');
estPrs = fminunc(@(prs) fitGS2D_errFun(prs,x,y,z),initPrs,opts);
warning('on','all');

out.estPrs = estPrs;
out.predic = fitGS2D_modelFun(x,y,estPrs);

out.sst = nansum((z-mean(z)).^2);
out.sse = nansum((z-out.predic).^2);
out.r2 = 1 - out.sse/out.sst;
out.sigma = var(z-out.predic);


out.dI = estPrs(5)/(estPrs(5) + 2*sqrt(out.sse/sum(~badinds)));
out.keep_val = estPrs(5);
