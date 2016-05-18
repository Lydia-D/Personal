%% Footprint Points
% L Drabsch
% 9/5/16
% Inputs ->  pos        = (x,y) coordinate in meters
% Outputs -> points     = 3D matrix of (x,y,z) of points that fall within 
%                         distance from pos

function points = getRoverFootprintPoints(pos)
    global ROVER_FOOTPRINT_RADIUS pointCloud

    % row index of points that fall within the footprint from current
    % position
    ind = cell2mat(rangesearch(pointCloud(:,1:2),pos,ROVER_FOOTPRINT_RADIUS));
    
    % x,y,z 
    points = pointCloud(ind,:);
end
