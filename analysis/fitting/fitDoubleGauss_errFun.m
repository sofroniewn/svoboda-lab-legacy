function mse = fitDoubleGauss_errFun(prs,x,y)

yhat = fitDoubleGauss_modelFun(x,prs);
mse = mean((y-yhat).^2) + .1*(abs(prs(3)) + abs(prs(7)));