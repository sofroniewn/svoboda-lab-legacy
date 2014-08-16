cur_dir = pwd;
filePath = '~/Desktop';
fileName = 'pdfSummary_example';

f=fopen(fullfile(filePath,[fileName '.m']),'w+');
fprintf(f,['%%%% Example \n']);

for i=1:4
fprintf(f,['%%%% Summary --   example %d \n'],i);
fprintf(f,['figure; plot(%d +[1:10],[1:10],''r'')\n'],i);
end

fclose(f);

cd(filePath)
publish([fileName '.m'])
cd(cur_dir)