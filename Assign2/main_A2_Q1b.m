%% Question 1 Part 2
% position trajectory of UAV
% Data: GPSsat_ephem - orbital parameters of satellites
%       GPS_pseudorange_F1 - logged data of UAV as [time,SatNo,Psrange] in
%                           (s, #, m) no errors or clock bias
%       UAVPosition_F1 - true position relative to Gnd station

% To Do:
%       Trajectory wrt ground station
%    done       - divide up data in time sections?
%    done       - identify which satellite to which data
%    done       - ECEF coords of satellites at time t
%    done            - take emperical parameters and time t to output ECEF
%                    coords (Part A)
%                    - start with keplerian model, maybe do J2 model?
%    done   - use NLLS to calculate [x,y,z] ECEF coordinates of UAV
%           - convert ECEF to LGCV 
%           - plot polar 
%           - compare with UAVPosition_F1
clear
close all
addpath('./module_conversion','./Data','./module_plot','./Subfns')
clc
constants();

%% Identify sat data
% ideaA: function that takes in time and vector of satellite numbers and
% outputs PosSat = [xrow;yrow;zrow] only for the sats in range then loop
% through time 
%   - is there a way to vectorise in time? or use previous location as inital guess
%   - need inital data processing, go from txt file?

% ideaB: have sats that arent in range filled with NaN?

%% gather data 
GPS_pseudorange_F1 = dlmread('GPS_pseudorange_F1.txt');
F1_time = GPS_pseudorange_F1(:,1);
F1_sat = GPS_pseudorange_F1(:,2);   % what satellites are observed
F1_R = GPS_pseudorange_F1(:,3);     % range of satellites 

load GPSsat_ephem
ClassPara = [deg2rad(Rasc)';deg2rad(omega)';deg2rad(inc)';a';e';deg2rad(M0)';t0']; % for all 31 sats



%% isolate different times
% have row vector of single times Timevec
% have matrix of obervable sats, row = time , columns of sat numbers 
startindex = 1;
i = 1;
while startindex <= length(F1_time)
    index = F1_time == F1_time(startindex);
    Timevec(1,i) = F1_time(startindex);
    Observables(1:length(F1_sat(index)),i) = F1_sat(index);
    Ranges(1:length(F1_sat(index)),i) = F1_R(index);
    startindex = startindex+length(index(index));
    i = i+1;
end
T_equ = 7347737.336;        % equinox time
Timevec_eq = Timevec - T_equ;
% Timevec_eq = Timevec - Timevec(1);
timestart = Timevec_eq(1);
animation3D();

% Positions for all satellites for all time
[X_ECIstore,X_ECEFstore] = keplerorbit3D(ClassPara,Timevec',T_equ);

% use NLLS for each time step to calculate ECEF coords of UAC
GndStation_LLH = [deg2rad(-34.76);deg2rad(150.03);680];
GndStation_ECEF =  llhgc2ecef(GndStation_LLH);
% GuessLoc = GndStation_ECEF; % use gnd station location as guess of location
GuessLoc = [ecef2eci(GndStation_ECEF,Timevec_eq(1));0]; % clock bias
%GuessLoc = [0;0;0;0];
for tindex = 1:1:length(Timevec_eq)
    % remove trailing zeros
    Obs_t = Observables(:,tindex);
    Obs_t = Obs_t(Obs_t~=0);        % satellites that are observable now
    Range_t = Ranges(:,tindex);
    Range_t = Range_t(Range_t~=0);
    
    % only look at position of sats for this point in time for the
    % observable satellites
    X_ECEF = squeeze(X_ECEFstore(:,tindex,Obs_t));
    X_ECI = squeeze(X_ECIstore(1:3,tindex,Obs_t));
    
%     X_ECEF = reshape(X_ECEFstore(:,tindex,Obs_t),[3,length(Obs_t)]);
%     X_ECI = reshape(X_ECIstore(1:3,tindex,Obs_t),[3,length(Obs_t)]);

    
    %     for obsindex = 1:1:length(Obs_t)
%         scatter3(X_ECI(1,obsindex),X_ECI(2,obsindex),X_ECI(3,obsindex))
%     end
%     GndStation_ECI(:,tindex) = ecef2eci(GndStation_ECEF,Timevec_eq(tindex));
%     scatter3(GndStation_ECI(1,tindex),GndStation_ECI(2,tindex),GndStation_ECI(3,tindex),'filled')
%     drawnow;
    
    % NLLS (with clock bias)
    UAV_ECEF_global(1:4,tindex) = convergance(GuessLoc,X_ECEF,Range_t);
    UAV_ECEF_local(1:3,tindex) = UAV_ECEF_global(1:3,tindex) - GndStation_ECEF;
    UAV_LG_cart(1:3,tindex) = ecef2lg(UAV_ECEF_local(1:3,tindex),GndStation_LLH);

%     UAV_ECI_global(1:3,tindex) = convergance(GuessLoc,X_ECI,Range_t);
%     UAV_ECI_global = ecef2eci(UAV_ECEF_global,Timevec_eq(tindex));
%     scatter3(UAV_ECI_global(1,tindex),UAV_ECI_global(2,tindex),UAV_ECI_global(3,tindex),'x')
%     GuessLoc = UAV_ECEF_global(1:3,tindex); % use previous timestep for guess of next location
end

%% Plot cartesian 
figure;
plot3(UAV_LG_cart(1,:),UAV_LG_cart(2,:),UAV_LG_cart(3,:))


%% polar plots


% UAV_ECI_local = UAV_ECI_global - GndStation_ECI*ones(1,size(UAV_ECEF_global,2));
% UAV_ECI_local = UAV_ECI_global - GndStation_ECI;

% UAV_ECEF_local = eci2ecef(UAV_ECI_local,Timevec_eq);
UAV_LG_cart = ecef2lg(UAV_ECEF_local,GndStation_LLH);
UAV_LG_pol = cartesian2polar(UAV_LG_cart);

angle = UAV_LG_pol(2,:);
radius = UAV_LG_pol(1,:).*cos(UAV_LG_pol(3,:));
figure
figpol.UAVtrack = polar(rad2deg(angle),radius);




