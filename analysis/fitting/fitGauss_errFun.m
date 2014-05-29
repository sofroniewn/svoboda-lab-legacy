function mse = fitGauss_errFun(prs,x,y)

yhat = fitGauss_modelFun(x,y);
mse = mean((y-yhat).^2);