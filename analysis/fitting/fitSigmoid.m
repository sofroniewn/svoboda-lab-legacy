function out = fitSigmoid(x,y,initPrs)

% fit a sigmoidal tuning curve to x,y data

y = y(:);
x = x(:);

badinds = isnan(y) | isnan(x);

opts = optimoptions('fminunc','display','off');
if isempty(initPrs)
	initPrs = [prctile(y, 90) 1 0 mean(x)];
end
warning('off','all');
try
estPrs = fminunc(@(prs) fitSigmoid_errFun(prs,x,y),initPrs,opts);
warning('on','all');
out.estPrs = estPrs;

out.predic = fitSigmoid_modelFun(x,estPrs);
out.sst = nansum((y-mean(y)).^2);
out.sse = nansum((y-out.predic).^2);
out.r2 = 1 - out.sse/out.sst;
out.sigma = var(y-out.predic);
catch
    estPrs = initPrs;
  out.estPrs = estPrs;

out.predic = fitSigmoid_modelFun(x,estPrs);
out.sst = nansum((y-mean(y)).^2);
out.sse = nansum((y-out.predic).^2);
out.r2 = -.1;
out.sigma = var(y-out.predic);
end
    
out.dI = estPrs(1)/(estPrs(1) + 2*sqrt(out.sse/sum(~badinds)));
out.keep_val = abs(estPrs(1));
