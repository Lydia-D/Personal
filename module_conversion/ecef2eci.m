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

function pos_eci = ecef2eci(pos_ecef, times)

    % This is the rotation rate of Earth (rad/s)
    global w_earth;

end