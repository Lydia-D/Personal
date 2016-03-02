%% function 'llh_geocentric2ecef'
%
% Transforms coordinates in Geodetic LLH to coordinates in ECEF
% Geodetic LLH: Geodetic Longitude, Latitude, Height Frame
% ECEF: Earth Centered Earth Fixed Frame
%
% Input  : ???
% Output : ???
%
% Kelvin Hsu
% AERO4701, 2016

function pos_ecef = llhgd2ecef(pos_llhgd)
   
    % Semi-Major Axis of Earth
    global r_earth;
    
    % Eccentricity of Earth
    global e_earth;

end