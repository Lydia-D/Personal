%% L Drabsch 16/3/16
% Question 3 simulation with grnd trace from gnd station
clc
clear
close all
addpath('./module_conversion','./module_testing','./scripts_general','./scripts_prelim','./Data','./module_plot','./Subfns')
constants();

%% User Input
dt = 100; % seconds
Animation = 0;
StatePlots = 1;
days = 1;

% Ground station position
Gnd_LLH = [deg2rad(39.10);deg2rad(-76.53);140]; %http://www.sscspace.com/south-point-satellite-station-4
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
Obs(4,length(timevec)) = 0;         % [R,az,el]'
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
    Obs(1:3,i) = gndstation(X_ECEF,Gnd_LLH,Gnd_ECEF,deg2rad(10));
    Obs(4,i) = timevec(i);
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

% delete out of sight observations
OutOfSight = any(isnan(Obs),1);
Obs(:,OutOfSight) = []; 

%% Max elevation and percentage of time
MaxEl = max(Obs(3,:));
PerTime = size(Obs,2)./length(timevec)*100;
fprintf('The maximum elevation was %.2f deg\nand the percentage of time the satellite was in view was %2.f percent\n',rad2deg(MaxEl),PerTime);

%% No noise
HG_determine_disp(Obs(1:3,1:3),Obs(4,1:3),Gnd_LLH);

%% Herrick-Gibbs
% Obs = [R,az,el,t]

% add gaussian white noise
NoisyObs(4,:) = Obs(4,:); % any error on time?
SNR = [3:1:40];  % signal to noise ratios dB
NumSamples = 50;  % take 50 sets of measurements per noise ratio
DiffSamples = [0,7,18]; % wait 5*dt and 10*dt before next observation

% preallocate vector of classical elements calculated from HG
X_class_noise(1:6,NumSamples) = 0; 
Emean(6,length(SNR)) = 0;
Estd(6,length(SNR)) = 0;


% last possible valid measurement 10 from end
for j = 1:1:length(SNR)
    RandSet = randi(length(Obs)-20,[1,NumSamples]);  
    NoisyObs(1,:) = awgn(Obs(1,:),SNR(j));
    NoisyObs(2:3,:) = awgn(Obs(2:3,:),SNR(j));
    for i = 1:1:NumSamples
        X_class_noise(1:6,i) = HG_determine(NoisyObs(1:3,RandSet(i)+DiffSamples),NoisyObs(4,RandSet(i):RandSet(i)+2),Gnd_LLH);
    end
        Error = abs(X_class_noise - X_c*ones(1,NumSamples));
        Emean(1:6,j) = mean(X_class_noise,2);
        Estd(1:6,j) = std(X_class_noise');
end

% X_c: vector of classical elements with true values, loaded from VanAllenepoch1

FigNoiseErrors = figure(3);
Stateplot(Emean,SNR,FigNoiseErrors.Number,{'Rasc','omega','inc','a','e','theta'},{'degrees','degrees','degrees','m','','degrees'},'x',{})



% figure(3)
% clf
% plot(Obs(4,:),Obs(2:3,:),'b')
% hold on
% plot(NoisyObs(4,:),NoisyObs(2:3,:),'r')
