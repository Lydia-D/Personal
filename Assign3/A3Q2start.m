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
endsim = 24 * secs_per_hour;
timestart = 0;
% timevec = timestart:dt:endsim;
Animation = 1;

%% Final Orbit parameters
Final.P = 23*secs_per_hour + 56*secs_per_min + 4.0916;
Final.a = (mu_earth*Final.P^2/(4*pi^2))^(1/3);
Final.v = sqrt(mu_earth/Final.a);
Final.inc = 0;

%% Park Orbit for initial parameters
% need X = [x,y,z,vx,vy,vz] in ECI frame from classical elements
Park.a = 6655937; % m
Park.e = 0;
Park.inc = -28.5*d2r;
Park.Rasc = 0;
Park.omega = 0;
Park.M0 = 0;
Park.t0 = 0;

X_orbit = class2orbit(Park.a,Park.e,Park.M0,Park.t0,timestart);
X0      = orbit2ECI(X_orbit,Park.Rasc,Park.inc,Park.omega);



%% plot park orbit - simulate with Universal Conic Section
animation3Dearth();

if Animation == 1
%     updateanimate(1,X,figsim,timevec);
else
    
     
end



%% Initial Guess
guess = 2;
% Bad Guess
switch guess
    case 1
        Y = [0;2000;0;0;0;2000;0;0];
    case 2
        % Hohmann Transfer Guess
        Y = hohmann(Final,Park);
end
[Trans,t] = dynamics(Y,X0);  % return each step

%% Animations 
% Park
TimeVec.park = timestart:dt:t.t1;
X.park = ConicDynamics(X0,TimeVec.park);
figsim = setup3Danimate('X.park',figsim,1);

% Transfer
TimeVec.trans = [t.t1:dt:t.t1+t.t3];
X.trans = ConicDynamics(Trans.X2,TimeVec.trans);
X.trans = real(X.trans);
figsim = setup3Danimate('X.trans',figsim,2);

% Final calculated
TimeVec.final = t.t1+t.t3:dt:t.t1+t.t3+24*secs_per_hour;
X.final = ConicDynamics(Trans.X4,TimeVec.final);
X.final = real(X.final);
figsim = setup3Danimate('X.final',figsim,3);


% plot
updateanimate(1,X,figsim,TimeVec.park);
updateanimate(2,X,figsim,TimeVec.trans);
updateanimate(3,X,figsim,TimeVec.final);


%%  

% calculate hessian

% solve for direction


