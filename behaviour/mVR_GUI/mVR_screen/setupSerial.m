function setupSerial(comPort)

comPort = '/dev/tty.usbmodem1411'

s = serial(comPort);
set(s,'DataBits',8);
set(s,'StopBits',1);
set(s,'BaudRate',115200);
set(s,'Parity','none');
set(s,'inputbuffersize',1024);
set(s,'terminator','LF');
set(s,'BytesAvailableFcnMode','terminator');
%set(s,'bytesavailablefcn',{@mVR_baf});

%s.bytesavailablefcn={@baf,gui.fig}; %function called whenever data is available

fopen(s);

s.bytesavailable

while(1)
	bytesavailable = s.bytesavailable;
	if bytesavailable > 28
		readbytes = 28*floor(bytesavailable/28);
		data = fread(s,readbytes);
		data'
%		[data(1) data(end)]
	end
end
fclose(s)

fopen(s);
while(1)
		pause(.015)
		data = fscanf(s,'%s');
		data = eval(['[' data ']'])
end
fclose(s)
