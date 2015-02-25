function out = fitDoubleSigmoid(x,y,initPrs)

% fit a gaussian tuning curve to x,y data


%y = y(:);
%x = x(:);

opts = optimset('display','off','Algorithm','interior-point');

% baseline = prs(1);
% gain = prs(2);
% weight = prs(3);
% center_1 = prs(4);
% scale_1 = prs(5);
% center_2 = prs(6);
% scale_2 = prs(7);
% prsK_1 = prs(8:9);
% prsK_2 = prs(10:11);


initPrs = [initPrs];
%initPrs = [baseline prsG1 prsG2 prsK1 prsK2 prsKw prsKs];

l_bound = [-30  0  0    0       0     0        0 ];
u_bound = [ 30 100 1 max(x(:))  100 max(x(:)) 100];

%try
    estPrs = fmincon(@(prs) fitDoubleSigmoid_errFun(prs,x,y),initPrs,[],[],[],[],l_bound,u_bound,[],opts);
    out.estPrs = estPrs;
	out.predic = fitDoubleSigmoid_modelFun(x,estPrs);

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
