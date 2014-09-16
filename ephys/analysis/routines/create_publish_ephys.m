function create_publish_ephys(summarize_name)

fileName = which('publish_ephys.m');

f=fopen(fileName,'w+');

fprintf(f,'global session \n');
fprintf(f,'global sorted_spikes \n');
fprintf(f,'global trial_range \n');
fprintf(f,'global ephys_summary \n\n');

fprintf(f,'if ~isempty(ephys_summary) \n');
fprintf(f,'	all_clust_ids = ephys_summary.d(ephys_summary.d(:,4) == 0,2); \n');
fprintf(f,' depth = ephys_summary.d(ephys_summary.d(:,4) == 0,3); \n');
fprintf(f,' [vals Idx] = sort(depth); \n');
fprintf(f,' all_clust_ids = all_clust_ids(Idx); \n');
fprintf(f,'else \n');
fprintf(f,'	all_clust_ids = [3:numel(sorted_spikes)]; \n');
fprintf(f,'end \n\n');

fprintf(f,'plot_on = 1; \n');
fprintf(f,'d = []; \n');

fprintf(f,'d = %s(d,ephys_summary,all_clust_ids,sorted_spikes,session,exp_type,id_type,trial_range,plot_on); \n',summarize_name);
fprintf(f,'assignin(''base'',''d'',d);\n');


fclose(f);