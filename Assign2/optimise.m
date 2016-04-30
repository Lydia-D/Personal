%% Optimisation
% L Drabsch
% 30/4/16
% inputs: el_store = binary 4D matrix dims(llong,lat,time,sat)
%           GS = structure containing long and lat of chosen gnd stations

function [el_store,GS] = optimise(el_store,GS)
timesum = sum(el_store_next,3);
satsum = sum(timesum,4);

[maxt.time(end+1),index] = max(satsum(:));
[GS.long(end+1),GS.lat(end+1)]  = ind2sub(size(satsum),index);

Seen = el_store(GS.long(end),GS.lat(end),:,:);
Unseen = ~Seen;
el_store_next = el_store; % initalise size
for lat_i = 1:1:length(lat_vec)
    for long_i = 1:1:length(long_vec)
        % at a point in space test if unseen through all time for all
        % satellites
        el_store_next(long_i,lat_i,:,:) = el_store(long_i,lat_i,:,:) & Unseen;  
    end
end
% sum through time for each location and sat
timesum = sum(el_store_next,3);
satsum = sum(timesum,4);
figure
mesh(rad2deg(GS_Lat),rad2deg(GS_Long),squeeze(satsum))