function mse = fitBiGauss_errFun(prs,x,y)

yhat = fitBiGauss_modelFun(x,prs);
mse = mean((y-yhat).^2) + .1*abs(prs(3));