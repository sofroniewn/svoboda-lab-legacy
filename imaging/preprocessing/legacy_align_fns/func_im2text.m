function func_im2text(base_path,cluster_base,base_session)
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
textFolder =  fullfile(base_path, 'spark');
clusterFolder = fullfile(cluster_base,base_session,'raw');
try
    if exist(clusterFolder,'dir') ~= 7
        mkdir(clusterFolder);
    end
catch
end

load(stimName);

xRng = [1 d.scim_info{1}.width];
yRng = [1 d.scim_info{1}.height];
nPlanes = d.scim_info{1}.numPlanes;

% parse the info
fileNames = d.scim_files;
fileNums = d.scim_data(16,:);
tSize = length(fileNums);
dat = zeros(tSize,(diff(xRng)+1)*(diff(yRng)+1),'uint16');
nFiles = length(fileNames);

for thisZ = 1:nPlanes
    % load the data
    for ifile = 1:nFiles
        fprintf('(stack2textPar) loading file %g/%g \n',ifile,nFiles);
        inds = find(fileNums == ifile);
        dattmp = zeros(length(inds),(diff(xRng)+1)*(diff(yRng)+1),'uint16');
        parfor iframe = 1:length(inds)
            oim = imread([volFolder,'/fov_0100',num2str(thisZ),'/fluo_batch_out/Image_Registration_4_',fileNames(ifile).name],'Index',iframe);
            dattmp(iframe,:) = oim(:);
        end
        dat(inds,:) = dattmp;
    end
    
    % get the coordinates
    [X Y] = meshgrid([1:diff(xRng)+1],[1:diff(yRng)+1]);
    x = X(:)';
    y = Y(:)';
    z = repmat(thisZ,1,(diff(xRng)+1)*(diff(yRng)+1));
    
    % write the plane to text
    sprintf('Writing dat_plane%02d.txt',thisZ);
    f = fopen(fullfile(textFolder,sprintf('dat_plane%02d.txt',thisZ)),'w');
    fmt = repmat('%u ',1,tSize+2);
    fprintf(f,[fmt,'%u\n'],[y;x;z;dat]);
    sprintf('Done dat_plane%02d.txt',thisZ);
    fclose(f);

    try
        % write the plane to text
        sprintf('Writing to cluster dat_plane%02d.txt',thisZ);
        f = fopen(fullfile(clusterFolder,sprintf('dat_plane%02d.txt',thisZ)),'w');
        fmt = repmat('%u ',1,tSize+2);
        fprintf(f,[fmt,'%u\n'],[y;x;z;dat]);
        sprintf('Done dat_plane%02d.txt',thisZ);
        fclose(f);
    catch
        fprintf('FAILED')
    end
end

disp(['TEXT FILES GENERATED']);
toc
disp(['--------------------------------------------']);
