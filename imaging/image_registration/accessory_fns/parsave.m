function parsave(fname, varname, x)
	eval([varname ' = x;']);
	save(fname, varname);
end