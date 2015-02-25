function predic = fitDoubleSigmoidKnp_modelFun(xvals,prs)

baseline = prs(1);
gain = prs(2);
weight = prs(3);
center_1 = prs(4);
scale_1 = prs(5);
center_2 = prs(6);
scale_2 = prs(7);
prsK_1 = [1 prs(8)];
prsK_2 = [1 prs(9)];

num_pad = 60;
xvals = [repmat(xvals(:,1),1,num_pad),xvals,repmat(xvals(:,end),1,num_pad)];
sz = size(xvals);

predic = 1./ (1 + exp(((xvals(:)-center_1)/scale_1)));
predic_1 = reshape(predic,sz);

predic = 1./ (1 + exp(((xvals(:)-center_2)/scale_2)));
predic_2 = reshape(predic,sz);

predic_1 = predic_1/max(predic_1(:));
predic_2 = predic_2/max(predic_2(:));

K_1 = prsK_1;
K_2 = prsK_2;

predic_1 = conv2(predic_1,K_1);
predic_2 = conv2(predic_2,K_2);



predic = gain*(predic_1 - weight*predic_2) + baseline;
predic = predic(:,num_pad+1:end-num_pad);
predic = predic(:,1:sz(2)-2*num_pad);

predic(predic<0) = 0;

