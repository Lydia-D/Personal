%% Calculate ECEF and ECI coordinates of Sats from emperical data - Keplerian model
% By L Drabsch 11/4/16 (Adapted from A1_Q1)

% Parameters a,e,i,Rasc,omega
% a = semimajor axis = (ra+rp)/2
% e = eccentricity = (ra-rp)/(ra+rp)
% i = inclination angle- angle between orbit and earths equator
% Rasc = right ascension of the ascending node - vernal equinox and orbit
%           south-north crossing
% omega = Argument of perigee - north-south crossing and perigee from
%       orbital plane
% X = state vector 

clc
clear
close all
addpath('./module_conversion','./Data','./module_plot','./Subfns')
constants();

%% User Input
dt = 100; % seconds
Animations = 1;
StatePlots = 0;
days = 1;
equinox = 7347737.336;
%% Input data - use as fn?
%ClassPara =  [Rasc;omega;inc;a;e;M0,t0];        
load GPSsat_ephem
ClassPara = [deg2rad(Rasc)';deg2rad(omega)';deg2rad(inc)';a';e';deg2rad(M0)';t0']; % for all 31 sats

%% 3D Simulation Setup
if Animations == 1
   timestart = 0;
    animation3D();
%     animationGT();

end
%% 3D time solution

i = 1; % store index
timevec = 0:dt:0+secs_per_day*days;

    % calculate position for all time for each sat, store in multidim array
        [X_ECIstore,X_ECEFstore] = keplerorbit3D(ClassPara,timevec');


%% annimate in time
if Animations == 1
    for i = 1:1:length(timevec)
        for satindex = 1:1:length(SatNo)
            Sat = SatNo(satindex);
            eval(['refreshdata(figsim.Sat' num2str(Sat) '.sat,''caller'');'])
            text('Position',[coord_to(1,i)/Abs,coord_to(2,i)/Abs,coord_to(3,i)/Abs],'String',n(i),'color',c(i),'Parent',parent);

            eval(['refreshdata(figsim.Sat' num2str(Sat) '.orbit,''caller'');'])
        end
            rotate(figsim.globe,[0,0,1],360.*dt./(24*60*60),[0,0,0]);% continuous
            rotate(figsim.ECEFframe.Children,[0,0,1],360.*dt./(24*60*60),[0,0,0]);
            drawnow 
    end
%             refreshdata(figgnd.sat,'caller');
%             refreshdata(figgnd.orbit,'caller');
            
%             pause(0.1);
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
