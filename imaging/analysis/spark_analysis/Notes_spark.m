
% Login to cluseter
qsub -jc spark -pe spark 5 -q hadoop2 -j y -o ~/sparklogs/ /sge/current/examples/jobs/sleeper.sh 86400

% ssh into master node
ssh h02u08.int.janelia.org

export MASTER=spark://h02u08.int.janelia.org:7077

% For shell mode
export IPYTHON=1

% Start pyspark
pyspark

% Import useful libraries - shell mode
%

% Script mode -- have export IPYTHON = 0
cd ./thunder

pyspark python/thunder/sigprocessing/stats.py $MASTER "/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_images_*.txt" /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/spark mean

pyspark python/thunder/sigprocessing/localcorr.py $MASTER /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_images_p01_c01.txt /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/spark 5


pyspark combined.py $MASTER "/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_images_*.txt" /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_behaviour_corPos /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/spark

pyspark combined.py $MASTER /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session "Text_images_*.txt" /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/spark

pyspark combined.py $MASTER /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session "Text_images_*.txt" /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/spark --stim corPos-speed --basename Text_behaviour_

%pyspark python/thunder/sigprocessing/stats.py $MASTER /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_images_plane_01_an227254_2013_12_12_main_001.txt /groups/svoboda/wdbp/imreg/sofroniewn/test mean

% WHEN DONE
qdel -u sofroniewn

% shell mode
% Import useful libraries
execfile('/groups/svoboda/home/sofroniewn/thunder/helper/thunder-startup.py')

% load data
data = load(sc,'/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_images_*.txt','raw',4)
data = load(sc,'/groups/svoboda/wdbp/imreg/sofroniewn/anm_0238004/2014_04_27/run_01/session/Text_images_*.txt','raw',4)
data = load(sc,'/groups/svoboda/wdbp/imreg/sofroniewn/anm_0245496/2014_05_13/run_01/session/Text_images_*.txt','raw',4)

stats, betas = regress(data, "/groups/svoboda/wdbp/imreg/sofroniewn/anm_0245496/2014_05_13/run_01/session/Text_behaviour_corPos", "linear")
tune = tuning(betas,"/groups/svoboda/wdbp/imreg/sofroniewn/anm_0245496/2014_05_13/run_01/session/Text_behaviour_corPos", "gaussian")

% drop channel key
data = data.map(lambda (k, v): (k[0:3], v))

data.cache()

% import stats package
from thunder.sigprocessing.stats import stats
from thunder.regression.tuning import tuning

% run mean
vals = stats(data,'mean')

% save data
save(vals,'/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/spark','mean_vals','matlab')

% Look at data in matlab
figure; imshow(mean_vals/500)

% import local corr
from thunder.sigprocessing.localcorr import localcorr

% run local corr
cor = localcorr(data2,5)

% save data
save(cor,'/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/spark','local_corr','matlab')

% Look at data in matlab
figure; imshow(local_corr)


% look at help --- hit q to exit
help(regress) 

stats, betas = regress(data, "/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_behaviour_corPos", "linear")
tune = tuning(betas,"/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_behaviour_corPos", "gaussian")

save(stats,'/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/spark','stats_corPos','matlab')
save(tune,'/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/spark','tune_corPos','matlab')


stats, betas = regress(data, "/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_behaviour_speed", "linear")
tune = tuning(betas,"/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_behaviour_speed", "gaussian")

save(stats,'/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/spark','stats_speed','matlab')
save(tune,'/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/spark','tune_speed','matlab')


% Look at data in matlab
figure; imshow(corPos_stats*10)

figure; imshow(speed_stats*20)

save(tune,'/groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/spark','corPos_tune','matlab')


from thunder.regression.tuning import tuning






















