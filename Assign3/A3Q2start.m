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

global flag
flag = chooseopt;
% flag.hessian = 'Forward Differencing';
% flag.hessian = 'BFGS';
% flag.merit = 'Yes';
% flag.penalty = 'Yes';
% flag.linefn = 'Wolfe';

global rho
rho = str2double(flag.penalty);
%% Final Orbit parameters
global Final
Final = chooseFinal;

Final.P = Final.Pdays*secs_per_Sday;
Final.a = (mu_earth*Final.P^2/(4*pi^2))^(1/3);
Final.v = sqrt(mu_earth/Final.a);


X_orbit_final = class2orbit(Final.a,Final.e,0,0,0);
X_ECI_final = orbit2ECI(X_orbit_final,Final.Rasc,Final.inc,0);
Final.W = cross(X_ECI_final(1:3),X_ECI_final(4:6))./(norm(X_ECI_final(1:3))*norm(X_ECI_final(4:6)));

%% Park Orbit for initial parameters
% need X = [x,y,z,vx,vy,vz] in ECI frame from classical elements
global Park ParkX0
Park.a = 6655937; % m
Park.e = 0;
Park.inc = -28.5*d2r;
Park.Rasc = 0;
Park.omega = 0;
Park.M0 = 0;
Park.t0 = 0;

X_orbit = class2orbit(Park.a,Park.e,Park.M0,Park.t0,timestart);
ParkX0      = orbit2ECI(X_orbit,Park.Rasc,Park.inc,Park.omega);
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
%         Yreal = Yreal + [0.001;500;0.001;0.001;0.001;500;0.001;0.001];
        Y = Yreal.*Yscale;
end


%% Animations 
figsim = Graphics(Plotting,Animation,Y,timestart,dt);
%%  
global eps
eps = 10^-5;    % sizing?  -> first derrivatve central, second fwd?
% f_store(1) = Cost(Y);   % cost   nessesary?
% Y_store(:,1) = Y;
% g = calc_g();   % df/dx  constant?
[c,param] = constraints(Y);   % constraints

cfnhnd = @(Yinput) constraints(Yinput);
costfn = @(Yinput) Cost(Yinput);
Lold = Inf;
lambda_store = ones(size(c));  % initial lambda?
errL = 10^-6;

L = 0; % to get into while loop;
index = 1;
alpha = 1;
Store = storage(L,Lold,Y,c,alpha,param,index,[]);
maxiter = 100;
while (abs(L - Lold) > errL ) && (index < maxiter)
    
    [c,param] = constraints(Y);

    
    Lold = L; 
    G = calcG(Y,cfnhnd);
    g = calc_g(Y,costfn);
    switch flag.merit
        case 'Yes'
            lambda_store(:,index) = (G*G')\G*g;
    end
    %     G = calcG(Y,eps,X0,Final);
    
    % construct lagrangian
    L = calc_L(Y,lambda_store(:,index));
    Lfnhnd = @(Yinput) calc_L(Yinput,lambda_store(:,index));

    % calculate hessian of lagrangian
    switch flag.hessian
        case 'Forward Differencing'
            Hl = calcH_fwd(Y,lambda_store(:,index),L);
        case 'Central Differencing'
            Hl = calcH_center(Y,lambda_store(:,index));
%             [~, PSDCheck] = chol(Hl); 
%             if PSDCheck > 0
%                 Hl = eye(size(Hl));
%                 fprintf('Approximated Hessian to Newton Method\n')
%             end
        case 'BFGS'
            if index == 1
%                 Hl = eye(size(Y,1));
                Hl = calcH_fwd(Y,lambda_store(:,index),L);
                Hl_BFGS{index} = Hl;
            else
                Hl = Hl_BFGS{index};
                [~, PSDCheck] = chol(Hl);  % check for positive semi-def
                if PSDCheck > 0
                    Hl = calcH_fwd(Y,lambda_store(:,index),L);
                end
            end
    end
    % solve for direction using KKT
    switch flag.merit
        case 'Yes'
             [p,~] = KKT(Hl,G,g,c);  % get updates lambda? % is this next lambda?

        case 'No'
            [p,lambda_store(:,index+1)] = KKT(Hl,G,g,c);  % get updates lambda? % is this next lambda?
    end
    % select step size
    switch flag.linefn
        case 'alphamax'
            alpha = 1;
        case 'Wolfe Conditions'
            if index == 1
                alpha = 1;
            else    % which lambda to use?
                alpha = linesearch(Y,p,Store.cost(index),Store.cost(index-1),Lfnhnd); 
            end
    end
    
    Store.alpha(:,index) = alpha;
    Ynext = Y + alpha*p;
    % calculate next hessian
    switch flag.hessian
        case 'BFGS'   % use old X but new lambda for both ?? 
            Lk_fnhnd = @(Yinput) calc_L(Yinput,lambda_store(:,index));
            Lnext_fnhnd = @(Yinput) calc_L(Yinput,lambda_store(:,index));
            Hl_BFGS{index+1} = calcH_BFGS(Hl,Y,Ynext,Lk_fnhnd,Lnext_fnhnd);
    end
    index = index+1;
    Store = storage(L,Lold,Y,c,alpha,param,index,Store);

    Y = Ynext;
end
if index == maxiter
    fprintf('Max iterations reached\n')
end
%% solve for direction
figsim2 = Graphics(Plotting,Animation,Store.Y(:,end),timestart,dt);

%% plotting parameters
figure(3)
itteration = 1:1:index;
subplot(4,1,1); plot(itteration,Store.alpha); title('Step Size'); grid on
subplot(4,1,2); plot(itteration,Store.error); title('Error'); grid on
subplot(4,1,3); plot(itteration,Store.cost); title('Cost'); grid on
subplot(4,1,4); plot(itteration,Store.lagrangian); title('Lagrangian'); grid on

%%
figure(4)
if Final.FlagRasc == 0
    n = 6;
    subplot(n,1,5); plot(itteration,Store.constraints(5,:)); title('Right Ascending node'); grid on
    subplot(n,1,6); plot(itteration,Store.constraints(6,:)); title('Right Ascending node'); grid on
else 
    n = 4;
end
subplot(n,1,1); plot(itteration,Store.constraints(1,:)); title('Radius Constraint'); grid on
subplot(n,1,2); plot(itteration,Store.constraints(2,:)); title('Velocity Constraint'); grid on
subplot(n,1,3); plot(itteration,Store.constraints(3,:)); title('Eccentricity Constraint'); grid on
subplot(n,1,4); plot(itteration,Store.constraints(4,:)); title('Inclination Constraint'); grid on

