%% Question 1 Part 2
% L Drabsch
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
colours = [0.75 0.06 1;...  % magenta
           0.06 0.93 1;...
           0.06 1 0.1;...
           1   0.01 0.01;...
           1 0.85 0.06;...
           0.6 0.3 0.2;...
           0.35 0.63 0.93;...
           0.5 0.1 0.9;...
           0.9 0.5 0.2;...
           0.9 0.01 0.6;...
           0.1 0.1 1;...  % magenta
           0.5 0.93 1;...
           0.06 1 .6;...
           1   0.7 0.01;...
           0.1 0.85 0.06;...
           0.6 0.3 0.9;...
           0.35 0.01 0.93;...
           0.5 0.5 0.9;...
           0.3 0.5 0.2;...
           0.0 0.01 0.6;...
           0.75 0.06 0.5;...  % magenta
           0.06 0.93 0.5;...
           0.06 0 0.1;...
           04   0.71 0.01;...
           0.5 0.85 0.06;...
           0.25 0.3 0.2;...
           0.35 0.23 0.93;...
           0.5 0.0 0.6;...
           0.9 0.05 0.2;...
           0.7 0.01 0.6;...
           0.9 0.6 0.6;...
           ];
%% Identify sat data
% ideaA: function that takes in time and vector of satellite numbers and
% outputs PosSat = [xrow;yrow;zrow] only for the sats in range then loop
% through time 
%   - is there a way to vectorise in time? or use previous location as inital guess
%   - need inital data processing, go from txt file?

% ideaB: have sats that arent in range filled with NaN?

%% gather data 
GPS_pseudorange_F2 = dlmread('GPS_pseudorange_F2.txt');
F2_time = GPS_pseudorange_F2(:,1);
F2_sat = GPS_pseudorange_F2(:,2);   % what satellites are observed
F2_R = GPS_pseudorange_F2(:,3);     % range of satellites 

UAVPosition_F2 = dlmread('UAVPosition_F2.txt');
UAV_time = UAVPosition_F2(:,1);
UAV_N = UAVPosition_F2(:,2);   % what satellites are observed
UAV_E = UAVPosition_F2(:,3);     % range of satellites 
UAV_D = UAVPosition_F2(:,4); 

