

base_dir = '/Volumes/wdbp/imreg/sofroniewn/anm_0251824/2014_07_20/run_01/scanimage/registered/';
base_name = 'an251824_2014_07_19_*';
rename_name = 'an251824_2014_07_20_';

cd(base_dir)

rename_ind = length(rename_name);
rename_files = dir(base_name);
for ij = 1:numel(rename_files)
	[ij numel(rename_files)]
	old_name = rename_files(ij).name;
	new_name = [rename_name old_name(rename_ind+1:end)];
	movefile(old_name,new_name);
end


