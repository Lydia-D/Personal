%% Calculate final orbit parameters 
% L Drabsch
% 12/5/16
% QUESTIONS:
%   what is phi_dot? does it change with alpha? (linesearch pg 15)

% TODO: catch error for dt = NaN
%       catch if final.inc = 0 but given Rasc (set to NaN)
%       GUI allow for rho manipulation
%       manipulate final paramters in GUI?
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
global eps
eps = 10^-5;    % sizing?  -> first derrivatve central, second fwd?

global flag
[flag] = choosedialog;
% flag.hessian = 'Forward Differencing';
% flag.hessian = 'BFGS';
% flag.merit = 'Yes';
% flag.penalty = 'Yes';
% flag.linefn = 'Wolfe';

global rho
rho = 0.01;

%% Final Orbit parameters
global Final
Final.P = 23*secs_per_hour + 56*secs_per_min + 4.0916;
Final.a = (mu_earth*Final.P^2/(4*pi^2))^(1/3);
Final.v = sqrt(mu_earth/Final.a);
Final.inc = 0;
Final.Rasc = NaN;
Final.omega = NaN;  % meaningless for circular orbit?
Final.e = 0;

X_orbit_final = class2orbit(Final.a,Final.e,0,0,0);
X_ECI_final = orbit2ECI(X_orbit_final,Final.Rasc,Final.inc,0);
Final.W = cross(X_ECI_final(1:3),X_ECI_final(4:6))./(norm(X_ECI_final(1:3))*norm(X_ECI_final(4:6)));



%% Park Orbit for initial parameters
% need X = [x,y,z,vx,vy,vz] in ECI frame from classical elements
Park.a = 6655937; % m
Park.e = 0;
Park.inc = -28.5*d2r;
Park.Rasc = 0;
Park.omega = 0;
Park.M0 = 0;
Park.t0 = 0;

global ParkX0
X_orbit = class2orbit(Park.a,Park.e,Park.M0,Park.t0,timestart);
ParkX0 = orbit2ECI(X_orbit,Park.Rasc,Park.inc,Park.omega);
global Yscale
Yscale = [pi^(-1);1000^(-1);pi^(-1);pi^(-1);pi^(-1);1000^(-1);pi^(-1);pi^(-1)];



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
        
%         Yreal = Yreal + [0.002;700;-0.003;0.003;0.002;700;0.003;-0.003];
        Y = Yreal.*Yscale;
end


%% Animations 
figsim = Graphics(Plotting,Animation,Y,timestart,dt);
%%  
f_store(1) = Cost(Y);   % cost   nessesary?
Y_store(:,1) = Y;
costfn = @(Y) Cost(Y);
g = calc_g(Y,costfn);   % df/dx  constant?
[c,param] = constraints(Y);   % constraints
% lambda_store = ones(size(c));
lambda_store = zeros(size(c));
Hl_BFGS{1} = eye(length(Y));

Lold = inf;
% lambda = ones(size(c));  % initial lambda?
errL = 10^-5;

L = 0; % to get into while loop;

index = 1;
while abs(L - Lold) > errL
    
    % Current constraints and fn handle
    [c,param] = constraints(Y)   ;
    cfnhnd = @(Yinput) constraints(Yinput);

    Store.error(:,index) = L-Lold;
    Store.cost(:,index) = Cost(Y);
    Store.lagrangian(:,index) = L;
    Store.Y(:,index) = Y;
    Store.constraints(:,index) = c;
    
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
        case 'BFGS'
            if index == 1
                Hl = calcH_fwd(Y,lambda_store(:,index),L);
                Hl_BFGS{index} = Hl;
            else
                Hl = Hl_BFGS{index};
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
                alpha = linesearch(Y,p,f_store(index),f_store(index-1),Lfnhnd); 
            end
    end
    Store.alpha(:,index) = alpha;
    Ynext = Y + alpha*p;
    

    
    switch flag.hessian
        case 'BFGS'   % use old X but new lambda for both ?? 
            Lk_fnhnd = @(Yinput) calc_L(Yinput,lambda_store(:,index));
            Lnext_fnhnd = @(Yinput) calc_L(Yinput,lambda_store(:,index));
            Hl_BFGS{index+1} = calcH_BFGS(Hl,Y,Ynext,Lk_fnhnd,Lnext_fnhnd);
    end
    
    if isnan(Ynext)
        1
        break
    else
        Y = Ynext;
        index = index+1;
    end
end

%% solve for direction
figsim2 = Graphics(Plotting,Animation,Y,timestart,dt);

%% plotting parameters
figure(3)
itteration = 1:1:index-1;
subplot(2,2,1); plot(itteration,Store.alpha); title('Step Size'); grid on
subplot(2,2,2); plot(itteration,Store.error); title('Error'); grid on
subplot(2,2,3); plot(itteration,Store.cost); title('Cost'); grid on
subplot(2,2,4); plot(itteration,Store.lagrangian); title('Lagrangian'); grid on

figure(4)
plot(itteration,Store.constraints); title('Constraints')


plot(Y_store(2,:),'r')
hold on
plot(Y_store(6,:),'b')

