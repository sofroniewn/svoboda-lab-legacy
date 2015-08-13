function copy_old_scim(base_path,target_base_path,overwrite)

	% determine name of target dir
	% [pathstr, name, ext] = fileparts(base_path); 
	% run_str = name;
	% [pathstr, name, ext] = fileparts(pathstr); 
	% date_str = name;
	% [pathstr, name, ext] = fileparts(pathstr); 
	% anm_str = name;
	% full_target_dir = fullfile(target_base_path,anm_str,date_str,run_str);
 %    if exist(full_target_dir) ~=7
 %        mkdir(full_target_dir)
 %    end
    full_target_dir = target_base_path;

    %%% copy info.json
    orig = 'info.json';
    orig = which('info.json');
    target = fullfile(full_target_dir,'info.json');
    if exist(orig) == 2 && ~(~overwrite && exist(target) == 2)
        copyfile(orig,target);
    end

    %%% copy referrence info
    orig = fullfile(base_path,'scanimage','ref_conf.json');
    target = fullfile(full_target_dir,'etc','reference');
    if exist(target) ~=7
        mkdir(target)
    end
	target = fullfile(full_target_dir,'etc','reference','conf.json');
    if exist(orig) == 2 && ~(~overwrite && exist(target) == 2)
    	copyfile(orig,target);
	end
    orig = fullfile(base_path,'scanimage','ref_image.bin');
    target = fullfile(full_target_dir,'etc','reference','ref_image.bin');
    if exist(orig) == 2 && ~(~overwrite && exist(target) == 2)
    	copyfile(orig,target);
	end

    %%% copy behaviour folder
    orig = fullfile(base_path,'behaviour');
    target = fullfile(full_target_dir,'etc','behaviour');
    if exist(orig) == 7 && ~(~overwrite && exist(target) == 7)
        copyfile(orig,target);
    end

    %%% copy synch offsets
    orig = fullfile(base_path,'scanimage','sync_offsets.mat');
    target = fullfile(full_target_dir,'etc','behaviour');
    if exist(target) ~=7
        mkdir(target)
    end
    target = fullfile(full_target_dir,'etc','behaviour','sync_offsets.mat');
    if exist(orig) == 2 && ~(~overwrite && exist(target) == 2)
    	copyfile(orig,target);
	end

	%%% copy im_summary folder
    orig = fullfile(base_path,'scanimage','summary');
    target = fullfile(full_target_dir,'etc','im_summary');
    if exist(orig) == 7 && ~(~overwrite && exist(target) == 7)
        copyfile(orig,target);
    end

	%%% copy params folder
    orig = fullfile(base_path,'scanimage','params');
    target = fullfile(full_target_dir,'params');
    if exist(orig) == 7 && ~(~overwrite && exist(target) == 7)
        copyfile(orig,target);
    end
	

    %%%% copy raw scanimage tiffs
    orig = fullfile(base_path,'scanimage','raw');
    target = fullfile(full_target_dir,'images-scanimage');
    if exist(orig) == 7 && ~(~overwrite && exist(target) == 7)
        movefile(orig,target);
    end

    %%%% delete empty folders
    target = fullfile(full_target_dir,'registered_im');
    if exist(target) == 7
        files = dir(target);
        if numel(files) == 2
            rmdir(target)
        end
    end
    target = fullfile(full_target_dir,'registered_bv');
    if exist(target) == 7
        files = dir(target);
        if numel(files) == 2
            rmdir(target)
        end
    end
	

    %%% if params exist copy non aligned scim to new folder
    orig = fullfile(base_path,'scanimage','params');
    if exist(orig) == 7
        s = loadjson(fullfile(orig,'covariates.json'));
        s = cell2mat(s);
        tmp = struct2cell(s);
        id = find(strcmp(tmp(1,1,:),'scimFileNum'));
        last_file = s(id).value(end);
        % look at how many scim files in raw
        target = fullfile(full_target_dir,'images-scanimage');
        files = dir(fullfile(target,'*_main_*.tif'));
        if numel(files) > last_file
            % create new folder
            new_target = fullfile(full_target_dir,'etc','images-scanimage_extra');
            if exist(new_target) ~= 7
                mkdir(new_target);
            end
            % move extra files
            for ij = last_file+1:numel(files)
                orig = fullfile(target,files(ij).name);
                movefile(orig,new_target);
            end
        end
    end
    