function out = fitGaussKnp(x,y,initPrs)

% fit a gaussian tuning curve to x,y data


%y = y(:);
%x = x(:);

opts = optimset('display','off','Algorithm','interior-point');

% baseline = prs(1);
% prsG1 = prs(2:4);
% prsG2 = prs(5:7);
% length_K = (length(prs)-7)/2;
% prsK1 = prs(8:8+length_K);
% prsK2 = prs(9+length_K:end);

initPrs = [initPrs];
%initPrs = [baseline prsG(3) gain prsK(6)];

l_bound = [-inf      -10        0    0  -inf   -ones(1,3)];
u_bound = [ inf   max(x(:))+10 100  inf   inf   ones(1,3)];

%try
    estPrs = fmincon(@(prs) fitGaussV_errFun(prs,x,y),initPrs,[],[],[],[],l_bound,u_bound,[],opts);
    out.estPrs = estPrs;
	out.predic = fitGaussV_modelFun(x,estPrs);

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
