
% Create the communications file if it is not already there.
if ~exist(filename, 'file')
    [f, msg] = fopen(filename, 'wb');
    if f ~= -1
        fwrite(f, zeros(512*512*4+1,1,'int16'), 'int16');
        fclose(f);
    else
        error('MATLAB:demo:send:cannotOpenFile', ...
              'Cannot open file "%s": %s.', filename, msg);
    end
end

m = memmapfile(filename, 'Writable', true, ...
        'Format', 'int16');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filename = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/scanimage/memmap.dat';

% To access the file from a different Matlab:

t = memmapfile(filename, 'Writable', true, 'Format', 'int16');

% then t.Data(1) = 3
%%%
base_im_path = '/Users/sofroniewn/Documents/DATA/WGNR_DATA/anm_0227254/2013_12_12/run_02/scanimage/an227254_2013_12_12_main_001.tif';
[im im_props] = load_image(base_im_path);

for ij = 1:40;
	data_send = reshape(im(:,:,4*(ij-1)+[1:4]),512*512*4,1);
	data_send = [ij;data_send];
	data_send = int16(data_send);
	t.Data = data_send;
	input('click')
end


