function r = wrap_c_file_in_string(fn)
%
%
% DHO, 9/08.
%
%
fid = fopen(fn);
r = '';
while 1
    tline = fgets(fid);
    if ~ischar(tline)
        break;
    else
        r = strcat(r,tline);
    end
end
fclose(fid);
