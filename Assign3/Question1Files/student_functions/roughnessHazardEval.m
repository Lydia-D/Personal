% L Drabsch
% 9/5/16
% standard deviation of the residuals of the fit plane
function mapRoughness = roughnessHazardEval(points,n,p,ROVER_CLEARANCE_HEIGHT)

    r = (points-ones(size(points,1),1)*p).*(ones(size(points,1),1)*n');
    
    eta = std(r);

    mapRoughness = 255*min(1,3*eta(3)./ROVER_CLEARANCE_HEIGHT);

end