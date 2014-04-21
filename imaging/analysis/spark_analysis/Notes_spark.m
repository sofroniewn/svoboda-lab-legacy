
% Start pyspark
pyspark

% Import useful libraries
%execfile('/groups/svoboda/home/sofroniewn/thunder/helper/thunder-startup.py')


% Script mode
pyspark python/thunder/sigprocessing/stats.py $MASTER /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_images_plane_01_an227254_2013_12_12_main_001.txt /groups/svoboda/wdbp/imreg/sofroniewn/test mean

pyspark python/thunder/sigprocessing/localcorr.py $MASTER /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_images_plane_01_an227254_2013_12_12_main_001.txt /groups/svoboda/wdbp/imreg/sofroniewn/test 5




%pyspark python/thunder/sigprocessing/stats.py $MASTER /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_images_plane_01_an227254_2013_12_12_main_001.txt /groups/svoboda/wdbp/imreg/sofroniewn/test mean

%% make two files
% first file ..._X contains variable X, 0 1 matrix as matfile, matrix of regressors, rows by time
% must have same number of time points as imaging data. variable has been discretized.
% freeman function - buildreg
%
% second file (for tuning analysis)    ..._s contains values each of the regressors correspons to
% 

%%% Make regressors

text_path = '/Volumes/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_behaviour_an227254_2013_12_12_main_001.txt';
A = textread(text_path);
cor_pos = A(12,4:end);

posVals =[0:8:30 Inf];

X = zeros(length(posVals)-1,length(cor_pos));
for i=1:length(posVals)-1
	inds = cor_pos>=posVals(i) & cor_pos<posVals(i+1);
	X(i,inds) = 1;
end
s = posVals(1:end-1);

save('/Volumes/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_behaviour_an227254_2013_12_12_main_001_X.mat','X');
save('/Volumes/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_behaviour_an227254_2013_12_12_main_001_s.mat','s');
