function p = func_generate_image_props(base_path, overwrite)
%%
disp(['--------------------------------------------']);
disp(['GENERATE IMAGE PROPS']);

save_path = fullfile(base_path, 'improps.mat');

if overwrite == 0 && exist(save_path) == 2
    disp(['LOAD IMAGE PROPS']);
    load(save_path);
else
    
scim_path = fullfile(base_path, '*main*.tif');
scim_files = dir(scim_path);
nFiles = numel(scim_files);

im_props_session = cell(numel(nFiles),1);
for ifile = 1:nFiles
     fprintf('(generate_image_props) loading file %g/%g \n',ifile,nFiles);
     current_name = fullfile(base_path,scim_files(ifile).name);
     [im improps] = load_image(current_name ,[]);
     im_props_session{ifile} = improps;
end

p.im_props = im_props_session;
p.scim_files = scim_files;

disp(['SAVE IMAGE PROPS']);
save(save_path,'p')
end

disp(['--------------------------------------------']);

