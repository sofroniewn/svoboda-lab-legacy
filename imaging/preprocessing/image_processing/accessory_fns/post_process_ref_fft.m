function ref = post_process_ref_fft(ref)

%Pre process reference images for use in fft based global cross corr
ref.post_fft = cell(size(ref.base_images));
for ij = 1:size(ref.base_images,1)
	B = ref.base_images{ij};
	B = fliplr(B);
	B = flipud(B);
	B =	fft2(padarray(B, [size(B,1),size(B,2)],'post'));
	ref.post_fft{ij} = B;
end