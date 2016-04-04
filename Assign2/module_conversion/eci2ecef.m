%% function 'eci2ecef_multitime'
%
% Transforms coordinates in ECI to coordinates in ECEF
% ECI : Earth Centered Inertial Frame
% ECEF: Earth Centered Earth Fixed Frame
%
% Input  : pos_eci  = [x; y; z] | ECI                      [m]
%          times    = times since vernal equinox alignment [s]
% Output : pos_ecef = [x; y; z] | ECEF                     [m]
%
% Kelvin Hsu
% AERO4701, 2016

function pos_ecef = eci2ecef(pos_eci, times)

    % This is the rotation rate of Earth (rad/s)
    global w_earth;

    pos_ecef(1,:) = cos(w_earth.*times).*pos_eci(1,:) + sin(w_earth.*times).*pos_eci(2,:);
    pos_ecef(2,:) = - sin(w_earth.*times).*pos_eci(1,:) + cos(w_earth.*times).*pos_eci(2,:);
    pos_ecef(3,:) = pos_eci(3,:);
    
    C = [cos(w_earth*times),sin(w_earth*times),0;...
        -sin(w_earth*times),cos(w_earth*times),0;...
        0,0,1];                                         % transform matrix
    pos_ecef = C*pos_eci;
end