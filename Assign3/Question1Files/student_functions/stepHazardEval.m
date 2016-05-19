%% Step Hazard Evaluation
% L Drabsch 
% 9/5/16

function mapStep = stepHazardEval(points,ROVER_CLEARANCE_HEIGHT)

    dmax = max(points(:,3)) - min(points(:,3));
    
    if dmax < ROVER_CLEARANCE_HEIGHT/3
        mapStep = 0;
    else
        mapStep = 255*min(1,dmax/ROVER_CLEARANCE_HEIGHT);
    end

end