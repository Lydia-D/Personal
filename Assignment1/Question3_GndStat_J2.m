%% L Drabsch 16/3/16
% Question 3 simulation with grnd trace from gnd station
clc
clear
close all
addpath('./module_conversion','./module_testing','./scripts_general','./scripts_prelim','./Data','./module_plot','./Subfns')
constants();

%% User Input
dt = 100; % seconds
Animation = 1;
StatePlots = 0;
days = 1;

% Ground station position
Gnd_LLH = [deg2rad(19.0);deg2rad(-155.6);367]; %http://www.sscspace.com/south-point-satellite-station-4
Gnd_ECEF = llhgd2ecef(Gnd_LLH);

%% Van Allen Probes NORAD ID: 38752 Constants
load VanAllenepoch1

%% 3D Simulation Setup
if Animation == 1
    load VanAllenAxes
    figure(1)
    figsim.globe = Earthplot();
    figsim.axes = set(VanAllenAxes);
    figsim.trace = plot3(NaN,NaN,NaN,'m','LineWidth',2,'XDatasource','X_ECItrace(1,1:i)','YDatasource','X_ECItrace(2,1:i)','ZDatasource','X_ECItrace(3,1:i)');
    figsim.orbit = plot3(NaN,NaN,NaN,'k','XDatasource','X_ECIstore(1,1:i)','YDatasource','X_ECIstore(2,1:i)','ZDatasource','X_ECIstore(3,1:i)');
    figsim.sat = scatter3(NaN,NaN,NaN,'filled','XDatasource','X_ECI(1,1)','YDataSource','X_ECI(2,1)','ZDataSource','X_ECI(3,1)');

    % ECI coordinate frame axes
    T_ECI = (r_earth+6*10^6).*eye(4);
    figsim.ECIframe = hggroup;
    plotcoord(T_ECI,'k',figsim.ECIframe);
    
    % position of ECEF frame at t0 rel to ECI
    ECEFframe = ecef2eci(eye(3),t0);
    T_ECEF = (r_earth+6*10^6).*[ECEFframe,[0;0;0];[0,0,0,1]];
    figsim.ECEFframe = hggroup;
    plotcoord(T_ECEF,'r',figsim.ECEFframe);

    % Ground Trace Setup
    figure(2)
    figgnd.map = geoshow(Nasa_A,Nasa_R);
    hold on
    figgnd.sat = plot(NaN,NaN,'bo','MarkerFaceColor','b','XDatasource','X_LLHGD(2,1)','YDataSource','X_LLHGD(1,1)');
    figgnd.orbit = plot(NaN,NaN,'.c','XDatasource','X_LLHGDstore(2,1:i)','YDatasource','X_LLHGDstore(1,1:i)');
    figgnd.trace = plot(NaN,NaN,'.m','LineWidth',2,'XDatasource','X_LLHGDtrace(2,1:i)','YDatasource','X_LLHGDtrace(1,1:i)');
end
%% 3D time solution

i = 1; % store index
timevec = t0:dt:t0+secs_per_day*days;
% preallocation for speed
X_ECIstore(6,length(timevec)) = 0;  % [x,y,z,vx,vy,vz]'
X_ECEFstore(3,length(timevec)) = 0; % [x,y,z]'
X_LLHGDstore(3,length(timevec)) = 0;% [lat,long,height]'
Obs(3,length(timevec)) = 0;         % [R,az,el]'
X_ECItrace(3,length(timevec)) = 0;  % [x,y,z]' viewed by gnd station    
X_LLHGDtrace(3,length(timevec)) = 0;% [lat,long,height]' viewed by gnd station 
 
for t = t0:dt:t0+secs_per_day*days
    
    % integrate to next time step
    Xnext = RungeKutta('J2statemodel',X_e,dt);
    
    % transform to ECI and store current timestep 
    X_ECI = equin2eci(X_e); % plot from 0?
    X_ECIstore(1:6,i) = X_ECI(1:6,1); 
    
    % transform to ECEF and store current timestep
    X_ECEF = eci2ecef(X_ECI(1:3,1),t); % only position
    X_ECEFstore(1:3,i) = X_ECEF;
    
    % transform to LLHGD
    X_LLHGD_rad = ecef2llhgd(X_ECEF(1:3,1));
    X_LLHGD     = [rad2deg(X_LLHGD_rad(1:2,1));X_LLHGD_rad(3,1)]; % degrees to plot
    X_LLHGDstore(1:3,i) = X_LLHGD;
    
    % Test if in view of Gnd Station
    Obs(1:3,i) = gndstation(X_ECEF,Gnd_LLH,Gnd_ECEF);
    if ~isnan(Obs(1:3,i))
        X_ECItrace(1:3,i) = X_ECIstore(1:3,i);
        X_LLHGDtrace(1:3,i) = X_LLHGDstore(1:3,i);
    else
        X_ECItrace(1:3,i) = [NaN;NaN;NaN];
        X_LLHGDtrace(1:3,i) = [NaN;NaN;NaN];
    end

    if Animation == 1
        % Update 3D sim
        refreshdata(figsim.sat,'caller');
        refreshdata(figsim.orbit,'caller');
        refreshdata(figsim.trace,'caller');

        rotate(figsim.globe,[0,0,1],360.*dt./(24*60*60),[0,0,0]);% continuous
        rotate(figsim.ECEFframe.Children,[0,0,1],360.*dt./(24*60*60),[0,0,0]);

        % Update Ground Trace
        refreshdata(figgnd.sat,'caller');
        refreshdata(figgnd.orbit,'caller');
        refreshdata(figgnd.trace,'caller');
        drawnow; 
    end
    i = i+1;
    X_e = Xnext;
end

%% Herrick-Gibbs

