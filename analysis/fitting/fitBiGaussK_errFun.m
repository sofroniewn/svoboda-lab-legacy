function mse = fitBiGaussK_errFun(prs,x,y)

yhat = fitBiGaussK_modelFun(x,prs);
mse = mean((y(:)-yhat(:)).^2);