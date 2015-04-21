function str = mat2strC(mat,vec)

str = [];

% if vector
if vec
	for ij = 1:length(mat)
		str = cat(2,str,[num2str(mat(ij)) ', ']);
	end
	str = ['{' str(1:end-2) '}'];
else
	for ij = 1:size(mat,1)
		str_tmp = [];
		for ik = 1:size(mat,2)
			str_tmp = cat(2,str_tmp,[num2str(mat(ij,ik)) ', ']);
		end
		str_tmp = ['{' str_tmp(1:end-2) '}'];
		str = cat(2,str,[str_tmp, ', ']);
	end
	str = ['{' str(1:end-2) '}'];
end
