%% function 'ecef2eci'
%
% Transforms coordinates in ECEF to coordinates in ECI
% ECEF: Earth Centered Earth Fixed Frame
% ECI : Earth Centered Inertial Frame
%
% Input  : pos_ecef = [x; y; z] | ECEF                     [m]
%          times    = times since vernal equinox alignment [s]
% Output : pos_eci  = [x; y; z] | ECI                      [m]
%
% Kelvin Hsu
% AERO4701, 2016
%% Edited 29/2/16 by Lydia Drabsch
% Notes: assume z axes for both ECEF and ECI are the same direction
function pos_eci = ecef2eci(pos_ecef, times)

    % This is the rotation rate of Earth (rad/s)
    global w_earth;    
    C = [cos(w_earth*times),-sin(w_earth*times),0;...
        sin(w_earth*times),cos(w_earth*times),0;...
        0,0,1];                                         % transform matrix
    pos_eci = C*pos_ecef;
end