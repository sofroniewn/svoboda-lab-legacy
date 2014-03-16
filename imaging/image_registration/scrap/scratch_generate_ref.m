% Load in images
base_im_path = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_01/scanimage/an227254_2013_12_12_main_001.tif';
[im im_props] = load_image(base_im_path);


ref.im_props.nchans = im_props.nchans;
ref.im_props.frameRate = im_props.frameRate;
ref.im_props.numPlanes = im_props.numPlanes;
ref.im_props.height = im_props.height;
ref.im_props.width = im_props.width;

ref.base_images = cell(ref.im_props.numPlanes,1);

for ij = 1:ref.im_props.numPlanes
    ref.base_images{ij} = mean(im(:,:,ij:4:ij+10),3);
end

ref_im_path = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_01/scanimage/an227254_2013_12_12_ref.mat';
save(ref_im_path,'ref');

