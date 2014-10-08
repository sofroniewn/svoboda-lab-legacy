function mse = fitDoubleGauss_errFun(prs,x,y)

yhat = fitDoubleGauss_modelFun(x,prs);
mse = mean((y-yhat).^2);