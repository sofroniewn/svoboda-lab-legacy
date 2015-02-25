function out = fitBiGauss(x,y,initPrs)

% fit a gaussian tuning curve to x,y data

y = y(:);
x = x(:);

badinds = isnan(y) | isnan(x);

opts = optimset('display','off','Algorithm','interior-point');

if isempty(initPrs)
	initPrs = [mean(x) 1 (prctile(y,90)-prctile(y,10)) 0];
end

%try
    estPrs = fmincon(@(prs) fitBiGauss_errFun(prs,x(~badinds),y(~badinds)),initPrs,[],[],[],[],[0 0 -inf -inf],[max(x) 100 inf inf],[],opts);
    out.estPrs = estPrs;
	out.predic = fitBiGauss_modelFun(x,estPrs);

	out.sst = nansum((y-mean(y)).^2);
	out.sse = nansum((y-out.predic).^2);
	out.r2 = 1 - out.sse/out.sst;
	out.sigma = var(y-out.predic);

% catch
%     estPrs = initPrs;
% out.estPrs = estPrs;
% out.predic = fitBiGauss_modelFun(x,estPrs);

% out.sst = nansum((y-mean(y)).^2);
% out.sse = nansum((y-out.predic).^2);
% out.r2 = -.1;
% out.sigma = var(y-out.predic);

% end


out.dI = estPrs(3)/(estPrs(3) + 2*sqrt(out.sse/sum(~badinds)));

out.keep_val = estPrs(3);
