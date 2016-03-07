%% function 'ecef2llh_geocentric'
%
% Transforms coordinates in ECEF to Geocentric LLH
% ECEF: Earth Centered Earth Fixed Frame
% Geocentric LLH: Geocentric Longitude, Latitude, Height Frame
%
% Inputs:   ->  X_ECEF           = [x, y, z]' in ECEF frame
% Outputs:  ->  X_LLH_GC         = [lat, lon, h]' in geocentric LLH
%
% Kelvin Hsu
% AERO4701, 2016
%% Edited by Lydia Drabsch 6/3/16
function X_LLHGC = ecef2llhgc(X_ECEF)

    global r_earth;     % Earth's radius

    X_LLHGC(1,1) = atan2(X_ECEF(3,1),norm(X_ECEF(1:2,1)));  % latitude
    X_LLHGC(2,1) = atan2(X_ECEF(2,1),X_ECEF(1,1));          % longitude
    X_LLHGC(3,1) = norm(X_ECEF(:,1))-r_earth;               % height
end