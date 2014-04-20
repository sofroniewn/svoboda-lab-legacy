
% Start pyspark
pyspark

% Import useful libraries
%execfile('/groups/svoboda/home/sofroniewn/thunder/helper/thunder-startup.py')


% Script mode
pyspark python/thunder/sigprocessing/stats.py $MASTER /groups/svoboda/wdbp/imreg/sofroniewn/anm_0227254/2013_12_12/run_02/session/Text_images_plane_01_an227254_2013_12_12_main_001.txt /groups/svoboda/wdbp/imreg/sofroniewn/test mean