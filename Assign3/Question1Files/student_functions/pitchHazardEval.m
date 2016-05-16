% L Drabsch
% 5/9/16

function mapPitch = pitchHazardEval(n,ROVER_MAX_PITCH)

    theta = 90-atand(n(3)/norm(n(1:2)));
    
    if theta > ROVER_MAX_PITCH
        mapPitch = 255;
    else
        mapPitch = 255*min(1,theta/ROVER_MAX_PITCH);
    end
    
end