load GPSsat_ephem
ClassPara = [deg2rad(Rasc)';deg2rad(omega)';deg2rad(inc)';a';e';deg2rad(M0)';t0']; % for all 31 sats



%% isolate different times
% have row vector of single times Timevec
% have matrix of obervable sats, row = time , columns of sat numbers 
startindex = 1;
i = 1;
while startindex <= length(F2_time)
    index = F2_time == F2_time(startindex);
    Timevec(1,i) = F2_time(startindex);
    Observables(1:length(F2_sat(index)),i) = F2_sat(index);
    Ranges(1:length(F2_sat(index)),i) = F2_R(index);
    startindex = startindex+length(index(index));
    i = i+1;
end

SatObs = Satextract(Observables,Ranges,31,Timevec,colours);

T_equ = 7347737.336;        % equinox time
Timevec_eq = Timevec - T_equ;
% Timevec_eq = Timevec - Timevec(1);
timestart = Timevec_eq(1);
% animation3D();

% Positions for all satellites for all time
[X_ECIstore,X_ECEFstore,X_LLHGC] = keplerorbit3D(ClassPara,Timevec',T_equ);

% use NLLS for each time step to calculate ECEF coords of UAC
GndStation_LLH = [deg2rad(-34.76);deg2rad(150.03);680];
GndStation_ECEF =  llhgc2ecef(GndStation_LLH);
GuessLoc = [GndStation_ECEF;0]; % use gnd station location as guess of location

% Sat_Loc_LG = zeros(size(X_ECEFstore)); % initialise;
figpol.base = PolarPlot();

% for tindex = 1:1:length(Timevec_eq)
%     % remove trailing zeros
%     Obs_t = Observables(:,tindex);
%     Obs_t = Obs_t(Obs_t~=0);        % satellites that are observable now
%     Range_t = Ranges(:,tindex);
%     Range_t = Range_t(Range_t~=0);
%      if length(Obs_t)<=3
%          UAV_ECEF_global(1:4,tindex) = [NaN;NaN;NaN;NaN];
%          UAV_ECEF_local(1:3,tindex)  = [NaN;NaN;NaN];
%          UAV_LG_cart(1:3,tindex)     = [NaN;NaN;NaN];
%          DOP(1:5,tindex)             = [NaN;NaN;NaN;NaN;NaN];
%          clockbias(1,tindex)         = NaN;
%      else
%         % only look at position of sats for this point in time for the
%         % observable satellites
%         X_ECEF = squeeze(X_ECEFstore(:,tindex,Obs_t));
%         X_ECI = squeeze(X_ECIstore(1:3,tindex,Obs_t));
% 
%         % NLLS (with clock bias)
%         [UAV_ECEF_global(1:4,tindex),DOP(1:5,tindex),clockbias(1,tindex)] = convergance(GuessLoc,X_ECEF,Range_t);
% 
%         UAV_ECEF_local(1:3,tindex) = UAV_ECEF_global(1:3,tindex) - GndStation_ECEF;
%         UAV_LG_cart(1:3,tindex) = ecef2lg(UAV_ECEF_local(1:3,tindex),GndStation_LLH);
% 
%         GuessLoc = [UAV_ECEF_global(1:3,tindex);0]; % use previous timestep for guess of next location
% 
%         SatLoc_ECEF_local = X_ECEF - GndStation_ECEF*ones(1,size(X_ECEF,2));
%         Sat_Loc_LG = cartesian2polar(ecef2lg(SatLoc_ECEF_local,GndStation_LLH));
% 
%         figure(figpol.base)
%         [Sat_Locplot.x,Sat_Locplot.y] = polar2plot(Sat_Loc_LG(2,:),Sat_Loc_LG(3,:));
% 
% 
%         for p = 1:1:length(Sat_Locplot.x)
%             plot(Sat_Locplot.x(p),Sat_Locplot.y(p),'o','Color' ,colours(Obs_t(p),:))
% 
%             if tindex == 1 
%                 text(Sat_Locplot.x(p)+0.03,Sat_Locplot.y(p),num2str(Obs_t(p)),'Color',colours(Obs_t(p),:),'FontSize',12)
%                 done = Obs_t;
%             elseif sum(Obs_t(p)==done) == 0
%                 text(Sat_Locplot.x(p)+0.03,Sat_Locplot.y(p),num2str(Obs_t(p)),'Color',colours(Obs_t(p),:),'FontSize',12)
%                 done = [done; Obs_t(p)];
%             end
%         end
%      end
% end

UAVanalysis


%% Plot cartesian 
figure;
plot3(UAV_LG_cart(1,:),UAV_LG_cart(2,:),UAV_LG_cart(3,:))
grid on
hold on
plot3(UAV_N,UAV_E,UAV_D,'--k')
legend('Measured','True')
title('UAV trace in NED coordinates at the ground station')
xlabel('N')
ylabel('E')
zlabel('D')
%% polar plots

UAV_LG_cart = ecef2lg(UAV_ECEF_local,GndStation_LLH);
UAV_LG_pol = cartesian2polar(UAV_LG_cart);

figure(figpol.base)
[UAVtrack.x,UAVtrack.y] = polar2plot(UAV_LG_pol(2,:),UAV_LG_pol(3,:));
figure(figpol.base)
plot(UAVtrack.x,UAVtrack.y)

%% DOPS
figure
plot(Timevec,DOP(5,:))
% plot(Timevec,clockbias)

numsats = sum(Observables>0,1);

%% Identify error: limit crazy dynamics of UAV - use UAV_LG_cart - instantanous
dyn = errorDetect(UAV_LG_cart,Timevec);

DOPerror.ind = find(DOP(1,:)>500);

% for error_i = 1:1:length(dyn.erroridx)
%     Obs_t = Observables(:,dyn.erroridx(error_i));
%     Obs_t = Obs_t(Obs_t~=0); 
%     
%     % look for discontinuities in the psudorange for each observed sat 
% end


%% Error correction
% assume that one satellite is wrong?
% check if any point in time has less than 4 satellites (dont use al all)

% plot psudorange with time
% plot(
testobs
UAVanalysis

