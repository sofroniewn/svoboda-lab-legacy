function mse = fitGS2D_errFun(prs,x,y,z)

zhat = fitGS2D_modelFun(x,y,prs);
mse = mean((z-zhat).^2);