%% Calculate final orbit parameters 
% L Drabsch
% 12/5/16
clear
clc
close all
addpath('./Question2Files','./Question2Files/module_plot',...
    './Question2Files/module_conversion')
constants();


%% Simulation Setup
dt = 100; % seconds
endsim = 12 * secs_per_hour;
timestart = 0;
timevec = timestart:dt:endsim;
Animation = 1;

%% Final Orbit parameters
final.P = 23*secs_per_hour + 56*secs_per_min + 4.0916;
final.a = (mu_earth*final.P^2/(4*pi^2))^(1/3);
final.v = sqrt(mu_earth/final.a);

%% Park Orbit for initial parameters
% need X = [x,y,z,vx,vy,vz] in ECI frame from classical elements
park.a = 6655937; % m
park.e = 0;
park.inc = -28.5*d2r;
park.Rasc = 0;
park.omega = 0;
park.M0 = 0;
park.t0 = 0;

X_orbit = class2orbit(park.a,park.e,park.M0,park.t0,timestart);
X0      = orbit2ECI(X_orbit,park.Rasc,park.inc,park.omega);



%% plot park orbit - simulate with Universal Conic Section

if Animation == 1
    animation3Dearth();
    animation3D_setup();
    X.park = ConicDynamics(X0,timevec);
    animation_updates();
end



%% Initial Guess

% Bad Guess
Y = [0;2000;0;0;0;2000;0;0];
% Hofmann Transfer Guess



%% Initial cost and constraints


