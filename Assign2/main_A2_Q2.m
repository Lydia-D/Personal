%% Assign 2 Question 2 - Galileo
% L Drabsch
% Created 27/4/2016
clear
close all
addpath('./module_conversion','./Data','./module_plot','./Subfns')
% clc
constants();
dt = 500; % seconds
tduration = 0.5*secs_per_day;
animation = 0; 
%% Input data
% load GLONASS
load GLONASS_oper_new
[ClassPara,extra,t0epoch,SatText] = TLEinput(TLEdata);

% Select which satellites to use (all)
SatNo = 1:1:size(ClassPara,2); 
%% Simulate the orbits
Time_ref = datenum([2016 1 1 0 0 0]);
timestart = (datenum([2016 4 30 10 14 0])-Time_ref)*secs_per_day;        % today?

% T_equ = 7347737.336; % taken from previous year?
% T_equ = (30+29+19)*secs_per_day + 4*secs_per_hour + 30*secs_per_min; % ?? March 20th 2016 4.30UTC
T_equ = (datenum([2016 3 20 4 30 0])-Time_ref)*secs_per_day; % vernal equinox
timevec = timestart:dt:timestart+tduration;
[X_ECIstore,X_ECEFstore,X_LLHGCstore] = keplerorbit3D([ClassPara;t0epoch],timevec',T_equ);

if animation == 1
    % setup
   satcolour = SortOrbit(ClassPara,1); % group by Rasc
   animation3Dearth();
   animationGT();
   animation3D_sat_initial();
    
   animation_updates();

end
%% Optimisation
lat_vec = acos(2*linspace(1,0,50)-1)-pi/2;  % [-pi/2 to pi/2]
long_vec = 2*pi*linspace(0,1,70);
[GS_Lat,GS_Long] = meshgrid(lat_vec,long_vec);
obs_time(length(long_vec),length(lat_vec)) = 0;
obs_sats(length(long_vec),length(lat_vec)) = 0;

% initalise elevation data storage
el_store = zeros(length(long_vec),length(lat_vec),size(X_ECIstore,2),size(X_ECIstore,3));
el_store = logical(el_store); % make binary matrix

for lat_i = 1:1:length(lat_vec)
    for long_i = 1:1:length(long_vec)
        GS_LLH = [lat_vec(lat_i);long_vec(long_i);0];
        GS_ECEF = llhgc2ecef(GS_LLH);

         for Sat = 1:1:size(X_ECIstore,3)
            Sat_ECEF_local = X_ECIstore(:,:,Sat)-GS_ECEF*ones(1,length(timevec)); %all time - gs
            Sat_LG_cart = ecef2lg(Sat_ECEF_local,GS_LLH);
            Sat_LG_pol = cartesian2polar(Sat_LG_cart);
            
            % Store elevation data
            el_store(long_i,lat_i,:,Sat) = Sat_LG_pol(3,:)>=deg2rad(5);
            
            %obs_time(long_i,lat_i) = obs_time(long_i,lat_i) + sum(el_store(long_i,lat_i,:,Sat)); % number of observable points in time? for this sat

            if sum(Sat_LG_pol(3,:)>=deg2rad(5)) > 0
                obs_sats(long_i,lat_i) = obs_sats(long_i,lat_i)+1;
            end

         end
    end
end
timesum = sum(el_store_next,3);
satsum = sum(timesum,4);
%% choosing Ground Stations
% select location with maximum view time (antatica?)
% remove times it sees with the satellites, then replot areas it doesnt
% see?
[maxt.time,maxt.index] = max(satsum(:));
[GS.long,GS.lat]  = ind2sub(size(obs_time),maxt.index);

GS_LLH = [GS.lat;GS.long;0];
GS_ECEF = llhgc2ecef(GS_LLH);

Seen = el_store(GS.long,GS.lat,:,:);
Unseen = ~Seen;
el_store_next = el_store; % initalise size
for lat_i = 1:1:length(lat_vec)
    for long_i = 1:1:length(long_vec)
        % at a point in space test if unseen through all time for all
        % satellites
        el_store_next(long_i,lat_i,:,:) = el_store(long_i,lat_i,:,:) & Unseen;  
    end
end
% sum through time for each location and sat
timesum = sum(el_store_next,3);
satsum = sum(timesum,4);
figure
mesh(rad2deg(GS_Lat),rad2deg(GS_Long),squeeze(satsum))

%% select next max
[maxt.time(2),maxt.index(2)] = max(satsum(:));
[GS.long(2),GS.lat(2)]  = ind2sub(size(satsum),maxt.index(2));

%%
figure
PlotSphereIntensity(rad2deg(GS_Lat),rad2deg(GS_Long),obs_time)
figure
mesh(rad2deg(GS_Lat),rad2deg(GS_Long),obs_time)
% brighten(copper,0.5)
xlabel('Latitude')
ylabel('Longitude')
%%
figure
PlotSphereIntensity(rad2deg(GS_Lat),rad2deg(GS_Long),obs_sats)
%%
figure
mesh(rad2deg(GS_Lat),rad2deg(GS_Long),obs_sats)
% obs_time
% obs_sats


    
