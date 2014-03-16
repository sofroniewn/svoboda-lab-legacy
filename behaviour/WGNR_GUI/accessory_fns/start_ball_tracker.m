%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%  WGNR - Whisker Guided Navigation Rig
%%%  Start Gus' Ball Tracker
%%%  Use code from Gus' motiondisplay_imaq.m
%%% 
%%%  NJS JFRC 110211
%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function camera_metrics = start_ball_tracker(vi)

flushdata(vi);
start(vi);

raw = double(getdata(vi,1));


%Camera Status Parameters
squal0 = (raw(:,7)-1)/169; %Surface quality (see ADNS-6090 data sheet)
squal1 = (raw(:,8)-1)/169;
shut0 = ((raw(:,9)-1)*256+raw(:,10))/24; %Shutter Period (us)
shut1 = ((raw(:,11)-1)*256+raw(:,12))/24; %Shutter Period

f0 = mean(shut0);
f1 = mean(shut1);
squal0 = mean(squal0);
squal1 = mean(squal1);


camera_metrics = [squal0 f0 squal1 f1];

