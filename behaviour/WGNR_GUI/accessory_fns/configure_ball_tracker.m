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

function vi = configure_ball_tracker(dev_str)

imaqreset

devID = 0; %FTDI Device ID

%Connect to camera
% will need to register treadmill.dll with matlab's IMAQREGISTER function
vi = videoinput(dev_str,devID);
vi.framespertrigger = inf;
vi.framesacquiredfcncount = 1;
set(vi.Source,'motionVideo',0);
set(vi.Source,'PacketsPerFrame',200); %%%%%%%%%%% or 100??????
  