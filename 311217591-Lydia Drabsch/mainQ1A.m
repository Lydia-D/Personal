%% Calculate ECEF and ECI coordinates of Sats from emperical data - Keplerian model
% By L Drabsch 11/4/16 (Adapted from A1_Q1)

% Parameters a,e,i,Rasc,omega
% a = semimajor axis = (ra+rp)/2
% e = eccentricity = (ra-rp)/(ra+rp)
% i = inclination angle- angle between orbit and earths equator
% Rasc = right ascension of the ascending node - vernal equinox and orbit
%           south-north crossing
% omega = Argument of perigee - north-south crossing and perigee from
%       orbital plane
% X = state vector 

clc
clear
close all
addpath('./module_conversion','./Data','./module_plot','./Subfns')
constants();

%% User Input
dt = 100; % seconds
Animations = 1;
StatePlots = 0;
days = 1;
T_equ = 7347737.336;
%% Input data - use as fn?
%ClassPara =  [Rasc;omega;inc;a;e;M0,t0];        
load GPSsat_ephem
ClassPara = [deg2rad(Rasc)';deg2rad(omega)';deg2rad(inc)';a';e';deg2rad(M0)';t0']; % for all 31 sats
SatText = SatNo; % Label satellites by their number
%% Simulation Setup
if Animations == 1
   satcolour = SortOrbit(ClassPara,1); % group by Rasc
   timestart = 0;
   animation3Dearth();
   animationGT();
   animation3D_sat_initial();
end
%% 3D time solution


timevec = 0:dt:0+secs_per_day*days;

% calculate position for all time for each sat, store in multidim array
[X_ECIstore,X_ECEFstore,X_LLHGCstore] = keplerorbit3D(ClassPara,timevec',T_equ);


%% annimate in time
% ECEF = uicontrol(figsim.globe,'style','togglebutton','String','ECEF');
if Animations == 1
    animation_updates();
end
        
