
root_dir = 'Q:\Nick\svoboda.lab\new\';

anm_files = dir(fullfile(root_dir,'anm_*'))

for ij = 5:numel(anm_files)
    date_files = dir(fullfile(root_dir,anm_files(ij).name,'201*'))
    for ik = 5:numel(date_files)
        run_files = dir(fullfile(root_dir,anm_files(ij).name,date_files(ik).name,'run_*'))
        for ih = 1:numel(run_files)
            base_name = fullfile(root_dir,anm_files(ij).name,date_files(ik).name,run_files(ih).name,'scanimage')
            tif_names = dir(fullfile(base_name,'*_main_*.tif'));
            file_name = fullfile(base_name,tif_names(2).name)
            generate_reference(file_name,1,1)
        end
    end
end

%%

root_dir = '/Volumes/freeman/Nick/svoboda.lab/new/';

anm_files = dir(fullfile(root_dir,'anm_*'))

for ij = 3
    date_files = dir(fullfile(root_dir,anm_files(ij).name,'201*'))
    for ik = 2 %1:numel(date_files)
        run_files = dir(fullfile(root_dir,anm_files(ij).name,date_files(ik).name,'run_*'))
        for ih = 1:numel(run_files)
            base_name = fullfile(root_dir,anm_files(ij).name,date_files(ik).name,run_files(ih).name)
            over_write = 0;
            convert_name = 'open_cl_task';
            wgnr_dir = '/Users/sofroniewn/github/wgnr/behaviour/WGNR_GUI';
            convert_legacy_behaviour(base_name,convert_name,over_write,wgnr_dir);
        end
    end
end
