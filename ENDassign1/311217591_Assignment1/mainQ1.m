%% Assignment 1 Question 1 AERO4701
% By Lydia Drabsch Created 10/3/16
% Simulation of orbits

% Parameters a,e,i,Rasc,omega
% a = semimajor axis = (ra+rp)/2
% e = eccentricity = (ra-rp)/(ra+rp)
% i = inclination angle- angle between orbit and earths equator
% Rasc = right ascension of the ascending node - vernal equinox and orbit
%           south-north crossing
% omega = Argument of perigee - north-south crossing and perigee from
% orbital plane
% X = state vector 

clc
clear
close all
addpath('./module_conversion','./module_testing','./scripts_general','./scripts_prelim','./Data','./module_plot','./Subfns')
constants();

%% User Input
dt = 100; % seconds
Animations = 1;
StatePlots = 0;
days = 1;

% comment out parameters
%% Van Allen Probes NORAD ID: 38752 Constants
load VanAllenepoch1;  % created from fn 'createorbitpar.m'
        
%% ISS
% inc = deg2rad(51.6429);
% Rasc = deg2rad(123.7637);
% e = 0.0002017;
% omega = deg2rad(351.0445);
% M0 = 342.5794; % mean anomaly
% MM = 15.54235390; % mean number of orbits per day
% t0 = 83.8256713*secs_per_day; % time at epoch
% a = (mu_earth/(MM*2*pi/secs_per_day).^2).^(1/3); % m from mean motion TLE 
% p = a*(1-e^2);% semilatus rectum
% n = sqrt(mu_earth/a^3);  % mean motion

%% 3D Simulation Setup
if Animations == 1
    load VanAllenAxes;
    figsim.globe = Earthplot();
    grid on
    hold on
    figsim.axes = set(VanAllenAxes);
    figsim.sat = scatter3(NaN,NaN,NaN,'filled','XDatasource','X_ECI(1,1)','YDataSource','X_ECI(2,1)','ZDataSource','X_ECI(3,1)');
    figsim.orbit = plot3(NaN,NaN,NaN,'k','XDatasource','X_ECIstore(1,1:i)','YDatasource','X_ECIstore(2,1:i)','ZDatasource','X_ECIstore(3,1:i)');
    T_ECI = (r_earth+6*10^6).*eye(4);

    % position of ECEF frame at t0 rel to ECI
    ECEFframe = ecef2eci(eye(3),t0);
    T_ECEF = (r_earth+6*10^6).*[ECEFframe,[0;0;0];[0,0,0,1]];

    figsim.ECIframe = hggroup;
    plotcoord(T_ECI,'k',figsim.ECIframe);
    figsim.ECEFframe = hggroup;
    plotcoord(T_ECEF,'r',figsim.ECEFframe);

    % Ground Trace Setup
    figure
    figgnd.map = geoshow(Nasa_A,Nasa_R);
    title('Ground Trace of Van Allen Probe')
    hold on
    figgnd.sat = plot(NaN,NaN,'bo','MarkerFaceColor','b','XDatasource','X_LLHGD(2,1)','YDataSource','X_LLHGD(1,1)');
    figgnd.orbit = plot(NaN,NaN,'.c','XDatasource','X_LLHGDstore(2,1:i)','YDatasource','X_LLHGDstore(1,1:i)');
end
%% 3D time solution

i = 1; % store index
timevec = t0:dt:t0+secs_per_day*days;
% preallocation for speed
X_orbitstore(6,length(timevec)) = 0;
X_ECIstore(6,length(timevec)) = 0;
X_ECEFstore(3,length(timevec)) = 0;
X_LLHGDstore(3,length(timevec)) = 0;

for t = t0:dt:t0+secs_per_day*days
        Mt = M0 + n*(t-t0);
        % solve kepler equation
        E = newtown(Mt,e);

        % solve for theta (true anomaly) using eccentric anomaly
        theta = 2*atan(sqrt(1+e)/sqrt(1-e)*tan(E/2));

        % solve for r
        r = p/(1+e*cos(theta));

        % resolve in state space in the perifocal frame 
        % X = [x,y,z,vx,vy,vz]'
        X_orbit = [r*cos(theta);r*sin(theta);0;...
            -sqrt(mu_earth/p)*sin(theta);sqrt(mu_earth/p)*(e+cos(theta));0];
        X_orbitstore(1:6,i) = X_orbit(1:6,1);
        
        % transform to ECI orbit
        X_ECI = orbit2ECI(X_orbit,Rasc,inc,omega);
        X_ECIstore(1:6,i) = X_ECI(1:6,1);  % to plot orbit from beginning
        
        X_ECEF = eci2ecef(X_ECI(1:3,1),t); % only position
        X_ECEFstore(1:3,i) = X_ECEF;
        X_LLHGD = rad2deg(ecef2llhgd(X_ECEF));
        X_LLHGDstore(1:3,i) = X_LLHGD;
       
        if Animations == 1
            refreshdata(figsim.sat,'caller');
            refreshdata(figsim.orbit,'caller');
            rotate(figsim.globe,[0,0,1],360.*dt./(24*60*60),[0,0,0]);% continuous
            rotate(figsim.ECEFframe.Children,[0,0,1],360.*dt./(24*60*60),[0,0,0]);

            refreshdata(figgnd.sat,'caller');
            refreshdata(figgnd.orbit,'caller');
            drawnow;
        end
        i = i+1;

end

%% Calculate Period
P_kep = Period_AC(X_ECIstore(1,:),dt);
fprintf('The calculated period for the keplerian model is %.4e hours\nand the analytical period is %.4e hours\n',P_kep,24/MM)

%% State plots
if StatePlots == 1
  figstate.Q1 = figure(3);
  % ECI states
  Stateplot(X_ECIstore,timevec,figstate.Q1,{},{'m','m','m','m/s','m/s','m/s'},'b',{});
  
  % Perifocal states
  figstate.perifocal = figure(4);
  Stateplot(X_orbitstore,timevec,figstate.perifocal,{},{'m','m','m','m/s','m/s','m/s'},'r',{});

end

%% save to use with Q2
% X_ECIstore_kep = X_ECIstore;
% timevec1day = timevec;
% save Keplerian X_ECIstore_kep timevec1day