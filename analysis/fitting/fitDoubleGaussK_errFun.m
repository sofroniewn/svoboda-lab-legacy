function mse = fitDoubleGaussK_errFun(prs,x,y)

yhat = fitDoubleGaussK_modelFun(x,prs);
mse = mean((y(:)-yhat(:)).^2);