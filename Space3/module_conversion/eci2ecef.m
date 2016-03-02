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

end