function func_concat_raw_voltages(base_dir,file_list);

    if exist(fullfile(base_dir,'ephys','concat'))~=7
        mkdir(fullfile(base_dir,'ephys','concat'));
    end
    
f_name_concat = fullfile(base_dir,'ephys','concat',file_list{1});
f_name_concat = [f_name_concat(1:end-4) '_concat.dat']
fid_concat = fopen(f_name_concat,'w');

for i_trial = 1:numel(file_list)
    f_name = fullfile(base_dir,'ephys','raw',file_list{i_trial});
   
    disp(['--------------------------------------------']);
    disp(['reading file ',f_name]);
    
  
    % Read a full file
    fid = fopen(f_name,'r');
    matrixRaw = fread(fid,inf,'uint16');
    fclose(fid);

    disp(['saving file ',f_name_concat]);
    fwrite(fid_concat,matrixRaw,'uint16');

end

fclose(fid_concat);

disp(['--------------------------------------------']);
disp(['DONE']);
disp(['--------------------------------------------']);
