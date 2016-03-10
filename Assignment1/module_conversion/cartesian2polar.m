%% function 'cartesian2polar'
%
% Transforms coordinates in cartesian coordinates [x, y, z]' 
% into polar coordinates [R, az, el]'
%
% Input  : pos_cartesian = [x,  y,  z]' in cartesian coordinates [m, m, m]
% Output : pos_polar     = [R, az, el]' in polar coordinates [m, rad, rad]
%
% Kelvin Hsu
% AERO4701, 2016
%% Edited 29/2/16 by Lydia Drabsch
% Notes: z points down, elevation defined as positive upwards from horizon
%       euler angles, radians

function pos_polar = cartesian2polar(pos_cartesian)
    pos_polar(1,1) = norm(pos_cartesian(:,1));
    pos_polar(2,1) = atan2(pos_cartesian(2,1),pos_cartesian(1,1));
    pos_polar(3,1) = atan2(-pos_cartesian(3,1),norm(pos_cartesian(1:2,1)));

end