function convert_ref(base_path)

ref_images_path = dir(fullfile(base_path,'ref_images*.mat'));
if numel(ref_images_path) ~= 1
	display(numel(ref_images_path));
	%display('Generate ref');
    %all_ims = dir(fullfile(base_path,'raw','*_main_*.tif'));
    %base_im_path = fullfile(base_path,'raw',all_ims(2).name);
	%generate_reference(base_im_path,1,1)
    error('Need to have one reference image');
end

load(fullfile(base_path,ref_images_path(1).name),'ref');

ref_stack = zeros(ref.im_props.height,ref.im_props.width,ref.im_props.numPlanes);
for ij = 1:ref.im_props.numPlanes
	ref_stack(:,:,ij) = ref.base_images{ij};
end

file_name = 'ref_image';
registered_file_name = fullfile(base_path,[file_name '.bin']);	
fid = fopen(registered_file_name,'w');
fwrite(fid,ref_stack(:),'uint16');
fclose(fid);


dims = [ref.im_props.height, ref.im_props.width, ref.im_props.numPlanes];
s = struct('dims', [512, 512, 4], 'dtype', 'uint16');
savejson('',s,fullfile(base_path,'ref_conf.json'));