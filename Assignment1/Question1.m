%% Assignment 1 Question 1 AERO4701
% By Lydia Drabsch
% Created 10/3/16
% Simulation of orbits

clc
clear
% Parameters a,e,i,Omega,omega
% a = semimajor axis = (ra+rp)/2
% e = eccentricity = (ra-rp)/(ra+rp)
% i = inclination angle- angle between orbit and earths equator
% Rasc = right ascension of the ascending node - vernal equinox and orbit
%           south-north crossing
% omega = Argument of perigee - north-south crossing and perigee from
% orbital plane
% X = state vector 

%% Van Allen Probes NORAD ID: 38752 Constants
i = deg2rad(10.1687);
Rasc = deg2rad(46.5607);
e = 0.6813430;
omega =deg2rad(77.2770);
M0 = 2.68103309; % mean number of orbits per day
t0 = 0; % time at
a = 21887*10^3; % m from N2YO.com (RBSP A) 
p = a*(1-e^2)% semilatus rectum
n = sqrt(mu_earth/a^3);  % mean motion

%% 3D time solution

Mt = M0 + n*(t-t0);

% solve kepler equation
f = E-e*sin(E) - Mt; % solve for f = 0

% solve for theta using true anomaly
theta = 2*atan(sqrt(1+e)/sqrt(1-e)*tan(E/2));

% solve for r
r = p/(1+e*cos(theta))