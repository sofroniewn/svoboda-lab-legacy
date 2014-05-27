function save_streaming_config(base_path,varNames,binVals,im_props)

 
fid_config = fopen(fullfile(base_path,'streaming_config.txt'),'w');
str = sprintf('dims: [%d,%d,%d,%d]',im_props.height,im_props.width,im_props.numPlanes,im_props.nchans);
fprintf(fid_config,'%s\n',str);
for ij = 1:numel(varNames)
	str = sprintf('binKeys: [%d,%d,%d,%d]',ij,1,999,1);
	fprintf(fid_config,'%s\n',str);
	fmt = repmat('%d,',1,length(binVals{ij})-1);
	str = sprintf(['binValues: [' fmt '%d]'],binVals{ij});
	fprintf(fid_config,'%s\n',str);
	str = sprintf('binNames: %s',varNames{ij});
	fprintf(fid_config,'%s\n',str);
end
fclose(fid_config);

