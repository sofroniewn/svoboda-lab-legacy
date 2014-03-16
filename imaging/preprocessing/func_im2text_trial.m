function func_im2text_trial(base_path,cluster_base,base_session)
%% CONVERT IMAGES TO TEXT FILE
disp(['--------------------------------------------']);
disp(['CONVERT IMAGES TO TEXT FILE']);
tic
% stimFolder - folder that contains the stim file
% stimName - name of the mat file containing the stim info
% xRng - array (in our case, [1,512])
% yRng - [1,512]
% volFolder - folder containing the fov_XXXX subfolders
% textFolder - where to write the text to
% thisZ - which plane we're doing


stimName = fullfile(base_path, 'spark','parsed_data.mat');
volFolder = fullfile(base_path, 'scanimage');
textFolder =  fullfile(base_path, 'spark', 'online');
clusterFolder = fullfile(cluster_base,base_session,'raw','online');
try
    if exist(clusterFolder,'dir') ~= 7
        mkdir(clusterFolder);
    end
catch
end

if exist(textFolder,'dir') ~= 7
    mkdir(textFolder);
end

load(stimName);

xRng = [1 d.scim_info{1}.width];
yRng = [1 d.scim_info{1}.height];
nPlanes = d.scim_info{1}.numPlanes;

% parse the info
fileNames = d.scim_files;
fileNums = d.scim_data(16,:);
nFiles = length(fileNames);
dSize = size(d.scim_data,1);

for ifile = 1:nFiles
    inds = find(fileNums == ifile);
    tSize = length(inds);
    dat = d.scim_data(:,inds)';
    z = repmat(999,1,dSize);
    x = repmat(1,1,dSize);
    y = 1:dSize;
    
    fprintf('Writing dat_behaviour %g/%g \n',ifile,nFiles);
    f = fopen(fullfile(textFolder,sprintf('dat_trial_%04d_behaviour.txt',ifile)),'w');
    fmt = repmat('%.4f ',1,tSize+2);
    fprintf(f,[fmt,'%.4f\n'],[y;x;z;dat]);
    fprintf('Done dat_behaviour_trial%04d.txt',ifile);
    fclose(f);
    
    try
        fprintf('Writing dat_behaviour to cluster %g/%g \n',ifile,nFiles);
        f = fopen(fullfile(clusterFolder,sprintf('dat_trial_%04d_behaviour.txt',ifile)),'w');
        fmt = repmat('%.4f ',1,tSize+2);
        fprintf(f,[fmt,'%.4f\n'],[y;x;z;dat]);
        fprintf('Done dat_behaviour_trial%04d.txt',ifile);
        fclose(f);
    catch
        fprintf('FAILED');
    end
    
    for thisZ = 1:nPlanes
        % load the data
        fprintf('(stack2textPar) loading file %g/%g plane %g \n',ifile,nFiles,thisZ);
        dat = zeros(tSize,(diff(xRng)+1)*(diff(yRng)+1),'uint16');
        parfor iframe = 1:length(inds)
            oim = imread([volFolder,'/fov_0100',num2str(thisZ),'/fluo_batch_out/Image_Registration_4_',fileNames(ifile).name],'Index',iframe);
            dat(iframe,:) = oim(:);
        end
        % get the coordinates
        [X Y] = meshgrid([1:diff(xRng)+1],[1:diff(yRng)+1]);
        x = X(:)';
        y = Y(:)';
        z = repmat(thisZ,1,(diff(xRng)+1)*(diff(yRng)+1));
        
        % write the plane to text
        fprintf('Writing to cluster dat_plane%02d.txt',thisZ);
        f = fopen(fullfile(textFolder,sprintf('dat_trial_%04d_plane_%02d.txt',ifile,thisZ)),'w');
        fmt = repmat('%u ',1,tSize+2);
        fprintf(f,[fmt,'%u\n'],[y;x;z;dat]);
        fprintf('Done dat_plane%02d_trial%04d.txt',thisZ,ifile);
        fclose(f);
        
        try
            fprintf('Writing dat_plane%02d.txt',thisZ);
            f = fopen(fullfile(clusterFolder,sprintf('dat_trial_%04d_plane_%02d.txt',ifile,thisZ)),'w');
            fmt = repmat('%u ',1,tSize+2);
            fprintf(f,[fmt,'%u\n'],[y;x;z;dat]);
            fprintf('Done dat_plane%02d_trial%04d.txt',thisZ,ifile);
            fclose(f);
        catch
            fprintf('FAILED');
        end
    end
end

disp(['TEXT FILES GENERATED']);
toc
disp(['--------------------------------------------']);
