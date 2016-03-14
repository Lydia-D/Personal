%% Assignment 1 Question 1 AERO4701
% By Lydia Drabsch
% Created 10/3/16
% Simulation of orbits

clc
clear
close all % figures
addpath('./scripts_general','./module_conversion')
constants();
global mu_earth
dt = 1; % seconds
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
figure(1)
clf
grid on
% axis equal
hold on
[A,R] = CreateNasa();
geoshow(A, R)
pltgrd = scatter(NaN,NaN,'filled','XDatasource','X_LLHdeg(2,1)','YDataSource','X_LLHdeg(1,1)');

figure(2)
clf
grid on
hold on
% axesm globe
% geoshow(A,R)
pltglobe = scatter3(NaN,NaN,NaN,'filled','XDatasource','X_ECI(1,1)','YDataSource','X_ECI(2,1)','ZDataSource','X_ECI(3,1)');
axis([-10^8,10^8,-10^8,10^8,-10^8,10^8])
i = 1; % store index

for t = 0:dt:24*60*60
        Mt = M0 + n*(t-t0);
        % solve kepler equation
        E = Mt; % initialise
        while abs(E-e*sin(E)-Mt) > 10^-6      % solve for f = 0
                E_next = E - (E-e*sin(E) - Mt)/(1-e*cos(E)); % E_next
                E=E_next;
        end

        % solve for theta using true anomaly
        theta = 2*atan(sqrt(1+e)/sqrt(1-e)*tan(E/2));

        % solve for r
        r = p/(1+e*cos(theta));

        % resolve in state space in the perifocal frame
        % X = [x,y,z,vx,vy,vz]'
        X_orbit = [r*cos(theta);r*sin(theta);0;-sqrt(mu_earth/p)*sin(theta);sqrt(mu_earth/p)*(e-cos(theta));0];

        % transform to ECI orbit

        X_ECI = orbit2ECI(X_orbit,Rasc,i,omega);
        refreshdata(pltglobe,'caller');
        drawnow;

%             X_LLH(1:3,i) = ecef2llhgc(eci2ecef(X_ECI(1:3,1),t));
%         X_LLH = ecef2llhgc(eci2ecef(X_ECI(1:3,1),t));        
%         X_LLHdeg = rad2deg(ecef2llhgc(eci2ecef(X_ECI(1:3,1),t)));
%         refreshdata(pltgrd,'caller');
%         drawnow;
        
        i = i+1;
        % plot
%         plot3(X_ECI(1),X_ECI(2),X_ECI(3),'d')
end

% plot LLH data
% figure(2)
% clf
% geoshow('landareas.shp', 'FaceColor', [0.5 1.0 0.5]);
% geoshow(rad2deg(X_LLH(1,10:20)),rad2deg(X_LLH(2,10:20)),'DisplayType','Multipoint')
