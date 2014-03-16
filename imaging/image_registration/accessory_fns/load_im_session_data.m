function im_session = load_im_session_data(data_dir)

im_session.basic_info.data_dir = data_dir;
[pathstr, name, ext] = fileparts(data_dir); 
[pathstr, name, ext] = fileparts(pathstr); 
im_session.basic_info.run_str = name;
[pathstr, name, ext] = fileparts(pathstr); 
im_session.basic_info.date_str = name;
[pathstr, name, ext] = fileparts(pathstr); 
im_session.basic_info.anm_str = name;

im_session.basic_info.cur_files = dir(fullfile(im_session.basic_info.data_dir,'*_main_*.tif'));
%im_session.data = cell(numel(cur_files)-1,1);
%
%for ij = 1:numel(cur_files)-1
%    f_name = fullfile(data_dir,cur_files(ij).name);
%    session.data{ij} = load(f_name);
%    session.data{ij}.f_name = f_name;
%end

end