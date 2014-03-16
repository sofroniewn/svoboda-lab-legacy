%% ----------------------------
% Simtec on probes definition
% ---------------------------------
%
% Probe looking down as in neuronexus manual (male connectors looking up).
% -1 = G    -2 = R    -3 = NC
simtec64.topConnector.order(1,:) = [1   2  3  4 5  7  9  11 13 15];
simtec64.topConnector.order(2,:) = [-1 -2 -3 -3 6  8  10 12 14 16];
simtec64.topConnector.order(3,:) = [-1 -3 -3 -3 59 57 55 53 51 49];
simtec64.topConnector.order(4,:) = [64 63 62 61 60 58 56 54 52 50];
simtec64.bottomConnector.order(1,:) = [17  18 19 20 21 23  24  25 26 27];
simtec64.bottomConnector.order(2,:) = [-3 -3 -3 -3  22 28  32  29 30 31];
simtec64.bottomConnector.order(3,:) = [-3 -3 -3 -3  43 37  33  36 35 34];
simtec64.bottomConnector.order(4,:) = [48 47 46 45  44 42  41  40 39 38];
simtec64.topConnector.vecOrder = reshape(simtec64.topConnector.order,1,40);
simtec64.bottomConnector.vecOrder = reshape(simtec64.topConnector.order,1,40);



% NOTE : Neuronexus manual is confusing....in this case they say that
% electrode sides up....but 64 sides down but have similar arrangement.
% I'll keep same convention as 64 as it seems the G R are in same
% locations. 
simtec32.topConnector.order(1,:) = [11  9  7  5  3  2  6  8  10 12];
simtec32.topConnector.order(2,:) = [-1 -2 -3 -3  1  4  13 14 15 16];
simtec32.topConnector.order(3,:) = [-1 -3 -3 -3  26 24 20 19 18 17];
simtec32.topConnector.order(4,:) = [32 30 31 28  29 27 25 22 23 21];


%% ------------------------------
% Brian 64 Headstage Simtec connectors
%-------------------------------
% 
% Female connectors looking up (as you would be connecting the probes).
% Starting from the top
apig64_v1.topConnector.order(1,:) = [9  10 11 12 14 16 23 21 19 17];
apig64_v1.topConnector.order(2,:) = [-3 -2 -3 -3 13 15 24 22 20 18];
apig64_v1.topConnector.order(3,:) = [-3 -2 -3 -3 4  2  25 27 29 31];
apig64_v1.topConnector.order(4,:) = [8   7  6  5 3  1  26 28 30 32];
apig64_v1.bottomConnector.order    = zeros(4,10);
index = find(apig64_v1.topConnector.order > 0);
apig64_v1.bottomConnector.order(index) = apig64_v1.topConnector.order(index) + 32;


%% ---------------------- 
% Electrodes definitions
% ------------------------
%
% Top and left looking the electrodes from the front is #1.
% Top left, then down, then right
electrodeSites.A8x8.shanks = 8;
electrodeSites.A8x8.electrodesPerShank = 8;
electrodeSites.A8x8.interShankSeparation = 200;   % um
electrodeSites.A8x8.interElectrodeDistance = 200; % um
electrodeSites.A8x8.order = [5 4 6 3 7 2 8 1 13 12 14 11 15 10 16 9 21 20 22 19 23 18 24 17 29 28 30 27 31 26 32 25 37 36 38 35 39 34 40 33 45 44 46 43 47 42 48 41 53 52 54 51 55 50 56 49 61 60 62 59 63 58 64 57];

electrodeSites.A32x1.shanks = 1;
electrodeSites.A32x1.electrodesPerShank = 32;
electrodeSites.A32x1.interShankSeparation = -1;   % um
electrodeSites.A32x1.interElectrodeDistance = 50; % um
electrodeSites.A32x1.order = [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1];

electrodeSites.A32x1Edge.shanks = 1;
electrodeSites.A32x1Edge.interShankSeparation = -1;   % um
electrodeSites.A32x1Edge.interElectrodeDistance = 20; % um
electrodeSites.A32x1Edge.order = [32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1];

%% -----------------------------
% Connections
% ------------------------------
% revorder -> Maps spatial electrode position (1 top and left from front view
%          of probes) to the order in spikeGL file
% order    -> Maps spikeGL order to spatial electrode position
%
% If you want to go from 1:32 of spikeGL to have that order by electrode use spikeGLData(revorder)





% ***************************
%  connection.A8x8ToApig64_v1
% ***************************
%


% Lets do it in the dumb way to be  clear what is connected to what
for i=1:64,
    elecNumber = electrodeSites.A8x8.order(i);
    posTop     = find(simtec64.topConnector.order == elecNumber);
    posBottom  = find(simtec64.bottomConnector.order == elecNumber);
    if ~isempty(posTop)
        connection.A8x8ToApig64_v1.revorder(i) = apig64_v1.topConnector.order(posTop);
        connection.A8x8ToApig64_v1.order(apig64_v1.topConnector.order(posTop)) = i;
    else
        connection.A8x8ToApig64_v1.revorder(i) = apig64_v1.bottomConnector.order(posBottom);    
        connection.A8x8ToApig64_v1.order(apig64_v1.bottomConnector.order(posBottom))    = i;
    end
end


% ***************************
%  connection.A32x1ToApig64_v1 -> Connection in the top of Apig64
% ***************************
%
for i=1:32,
    elecNumber = electrodeSites.A32x1.order(i);
    posTop     = find(simtec32.topConnector.order == elecNumber);
    connection.A32x1ToApig64TOP_v1.revorder(i) = apig64_v1.topConnector.order(posTop);
    connection.A32x1ToApig64TOP_v1.order(apig64_v1.topConnector.order(posTop)) = i;
end

% ***************************
%  connection.A32x1EdgeToApig64_v1 -> Connection in the top of Apig64
% ***************************
%
for i=1:32,
    elecNumber = electrodeSites.A32x1Edge.order(i);
    posTop     = find(simtec32.topConnector.order == elecNumber);
    connection.A32x1EdgeToApig64TOP_v1.revorder(i) = apig64_v1.topConnector.order(posTop);
    connection.A32x1EdgeToApig64TOP_v1.order(apig64_v1.topConnector.order(posTop)) = i;
end


% ***************************
%  connection.A32x1EdgeToApig64_v1 -> Connection in the top of Apig64
% ***************************
% %
% for i=1:32,
%     elecNumber = electrodeSites.A32x1Edge.order(i);
%     posTop     = find(simtec32.bottomConnector.order == elecNumber);
%     connection.A32x1EdgeToApig64BOTTOM_v1.revorder(i) = apig64_v1.bottomConnector.order(posTop);
%     connection.A32x1EdgeToApig64BOTTOM_v1.order(apig64_v1.bottomConnector.order(posTop)) = i;
% end
% 


