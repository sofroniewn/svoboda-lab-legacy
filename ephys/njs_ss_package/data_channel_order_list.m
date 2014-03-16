function [ch_order] = channel_order_list




%% ----------------------------
% Simtec on probes definition
% ---------------------------------
%
% Probe looking down as in neuronexus manual (male connectors looking up).
% -1 = G    -2 = R    -3 = NC

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


% ***************************
%  connection.A32x1ToApig64_v1 -> Connection in the top of Apig64
% ***************************
%
% Intan_Ch = [ordered by electrode#(1-32)        INTAN_CH ];

for i=1:32,
    simtec_Pin  = find(simtec32.topConnector.order == i);
    Intan_Ch(i,1) = apig64_v1.topConnector.order(simtec_Pin);
end

%% ELCECTRODE specification
% 32 channel 4x8
Electrode = 1:32;
% Electrode  = [1 8 2 7 3 6 4 5,...
%     [1 8 2 7 3 6 4 5]+8,...
%     [1 8 2 7 3 6 4 5]+16,...
%     [1 8 2 7 3 6 4 5]+24,...
%     ]; % Electrode numbering in Probes to my reference (1 at top, 8 bottom)

ch_order = NaN(length(Electrode),1);
for i = 1:length(Electrode)    
    ElectrodeNO = Electrode(i);
    Intan_ChNO = Intan_Ch(ElectrodeNO);
    ch_order(i) = Intan_ChNO;
end






