
fullpath = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/scanimage/an227254_2013_12_12_main_001.tif';

tic;
hdr = extern_scim_opentif(fullpath, 'header');
toc

tic;
[im improps] = load_image(fullpath);
toc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[im_raw im_aligned im_summary] = register_file(cur_file,base_name,im_session.ref,align_chan,ij);	
