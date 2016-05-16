%% Optimisation for Ground Station Locations
% L Drabsch
% 30/4/16
% inputs: el_store = binary 4D matrix dims(llong,lat,time,sat)
%           GS = structure containing long and lat of chosen gnd stations
%           GS_Lat,GS_Long = mesh grids to plot

function [el_store,GS] = optimise(el_store,GS,GS_Lat,GS_Long)
    global r2d d2r
%% find max
    timesum = sum(el_store,3);
    satsum = sum(timesum,4);
    maxregion = satsum == max(satsum(:));
    CC = regionprops(maxregion);
    Centroid = cat(1,CC.Centroid);
    Area = cat(1,CC.Area);
%     [Area] == max(Area)
    Location = round(Centroid(Area == max(Area),:)); % index of lat long center
    GS.long(end+1) = Location(2);
    GS.lat(end+1) = Location(1);
    %     [GS.long(end+1),GS.lat(end+1)]  = ind2sub(size(satsum),index);
%% Plot distribution and max point
    figure
    mesh(rad2deg(GS_Lat),rad2deg(GS_Long),squeeze(satsum))
    colorbar
    xlabel('Latitude (degrees)')
    ylabel('Longitude (degrees)')
    axis equal
    axis([-90 90 0 360])
    view(90,-90)
    hold on
    drawnow;

%% Optimise
    % remove previously seen satellite times 
    Seen = el_store(GS.long(end),GS.lat(end),:,:);
    Unseen = ~Seen;
    el_store_next = el_store; % initalise size
    for lat_i = 1:1:size(GS_Lat,2)
        for long_i = 1:1:size(GS_Lat,1)
            % at a point in space test if unseen through all time for all
            % satellites
            el_store_next(long_i,lat_i,:,:) = el_store(long_i,lat_i,:,:) & Unseen;  
        end
    end
    % sum through time for each location and sat to test for convergance
    timesum = sum(el_store_next,3);
    satsum = sum(timesum,4);
    el_store = el_store_next; % update 
    % recursion - stop when all sats observed for all time
    if sum(sum(satsum,2),1) > 0
        [el_store,GS] = optimise(el_store,GS,GS_Lat,GS_Long);
    end


end