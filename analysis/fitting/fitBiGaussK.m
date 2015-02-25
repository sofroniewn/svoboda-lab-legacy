function out = fitBiGaussK(x,y,initPrs,length_K)

% fit a gaussian tuning curve to x,y data


%y = y(:);
%x = x(:);

opts = optimset('display','off','Algorithm','interior-point');

initPrs = [initPrs zeros(1,length_K)];
initPrs(end) = 1;
initPrs(end-length_K) = 1;

%l_bound = [[  0     0  -inf -inf] -inf(1,length_K)];
l_bound = [[  0        0  -inf -inf] -inf(1,length_K)];
u_bound = [[max(x(:)) 100  inf  inf]  inf(1,length_K)];

%try
    estPrs = fmincon(@(prs) fitBiGaussK_errFun(prs,x,y),initPrs,[],[],[],[],l_bound,u_bound,[],opts);
    out.estPrs = estPrs;
	out.predic = fitBiGaussK_modelFun(x,estPrs);

	out.sst = nansum((y(:)-mean(y(:))).^2);
	out.sse = nansum((y(:)-out.predic(:)).^2);
	out.r2 = 1 - out.sse/out.sst;
	out.sigma = var(y(:)-out.predic(:));

% catch
%     estPrs = initPrs;
% out.estPrs = estPrs;
% out.predic = fitBiGauss_modelFun(x,estPrs);

% out.sst = nansum((y-mean(y)).^2);
% out.sse = nansum((y-out.predic).^2);
% out.r2 = -.1;
% out.sigma = var(y-out.predic);

% end


out.dI = estPrs(3)/(estPrs(3) + 2*sqrt(out.sse/length(y(:))));

out.keep_val = estPrs(3);
