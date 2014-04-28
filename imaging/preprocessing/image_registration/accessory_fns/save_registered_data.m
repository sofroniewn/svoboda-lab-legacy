function save_registered_data(data_dir,base_name,trial_str,im_stack,num_planes,num_chan,text_dir,down_sample,trial_data,save_registered_on,save_text_on)

if save_text_on
	text_file_name = fullfile(text_dir,[base_name 'text' trial_str '.txt']);
	num_pts = size(im_stack,3)/(num_planes*num_chan);
	fid_text = fopen(text_file_name,'w');
	if down_sample > 1
		ds_filter = ones(down_sample,1)/down_sample;
		num_pts = ceil(num_pts/down_sample);
	end
	num_pts = num_pts+3;
	fmt = repmat('%u ',1,num_pts);
end

for ij = 1:num_planes
	for ik = 1:num_chan
		% define registered data name
		type_name = 'registered';
		file_name = [base_name type_name trial_str '_p' sprintf('%02d',ij) '_c' sprintf('%02d',ik)];
		registered_file_name = fullfile(data_dir,type_name,[file_name '.bin']);	
		key_values = image2key_value_pair(im_stack,ij,num_planes,ik,num_chan);

		% Save binary file with data for each plane and channel		
		%tic;
		if save_registered_on
			fid = fopen(registered_file_name,'w');
			fwrite(fid,key_values,'uint16');
			fclose(fid);
		end

		if save_text_on
			if down_sample > 1
				keys = key_values(1:4,:);
				tmp = key_values(5:end,:);
				tmp = uint16(conv2(single(tmp),ds_filter,'same'));
				tmp = tmp(1:down_sample:end,:);
				key_values = cat(1,keys,tmp);
			end
			fprintf(fid_text,[fmt,'%u\n'],key_values);
		end
		%toc
	end
end

if save_text_on
	% write behaviour to text
	if ~isempty(trial_data)
    	trial_data = trial_data(:,12); % hack for including corridor position only
    	if down_sample > 1
			tmp = conv2(trial_data,ds_filter,'same');
			trial_data = tmp(1:down_sample:end,:);
    	end
    	tSize = size(trial_data,1);
    	dSize = size(trial_data,2);
    	z = repmat(999,1,dSize);
    	x = repmat(1,1,dSize);
    	y = 1:dSize;
    	c = repmat(1,1,dSize);
        fmt = repmat('%.4f ',1,tSize+3);
        fprintf(fid_text,[fmt,'%.4f\n'],[y;x;z;c;trial_data]);
    end
	fclose(fid_text);
end