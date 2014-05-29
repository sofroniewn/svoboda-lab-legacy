function out = fitSigmoid(x,y)

% fit a sigmoidal tuning curve to x,y data

y = y(:);
x = x(:);

badinds = isnan(y) | isnan(x);

opts = optimoptions('fminunc','display','off');
initPrs = [mean(x) 1 prctile(y, 90)];
estPrs = fminunc(@(prs) fitSigmoid_errFun(prs,x,y),initPrs,opts);
out.estPrs = estPrs;
out.predic = fitSigmoid_modelFun(x,estPrs);

out.sst = nansum((y-mean(y)).^2);
out.sse = nansum((y-out.predic).^2);
out.r2 = 1 - out.sse/out.sst;
out.sigma = var(y-out.predic);
