%% L. Drabsch 15/3/16
% Question 2 Space 3 - Orbit Perturbations
% Modified equinol elements model with numerical integration by runge kutta
clc
close all
clear
RunMe();
Animations = 0; % 1 for one, 0 for off
StatePlots = 1;
days = 12;
%% Van Allen Probes NORAD ID: 38752 Constants
% inc = deg2rad(10.1687);
% Rasc = deg2rad(46.5607);
% e = 0.6813430;
% omega = deg2rad(77.2770);
% M0 = 2.68103309; % mean number of orbits per day
% t0 = 0; % time at epoch
% a = 21887*10^3; % m from N2YO.com (RBSP A) 
% % p = a*(1-e^2);% semilatus rectum
% n = sqrt(mu_earth/a^3);  % mean motion
load VanAllenepoch1;
% solve for initial theta at t = t0
    t = t0;
    Mt = M0 + n*(t-t0);
    % solve kepler equation
    E = newtown(Mt,e);
    % solve for true anomaly using eccentric anomaly
    theta = 2*atan(sqrt(1+e)/sqrt(1-e)*tan(E/2));

%% State model parameters
% x = [p,f,g,h,k,L]'
% Xdot = dx/dt
dt = 100; % time step seconds

% initalise and convert to equinoctial elements
X_c = [Rasc,omega,inc,a,e,theta]';
X_e = class2equin(X_c);

%% 3D Simulation Setup
if Animations == 1
    load VanAllenAxes;  % for axes
    figsim.globe = Earthplot();
    grid on
    hold on
    set(VanAllenAxes);
    figsim.sat = scatter3(NaN,NaN,NaN,'filled','XDatasource','X_ECI(1,1)','YDataSource','X_ECI(2,1)','ZDataSource','X_ECI(3,1)');
    figsim.orbit = plot3(NaN,NaN,NaN,'k','XDatasource','X_ECIstore(1,:)','YDatasource','X_ECIstore(2,:)','ZDatasource','X_ECIstore(3,:)');
    T_ECI = (r_earth+6*10^6).*eye(4);
    figsim.ECIframe = hggroup;
    plotcoord(T_ECI,'k',figsim.ECIframe);
    
    % position of ECEF frame at t0 rel to ECI
    ECEFframe = ecef2eci(eye(3),t0);
    T_ECEF = (r_earth+6*10^6).*[ECEFframe,[0;0;0];[0,0,0,1]];
    figsim.ECEFframe = hggroup;
    plotcoord(T_ECEF,'r',figsim.ECEFframe);

    % Ground Trace Setup
    figure
    figgnd.map = geoshow(Nasa_A,Nasa_R);
    hold on
    figgnd.sat = plot(NaN,NaN,'bo','MarkerFaceColor','b','XDatasource','X_LLHGD(2,1)','YDataSource','X_LLHGD(1,1)');
    figgnd.orbit = plot(NaN,NaN,'.c','XDatasource','X_LLHGDstore(2,:)','YDatasource','X_LLHGDstore(1,:)');
end

%% Integration
i = 1; % index
for t = t0:dt:t0+secs_per_day*days
    % store current X
    X_estore(1:6,i) = X_e;
    
    % transform to ECI and store current timestep 
    X_ECI = equin2eci(X_e); % plot from 0?
    X_ECIstore(1:6,i) = X_ECI(1:6,1); 
    
    % transform to ECEF and store current timestep
    X_ECEF = eci2ecef(X_ECI(1:3,1),t); % only position
    X_ECEFstore(1:3,i) = X_ECEF;
    
    % transform to LLHGD
    X_LLHGD = rad2deg(ecef2llhgd(X_ECEF(1:3,1)));
    X_LLHGDstore(1:3,i) = X_LLHGD;
    
    % plot current 
    if Animations == 1
        refreshdata(figsim.sat,'caller');
        refreshdata(figsim.orbit,'caller');
        rotate(figsim.globe,[0,0,1],360.*dt./(secs_per_day),[0,0,0]);% continuous
        rotate(figsim.ECEFframe.Children,[0,0,1],360.*dt./(secs_per_day),[0,0,0]);

        refreshdata(figgnd.sat,'caller');
        refreshdata(figgnd.orbit,'caller');
        drawnow;
    end
    
    % integrate to next time step
    Xnext = RungeKutta('J2statemodel',X_e,dt);
    X_e = Xnext;
    i = i+1;
end

%% State plots
if StatePlots == 1
    
    X_c = equin2class(X_estore);
    
  figstate.Q1 = figure(3);
  title('ECI States')
  time = t0:dt:t0+secs_per_day*days;
  Stateplot(X_ECIstore,time,figstate.Q1,{},'-k');
  
  figstate.classical = figure(4);
  title('Classical States')
  Stateplot(X_c,time,figstate.classical.Number,{'Rasc','omega','inc','a','e','theta'},'-k');

  figstate.equin = figure(5);
  title('Equinoctial states')
  Stateplot(X_estore,time,figstate.equin.Number,{'p','f','g','h','k','L'},'-k')
  %         X_ECI = orbit2ECI(X_orbit,Rasc,inc,omega);
end

%% Compare later in time
load RBSPA
[RealData_c,RD_time] = TLEinput(RBSPA);
RealData_e = class2equin(RealData_c);
hold on
Stateplot(RealData_c,RD_time,figstate.classical.Number,{'Rasc','omega','inc','a','e','theta'},'xr');
Stateplot(RealData_e,RD_time,figstate.equin.Number,{'p','f','g','h','k','L'},'xr');

% Stateplot(X_c2,t02,figstate.classical.Number,{'Rasc','omega','inc','a','e','theta'},'xr');