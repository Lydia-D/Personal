% L Drabsch
% 9/5/16

function points = getRoverFootprintPoints(pos)
    global ROVER_FOOTPRINT_RADIUS pointCloud

    ind = cell2mat(rangesearch(pointCloud(:,1:2),pos,ROVER_FOOTPRINT_RADIUS));
    points = pointCloud(ind,:);
end
