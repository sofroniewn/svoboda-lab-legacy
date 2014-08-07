function start_spark_job

%start a spark job:
evalScript = 'qsub -jc spark -pe spark 10 -q hadoop2 -j y -o ~/sparklogs/ /sge/current/examples/jobs/sleeper.sh 7200';
fprintf('  %s\n',evalScript)

%ssh into master:
evalScript = 'ssh h??u??.int.janelia.org';
fprintf('  %s\n',evalScript)

%set the master:
evalScript = 'export MASTER=spark://h??u??.int.janelia.org:7077';
fprintf('  %s\n',evalScript)

%go to spark ui:
evalScript = 'h??u??.int.janelia.org:8080';
fprintf('  %s\n',evalScript)

%go to the thunder directory:
evalScript = 'cd ~/thunder/scala/';
fprintf('  %s\n',evalScript)

%start the job:
base_path = '/groups/freeman/freemanlab/Janelia/wgnr/data/streaming/tmp_dir';

path_data = [base_path '/streaming/'];
path_results = [base_path '/results/'];
path_config = [base_path '/streaming_config.txt'];

evalScript = sprintf('target/start thunder.streaming.StatefulBinnedStats $MASTER %s 10 %s %s',path_data,path_results,path_config);
fprintf('  %s\n',evalScript)
evalScript = 'qdel -u sofroniewn';
fprintf('  %s\n',evalScript)
fprintf('\n')

