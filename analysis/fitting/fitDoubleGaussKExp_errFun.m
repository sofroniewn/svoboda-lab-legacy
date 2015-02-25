function mse = fitDoubleGaussKExp_errFun(prs,x,y)

yhat = fitDoubleGaussKExp_modelFun(x,prs);
mse = mean((y(:)-yhat(:)).^2);