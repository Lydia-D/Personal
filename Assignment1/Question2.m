%% L. Drabsch 15/3/16
% Question 2 Space 3 - Orbit Perturbations
% Modified equinol elements model with numerical integration by runge kutta
clc
close all
clear
RunMe();


%% Van Allen Probes NORAD ID: 38752 Constants
inc = deg2rad(10.1687);
Rasc = deg2rad(46.5607);
e = 0.6813430;
omega = deg2rad(77.2770);
M0 = 2.68103309; % mean number of orbits per day
t0 = 0; % time at epoch
a = 21887*10^3; % m from N2YO.com (RBSP A) 
% p = a*(1-e^2);% semilatus rectum
n = sqrt(mu_earth/a^3);  % mean motion

% solve for initial theta at t = 0
        t = 0;
        Mt = M0 + n*(t-t0);
        % solve kepler equation
        E = Mt; % initialise
        while abs(E-e*sin(E)-Mt) > 10^-3      % solve for f = 0
                E_next = E - (E-e*sin(E) - Mt)/(1-e*cos(E)); 
                E=E_next;
        end
        % solve for theta using true anomaly
        theta = 2*atan(sqrt(1+e)/sqrt(1-e)*tan(E/2));

%% State model parameters
% x = [p,f,g,h,k,L]'
% Xdot = dx/dt
dt = 100; % time step seconds


% initalise and convert to equinoctial elements
X_c = [Rasc,omega,inc,a,e,theta]';
Xi = class2equin(X_c);

%% 3D Simulation Setup
load VanAllen  % for axes
figsim.globe = Earthplot();
grid on
hold on
set(VanAllenAxes);
figsim.sat = scatter3(NaN,NaN,NaN,'filled','XDatasource','X_ECI(1,1)','YDataSource','X_ECI(2,1)','ZDataSource','X_ECI(3,1)');
figsim.orbit = plot3(NaN,NaN,NaN,'k','XDatasource','X_ECIstore(1,:)','YDatasource','X_ECIstore(2,:)','ZDatasource','X_ECIstore(3,:)');
T_ECI = (r_earth+6*10^6).*eye(4);
T_ECEF = (r_earth+6*10^6).*eye(4);
figsim.ECIframe = hggroup;
plotcoord(T_ECI,'k',figsim.ECIframe);
figsim.ECEFframe = hggroup;
plotcoord(T_ECEF,'r',figsim.ECEFframe);

%% Ground Trace Setup
figure
figgnd.map = geoshow(Nasa_A,Nasa_R);
hold on
% figgnd.sat = scatter(NaN,NaN,'filled','XDatasource','rad2deg(X_LLHGC(2,1))','YDataSource','rad2deg(X_LLHCG(1,1))');
% figgnd.orbit = plot(NaN,NaN,'r','XDatasource','rad2deg(X_ECEF(2,:))','YDatasource','rad2deg(X_LLHGC(1,:)');
figgnd.sat = plot(NaN,NaN,'bo','MarkerFaceColor','b','XDatasource','X_LLHGC(2,1)','YDataSource','X_LLHGC(1,1)');
figgnd.orbit = plot(NaN,NaN,'-c','XDatasource','X_LLHGCstore(2,:)','YDatasource','X_LLHGCstore(1,:)');

%% Integration
i = 1; % index
for t = 0:dt:24*60*60*1
%     X_equin(1:6,i) = Xi;
    Xnext = RungeKutta('J2statemodel',Xi,dt);

    %X_classical = 
    X_ECI = equin2eci(Xi); % plot from 0?
    X_ECIstore(1:6,i) = X_ECI(1:6,1); 
    
    refreshdata(figsim.sat,'caller');
    refreshdata(figsim.orbit,'caller');
    rotate(figsim.globe,[0,0,1],360.*dt./(24*60*60),[0,0,0]);% continuous
    rotate(figsim.ECEFframe.Children,[0,0,1],360.*dt./(24*60*60),[0,0,0]);
        
    X_ECEF = eci2ecef(X_ECI(1:3,1),t); % only position
    X_ECEFstore(1:3,i) = X_ECEF;
    X_LLHGC = rad2deg(ecef2llhgc(X_ECEF(1:3,1)));
    X_LLHGCstore(1:3,i) = X_LLHGC;
    refreshdata(figgnd.sat,'caller');
    refreshdata(figgnd.orbit,'caller');
    drawnow;
    
    Xi = Xnext;
    i = i+1;
end

%% State plots
  figstate.Q1 = figure(3);
  title('ECI States')
  time = 0:dt:24*60*60*1;
  Stateplot(X_ECIstore,time,figstate.Q1);
  figstate.perifocal = figure(4);
  title('Perifocal States')
  Stateplot(X_perifocal,time,figstate.perifocal);
%         X_ECI = orbit2ECI(X_orbit,Rasc,inc,omega);
