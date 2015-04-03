function ref = load_referrence(ref_dir)

if exist(fullfile(ref_dir,'ref_conf.json')) ~= 2
    convert_ref(ref_dir);
end

s = loadjson(fullfile(ref_dir,'ref_conf.json'));
if length(s.dims) == 2
    ref.im_props.numPlanes = 1;
else
    ref.im_props.numPlanes = s.dims(3);
end
ref.im_props.height = s.dims(1);
ref.im_props.width = s.dims(2);

if length(s.dims) < 4
    ref.im_props.nchans = 1;
else
    ref.im_props.nchans = s.dims(4);
end


file_name = 'ref_image';
registered_file_name = fullfile(ref_dir,[file_name '.bin']);	
fid = fopen(registered_file_name,'r');
raw_ref = fread(fid,s.dtype);
fclose(fid);


ref_stack = reshape(raw_ref,s.dims);
ref.base_images = cell(ref.im_props.numPlanes,1);
for ij = 1:ref.im_props.numPlanes
	ref.base_images{ij} = ref_stack(:,:,ij);
end