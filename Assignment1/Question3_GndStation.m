%% L Drabsch 16/3/16
% Question 3 simulation with grnd trace from gnd station
clc
clear
close all
addpath('./module_conversion','./module_testing','./scripts_general','./scripts_prelim','./Data','./module_plot','./Subfns')
constants();

%% User Input
dt = 100; % seconds
Animations = 1;
StatePlots = 0;
days = 2;

    Gnd_LLH = [deg2rad(2);deg2rad(-62);0];
    Gnd_ECEF = llhgd2ecef(Gnd_LLH);

%% Van Allen Probes NORAD ID: 38752 Constants
load VanAllenepoch1
        
%% 3D Simulation Setup
if Animation == 1
    load VanAllenAxes;
    figure(1)
    figsim.globe = Earthplot();
    figsim.axes = set(VanAllenAxes2);
    figsim.trace = plot3(NaN,NaN,NaN,'m','LineWidth',2,'XDatasource','X_ECItrace(1,:)','YDatasource','X_ECItrace(2,:)','ZDatasource','X_ECItrace(3,:)');
    figsim.orbit = plot3(NaN,NaN,NaN,'k','XDatasource','X_ECIstore(1,:)','YDatasource','X_ECIstore(2,:)','ZDatasource','X_ECIstore(3,:)');
    figsim.sat = scatter3(NaN,NaN,NaN,'filled','XDatasource','X_ECI(1,1)','YDataSource','X_ECI(2,1)','ZDataSource','X_ECI(3,1)');

    % corrdinate frame axes
    T_ECI = (r_earth+6*10^6).*eye(4);
    T_ECEF = (r_earth+6*10^6).*eye(4);
    figsim.ECIframe = hggroup;
    plotcoord(T_ECI,'k',figsim.ECIframe);
    figsim.ECEFframe = hggroup;
    plotcoord(T_ECEF,'r',figsim.ECEFframe);

    % Ground Trace Setup
    figure(2)
    figgnd.map = geoshow(Nasa_A,Nasa_R);
    hold on
    figgnd.sat = plot(NaN,NaN,'bo','MarkerFaceColor','b','XDatasource','X_LLHGC(2,1)','YDataSource','X_LLHGC(1,1)');
    figgnd.orbit = plot(NaN,NaN,'.c','XDatasource','X_LLHGCstore(2,:)','YDatasource','X_LLHGCstore(1,:)');
    figgnd.trace = plot(NaN,NaN,'-m','LineWidth',2,'XDatasource','X_LLHGCtrace(2,:)','YDatasource','X_LLHGCtrace(1,:)');
end
%% 3D time solution

i = 1; % store index

for t = 0:dt:24*60*60*days
        Mt = M0 + n*(t-t0);
        % solve kepler equation
        E_true = newtown(Mt,e);

        % solve for orbital parameters theta and r using true anomaly
        theta = 2*atan(sqrt(1+e)/sqrt(1-e)*tan(E_true/2));
%         thetastore(i) = theta;
        r = p/(1+e*cos(theta));
%         rstore(i) = r;

        % resolve in state space in the perifocal frame 
        % X = [x,y,z,vx,vy,vz]'
        X_orbit = [r*cos(theta);r*sin(theta);0;-sqrt(mu_earth/p)*sin(theta);sqrt(mu_earth/p)*(e-cos(theta));0];
        X_orbitstore(1:6,i) = X_orbit(1:6,1);
        
        % transform to ECI from orbit
        X_ECI = orbit2ECI(X_orbit,Rasc,inc,omega);
        X_ECIstore(1:6,i) = X_ECI(1:6,1);  % to plot orbit from beginning
        
        % transfrom to LLH from ECI
        X_ECEF = eci2ecef(X_ECI(1:3,1),t); % only position
        X_LLHGC = rad2deg(ecef2llhgc(X_ECEF));
        X_LLHGCstore(1:3,i) = X_LLHGC;
        
        % Test if in view of Gnd Station
        Obs(1:3,i) = gndstation(X_ECEF,Gnd_LLH,Gnd_ECEF);
        if ~isnan(Obs(1:3,i))
            X_ECItrace(1:3,i) = X_ECIstore(1:3,i);
            X_LLHGCtrace(1:3,i) = X_LLHGCstore(1:3,i);
        else
            X_ECItrace(1:3,i) = [NaN;NaN;NaN];
            X_LLHGCtrace(1:3,i) = [NaN;NaN;NaN];
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

end