%start a spark job:
qsub -jc spark -pe spark 2 -q hadoop2 -j y -o ~/sparklogs/ /sge/current/examples/jobs/sleeper.sh 7200

%ssh into master:
ssh h04u16.int.janelia.org

%set the master:
export MASTER=spark://h04u16.int.janelia.org:7077

%go to spark ui:
h04u16.int.janelia.org:8080

%go to the thunder directory:
cd ~/thunder/scala/

%start the job:
target/start thunder.streaming.StatefulBinnedStats $MASTER /path/to/data/ 10 /path/to/results /path/to/params/config.txt