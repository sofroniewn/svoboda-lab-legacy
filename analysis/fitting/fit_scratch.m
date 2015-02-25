


sense_mat_avg_red_new = sense_mat_avg_red;

prs = [3.5 8 3/8 5 1 15 2 1 0 1 1];

prs = [0 4*10 1/4 8 4 5 1 -3.5/4 0];
%prs = [3 10 1 8 4 5 1 4 -3.5 1 0];
%prs = [15 10 1 10 4 1 1 -3.5 1 2 -1];
% prs =[ -3.3957   49.9997    0.4677*2   12.5018    3.1539   11.4084    2.6212    0    0000];
 prs =[ -3.3957   49.9997    0.4677   12.5018    3.1539   11.4084    2.6212    0    1];
 
predic = fitDoubleSigmoidKnp_modelFun(sense_mat_avg_red_new,prs);

d_sense_mat_avg_red_new = diff(sense_mat_avg_red_new,[],2);

figure(22)
clf(22)
 subplot(2,1,1)
 imagesc(flipdim(sense_mat_avg_red_new,1))
 subplot(2,1,2)
 imagesc(flipdim(predic,1))
 


%
%



[X Y] = meshgrid(0:30,[-30:30]);

sense_mat_avg_red_new = [X(:) Y(:)];
predic = fitDoubleSigmoidKnp_modelFun(sense_mat_avg_red_new,prs);
predic = predic(:,1);
predic = reshape(predic,size(X));

figure(23)
clf(23)
 subplot(2,1,1)
 imagesc(flipdim(Y,1))
 subplot(2,1,2)
 imagesc(flipdim(predic,1))
 

vel = linspace(.1,10,30);
tot_spikes = zeros(length(vel),3);

% avg number of spikes when velocity is xx during movement from 0 to 30 mm
% away. 
% used to be 500 hz sampling - 1 sample 2 ms, then ds by 20, so 1 sample is
% 40 ms, so 30mm/s to 1mm/s is 1 second to 30 seconds, is 1000/40 is
% 1000/40*30
% 
for ij = 1:length(vel)

 X = 15 + linspace(-15,15,1000/40*vel(ij));
sense_mat_avg_red_new = X;
predic = fitDoubleSigmoidKnp_modelFun(sense_mat_avg_red_new,prs);

predic_2 = fitDoubleSigmoidKnp_modelFun(flipdim(sense_mat_avg_red_new,2),prs);
predic_2 = flipdim(predic_2,2);

tot_spikes(ij,1) = mean(predic);
tot_spikes(ij,2) = mean(predic_2);
tot_spikes(ij,3) = vel(ij);

end

tot_spikes = [tot_spikes(:,1);(tot_spikes(end,1) + tot_spikes(end,2))/2;flipdim(tot_spikes(:,2),1)];
vel = [-flipdim(vel,2)';0;vel'];


figure(24)
clf(24)
 hold on
 plot(vel,tot_spikes)
 

 
% xvals = [0:.1:30];
% prs = [8 -1 3.5 5];
% predic = fitSigmoid_modelFun(xvals,prs);
% 
% prs_2 = [3 -2 0 15];
% predic_2 = fitSigmoid_modelFun(xvals,prs_2);
% 
% 
% figure(22)
% clf(22)
% hold on
% plot(xvals,predic,'b')
% plot(xvals,predic_2,'r')
% plot(xvals,predic - predic_2,'k')
% 
% prs = [3.5 8 3/8 5 -1 15 -2 1 0 1 0];
% predic = fitDoubleSigmoid_modelFun(xvals,prs);
% plot(xvals,predic,'g')
% 



%  prsG = [10 4 0];
%  prsK = [1 1 1];
%  %prsK = [2 -1]/2;
%  prs = [0 prsG 1 prsK -1 .3 .1];
%  
%  sense_mat_avg_red_new = sense_mat_avg_red;
%  %sense_mat_avg_red_new(sense_mat_avg_red_new>18) = 18;
%  
% figure(11); clf(11);
% %predic = fitGaussKnp_modelFun(sense_mat_avg_red,prs);
% predic = fitGaussVKnp_modelFun(sense_mat_avg_red_new,prs);
% subplot(3,1,1)
% imagesc(flipdim(sense_mat_avg_red_new,1))
% subplot(3,1,3)
% imagesc(flipdim(predic,1))
% 
% 
% baseline = prs(1);
% prsG1 = prs(2:4);
% prsK1 = prs(6:8);
% gain = prs(5);
% 
% sz = size(sense_mat_avg_red_new);
% xvals = [repmat(sense_mat_avg_red_new(:,1),1,60),sense_mat_avg_red_new,repmat(sense_mat_avg_red_new(:,1),1,60)];
% 
% K_pos = prsK1;
% K_pos = K_pos/max(abs(K_pos));
% 
% xvals = conv2(xvals,K_pos);
% xvals = xvals(:,61:end-60);
% xvals = xvals(:,1:sz(2));
% subplot(3,1,2)
% imagesc(flipdim(xvals,1))



% %%
% aa = normpdf([-20:.2:20]);
% cc = linspace(10,1,50)/10;
% bb = conv(aa,cc);
% 
% figure; hold on; plot(aa,'b'); plot(bb,'r');
% size(aa)
% size(bb)
% %%
% aa = normpdf([-20:.2:20]);
% cc = linspace(10,1,50)/10;
% bb = filter(cc,1,aa);
% 
% figure; hold on; plot(aa,'b'); plot(bb,'r');
% 
% size(aa)
% size(bb)
% 
% prsK = [-35 -25 -5 15 20 35]/35;
% prs = [-5 prsG 5, prsK];


