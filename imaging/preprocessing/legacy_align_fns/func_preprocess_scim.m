function d = func_preprocess_scim(base_path,overwrite_improps,overwrite_parsed_data)
%% PREPROCESS CA DATA
disp(['--------------------------------------------']);
disp(['PREPROCESS SCIM AND BEHAVIOUR']);

base_path_spark = fullfile(base_path, 'spark');
save_path = fullfile(base_path_spark, 'parsed_data.mat');

if overwrite_parsed_data == 0 && exist(save_path) == 2
    disp(['LOAD PARSED DATA']);
    load(save_path);
else
    
    % Generate image properties matrix
    base_path_scim = fullfile(base_path, 'scanimage');
    p = func_generate_image_props(base_path_scim, overwrite_improps);
    
    % Load behavioural session variables
    base_path_behaviour = fullfile(base_path, 'behaviour');
    session = load_session_data(base_path_behaviour);
    session = parse_session_data(1,session);
    
    % Align imaging and behavioural variables
    session = func_scim_align(session,p.im_props);
    
    % Parse behavioural variables for imaging
    d = func_scim_parse_session(session,p);
    
    % Save behavioural variables for imaging
    if exist(base_path_spark,'dir') ~= 7
        mkdir(base_path_spark);
    end
    disp(['SAVE PARSED DATA']);
    save(save_path,'d')
end

disp(['--------------------------------------------']);

