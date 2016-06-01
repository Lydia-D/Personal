%% Calculate final orbit parameters 
% L Drabsch
% 12/5/16
% QUESTIONS:
%   what is phi_dot? does it change with alpha? (linesearch pg 15)
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
Plotting = 1;
Animation = 0;

%% Final Orbit parameters
Final.P = 23*secs_per_hour + 56*secs_per_min + 4.0916;
Final.a = (mu_earth*Final.P^2/(4*pi^2))^(1/3);
Final.v = sqrt(mu_earth/Final.a);
Final.inc = 0;
Final.Rasc = NaN;
Final.omega = NaN;

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
global Yscale
Yscale = [pi^(-1);1000^(-1);pi^(-1);pi^(-1);pi^(-1);1000^(-1);pi^(-1);pi^(-1)];

%% plot park orbit - simulate with Universal Conic Section






%% Initial Guess
guess = 2;
% Bad Guess
switch guess
    case 1
        Y = [0;2000;0;0;0;2000;0;0];
    case 2
        % Hohmann Transfer Guess
        Yreal = hohmann(Final,Park);
        % add errro
        Yreal = Yreal + [0.001;500;0.001;0.001;0.001;500;0.001;0.001];
        Y = Yreal.*Yscale;
end


%% Animations 
figsim = Graphics(Plotting,Animation,Y,X0,timestart,dt);
%%  
eps = 10^-5;    % sizing?  -> first derrivatve central, second fwd?
f_store(1) = Cost(Y);   % cost   nessesary?
Y_store(:,1) = Y;
g = calc_g();   % df/dx  constant?
c = constraints(X0,Y,Final);   % constraints


Lold = inf;
lambda = ones(size(c));  % initial lambda?
errL = 10^-6;

L = 0; % to get into while loop;

index = 1;
while abs(L - Lold) > errL
    
    
    
    Lold = L; 
    c = constraints(X0,Y,Final);   % constraints
    G = calcG(Y,eps,X0,Final);
    
    % construct lagrangian
    L = calc_L(Y,X0,lambda,Final);

    % calculate hessian of lagrangian
    Hl = calcH(Y,X0,lambda,Final,L,eps);
    % solve for direction using KKT
    [p,lambda] = KKT(Hl,G,g,c);  % get updates lambda

    % select step size
    if index == 1
        alpha = 1;
    else
        alpha = linesearch(Y,p,f_store(index),f_store(index-1));
    end
    
    Ynext = Y + alpha*p;
    Y = Ynext;
    
    index = index+1;
    f_store(index) = Cost(Y);
    Y_store(:,index) = Y;
end

%% solve for direction
figsim2 = Graphics(Plotting,Animation,Y,X0,timestart,dt);


