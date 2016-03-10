%% function 'llh_geocentric2ecef'
%
% Transforms coordinates in Geodetic LLH to coordinates in ECEF
% Geodetic LLH: Geodetic Longitude, Latitude, Height Frame
% ECEF: Earth Centered Earth Fixed Frame
%
% Input  : [lat,long,h]'
% Output : [x,y,z]'
%
% Kelvin Hsu
% AERO4701, 2016
%% Edited by Lydia Drabsch 6/3/16
% follow from lecture 1 pg 11
% 
function X_ECEF = llhgd2ecef(X_LLHGD)
   
    % Semi-Major Axis of Earth
    global r_earth;
    
    % Eccentricity of Earth
    global e_earth;

    N = r_earth/(sqrt(1-e_earth.^2.*sin(X_LLHGD(1,:)).^2));
    X_ECEF(1,:) = (N+X_LLHGD(3,:)).*cos(X_LLHGD(1,:)).*cos(X_LLHGD(2,:));
    X_ECEF(2,:) = (N+X_LLHGD(3,:)).*cos(X_LLHGD(1,:)).*sin(X_LLHGD(2,:));
    X_ECEF(3,:) = (N*(1-e_earth.^2)+X_LLHGD(3,:)).*sin(X_LLHGD(1,:));
end