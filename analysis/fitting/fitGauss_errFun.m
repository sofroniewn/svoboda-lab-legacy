function mse = fitGauss_errFun(prs,x,y)

yhat = fitGauss_modelFun(x,prs);
mse = mean((y-yhat).^2);