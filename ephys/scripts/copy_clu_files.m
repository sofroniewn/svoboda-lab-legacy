

%all_anm_id = {'235585','237723','245918','249872','246702','250492','250494','250495','247871','250496','256043','252776'};
all_anm_id = {'252778','266642','266644','270330','270329','270331'};


for ih =  1:numel(all_anm_id)
	anm_id = all_anm_id{ih}
	
    [base_dir anm_params] = ephys_anm_id_database(anm_id,0);

	sorted_name = 'klusters_data';

f_name_clu = fullfile(base_dir,'ephys','sorted',sorted_name,[sorted_name '.clu.1']);
f_name_backup_clu = fullfile(base_dir,'ephys','sorted',sorted_name,[sorted_name '_backup.clu.1']);


copyfile(f_name_clu,f_name_backup_clu);
end







