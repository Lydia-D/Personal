%% Assign 2 Question 2 - Galileo
% L Drabsch
% Created 27/4/2016
clear
close all
addpath('./module_conversion','./Data','./module_plot','./Subfns')
% clc
constants();
dt = 100; % seconds
tduration = 1*secs_per_day;
animation = 0; 
% set as 1 if you want to re-define all satellite obervations over earth
GSelevationdata = 0; % takes a while for high resolution
GSoptimise = 0;
%% Input data
% load GLONASS
load GLONASS_oper_new
[ClassPara,extra,t0epoch,SatText] = TLEinput(TLEdata);

% Select which satellites to use (all)
SatNo = 1:1:size(ClassPara,2); 
%% Simulate the orbits
Time_ref = datenum([2016 1 1 0 0 0]);
timestart = (datenum([2016 4 30 10 14 0])-Time_ref)*secs_per_day;        % today?

colours = 'rgbcmy'; % will throw an error if more than 6 colours required?


% T_equ = 7347737.336; % taken from previous year?
% T_equ = (30+29+19)*secs_per_day + 4*secs_per_hour + 30*secs_per_min; % ?? March 20th 2016 4.30UTC
global T_equ
T_equ = (datenum([2016 3 20 4 30 0])-Time_ref)*secs_per_day; % vernal equinox
timevec = timestart:dt:timestart+tduration;
[X_ECIstore,X_ECEFstore,X_LLHGCstore] = keplerorbit3D([ClassPara;t0epoch],timevec',T_equ);
satcolour = SortOrbit(ClassPara,1); % group by Rasc
if animation == 1
    % setup
   
   animation3Dearth();
   animationGT();
   animation3D_sat_initial();
    
   animation_updates();
else
    animation3Dearth();
   animationGT();
   for satindex = 1:1:size(ClassPara,2)
    Sat = SatNo(satindex);
   figure(figsim.globe)
    %eval(['Sattext.Sat' num2str(Sat) '.ECI.text= text(NaN,NaN,NaN,''' num2str(SatText(Sat)) ''',''Color'', ''' colours(satcolour(Sat))  ''');'])
    eval(['figsim.Sat' num2str(Sat) '.ECI.orbit = plot3(X_ECIstore(1,:,Sat),X_ECIstore(2,:,Sat),X_ECIstore(3,:,Sat),''' colours(satcolour(Sat)) ''');'])
    eval(['figsim.Sat' num2str(Sat) '.ECI.sat = scatter3(X_ECIstore(1,1,Sat),X_ECIstore(2,1,Sat),X_ECIstore(3,1,Sat),''filled'',''MarkerFaceColor'',''k'');'])

    % ECEF
    figure(figsim.globe2)
    %eval(['Sattext.Sat' num2str(Sat) '.ECEF.text= text(NaN,NaN,NaN,''' num2str(SatText(Sat)) ''',''Color'', ''' colours(satcolour(Sat))  ''');'])
    eval(['figsim.Sat' num2str(Sat) '.ECEF.orbit = plot3(X_ECEFstore(1,:,Sat),X_ECEFstore(2,:,Sat),X_ECEFstore(3,:,Sat),''' colours(satcolour(Sat))  ''');'])
    eval(['figsim.Sat' num2str(Sat) '.ECEF.sat = scatter3(X_ECEFstore(1,1,Sat),X_ECEFstore(2,1,Sat),X_ECEFstore(3,1,Sat),''filled'',''MarkerFaceColor'',''k'');'])

    
    figure(figgnd.handle)
    eval(['figgnd.Sat' num2str(Sat) '.orbit = plot(X_LLHGCstore(2,:,Sat),X_LLHGCstore(1,:,Sat),''.' colours(satcolour(Sat)) ''');'])
    %5eval(['Gndtext.Sat' num2str(Sat) '= text(NaN,NaN,''' num2str(SatText(Sat)) ''',''Color'', ''' colours(satcolour(Sat))  ''');'])
    end
end
%% Optimisation
    lat_res = 100;
    long_res = 200;
    lat_vec = acos(2*linspace(1,0,lat_res)-1)-pi/2;  % [-pi/2 to pi/2]
    long_vec = 2*pi*linspace(0,1,long_res);
    [GS_Lat,GS_Long] = meshgrid(lat_vec,long_vec);

if GSelevationdata == 1
    % initalise elevation data storage
    el_store = zeros(long_res,lat_res,size(X_ECIstore,2),size(X_ECIstore,3));
    el_store = logical(el_store); % make binary matrix

    wb = waitbar(0,'Percentage Done Observing Sats');

    % altitude at current lat,long
    alt = ITU_P1511(r2d*GS_Lat,r2d*GS_Long)*1000;

    for lat_i = 1:1:lat_res
        for long_i = 1:1:long_res

        % remove observations that are over water using 'landmask' by Chad
        % Greene (2014).  
        if (landmask(r2d*(lat_vec(lat_i)),r2d*wrapToPi(long_vec(long_i)))) || r2d*lat_vec(lat_i) == -90

            GS_LLH = [lat_vec(lat_i);long_vec(long_i);alt(long_i,lat_i)];
            GS_ECEF = llhgc2ecef(GS_LLH);

             for Sat = 1:1:size(X_ECEFstore,3)
                Sat_ECEF_local = X_ECEFstore(:,:,Sat)-GS_ECEF*ones(1,length(timevec)); %all time - gs
                Sat_LG_cart = ecef2lg(Sat_ECEF_local,GS_LLH);
                Sat_LG_pol = cartesian2polar(Sat_LG_cart);

                % Store elevation data
                el_store(long_i,lat_i,:,Sat) = Sat_LG_pol(3,:)>=d2r*(5);

             end
        end 
        end
        waitbar(lat_i/lat_res); 
    end
    close(wb);
    el_store_initial = el_store;
else 
%     load GSelevation_crude_no90 
    load GSLocations_fine_inc90 
    el_store = el_store_initial;
end
%% Optimise ground station locations
if GSoptimise == 1
    el_store = el_store_initial;
    GS.long = NaN;
    GS.lat = NaN; % initalise

    [el_store,GS] = optimise(el_store,GS,GS_Lat,GS_Long);
else
%     load GScrudeECEFinc90
    load GSLocations_fine_inc90
end


%% Plot ground station on earth
animationGT;
GS.long = GS.long(~isnan(GS.long)); % remove inital NaN
GS.lat = GS.lat(~isnan(GS.lat));
GS.Label = 1:1:length(GS.lat);
GS.longplot = r2d*wrapToPi(long_vec(GS.long));
GS.latplot = r2d*lat_vec(GS.lat);
GS.alt = ITU_P1511(GS.latplot,GS.longplot)*1000;
plot(GS.longplot,GS.latplot,'rx')
title('Optimised ground station locations for GLONASS (23 operational satellites)')
ylabel('Latitude (degrees)')
xlabel('Longitude (degreees)')
for i = 1:1:length(GS.lat)
    text(GS.longplot(i)+5,GS.latplot(i),num2str(GS.Label(i)),'color','r','FontSize',15,'VerticalAlignment','middle')
end
%% Simulate reading from satellites from ground stations
polarplots = 0;
NumGS = length(GS.long);
% GS.names = [{'Antarctica'};{'Norway'};{'Hawaii'};{'Kenya'};{'Brazi'};{'China'}];
Sat_LG_pol = zeros(size(X_ECIstore));
if polarplots == 1;
    for gs_i = 1:1:NumGS
        GS_LLH = [d2r*GS.latplot(gs_i);d2r*GS.longplot(gs_i);GS.alt(gs_i)];
        GS_ECEF = llhgc2ecef(GS_LLH);
        eval(['figpol.GS' num2str(gs_i) ' = PolarPlotVisual(gs_i);'])
        hold all
        for t = 1:1:size(X_ECIstore,2)
            Sat_ECEF_local = squeeze(X_ECEFstore(:,t,:))-GS_ECEF*ones(1,SatNo(end)); %all time - gs
            Sat_LG_cart = ecef2lg(Sat_ECEF_local,GS_LLH);
            Sat_LG_pol_all = cartesian2polar(Sat_LG_cart);
            Sat_LG_pol_all(:,Sat_LG_pol_all(3,:)<d2r*5) = NaN;
            Sat_LG_pol(1:3,t,:) = Sat_LG_pol_all;   % 5 deg mask
            [x,y]=polar2plot(Sat_LG_pol(2,:,:),Sat_LG_pol(3,:,:));
        end
           plot(squeeze(x),squeeze(y),'.')
    %        title('hi')
    %        eval(['title(''' char(GS.names(gs_i,:)) ''')'])%         text(x(1,end,:),y(1,end,:),'test')

    %     [x,y]=polar2plot(Sat_LG_pol(2,:,:),Sat_LG_pol(3,:,:));
    %     plot(x,y,'o')
    end
end
%% Add noise here
    
    
    
%% Herrick Gibbs Method (24 hr period) just one satellite (Sat 1)
figranges = figure;
figpolarplots = figure;
colours = 'rgbmck';

for Sat = 1
polarplots = 1;
for gs_i = 1:1:NumGS
    GS_LLH = [d2r*GS.latplot(gs_i);d2r*GS.longplot(gs_i);GS.alt(gs_i)];
    GS_ECEF = llhgc2ecef(GS_LLH);

        Sat_ECEF_local = squeeze(X_ECEFstore(:,:,Sat))-GS_ECEF*ones(1,length(timevec)); %all time - gs
        Sat_LG_cart = ecef2lg(Sat_ECEF_local,GS_LLH);
        Sat_LG_pol = cartesian2polar(Sat_LG_cart);
        Sat_LG_pol(:,Sat_LG_pol(3,:)<d2r*5) = NaN;
        Sat_LG_polstore(:,:,gs_i) = Sat_LG_pol;
        [x,y]=polar2plot(Sat_LG_pol(2,:),Sat_LG_pol(3,:));
     if polarplots == 1;
         figure(figpolarplots);
          subplot(NumGS/2,2,gs_i); eval(['figpol.GS' num2str(gs_i) ' = PolarPlotVisual(0);'])
          hold all
          plot(x,y,colours(gs_i),'LineWidth',1.5)
     end   
         
         % take first 3 non NaN observations
         obs_index = find(~isnan(Sat_LG_pol(3,:)),3);
          
         Sat_Obs_3 = Sat_LG_pol(1:3,obs_index);
         Sat_time = timevec(obs_index);
         
         X(1:6,gs_i) = HG_determine(Sat_Obs_3,Sat_time, GS_LLH);
         
%         text(x(1,end,:),y(1,end,:),'test')
        figure(figranges);
%         subplot(NumGS,1,gs_i); plot(timevec,Sat_LG_polstore(1,:,gs_i))
        subplot(SatNo(end),1,Sat); plot(timevec,Sat_LG_polstore(1,:,gs_i),colours(gs_i),'LineWidth',1.5)
        hold on
        xlim([timevec(1) timevec(end)])
        set(gca,'ytick',[])
        ylabel(num2str(Sat))
        if Sat ~= SatNo(end)
            set(gca,'xtick',[])
        end
%     [x,y]=polar2plot(Sat_LG_pol(2,:,:),Sat_LG_pol(3,:,:));
%     plot(x,y,'o')
end
end

legend('GS1','GS2','GS3','GS4','GS5','GS6','Location','WestOutside')

%% plot sat gnd station tracking
% get observation r and rdot
% calculate a
% All observations -> Sat_LG_pol  (NaN if el<5deg)
% take one pass form one GS

gs_i = 1;
GS_LLH = [GS.latplot(gs_i);GS.longplot(gs_i);GS.alt(gs_i)];
% loop through each ground station? or loop through time?

CC = regionprops(~isnan(Sat_LG_polstore(1,:,gs_i)),'PixelIdxList');
% Index_obs = cat(2,CC.PixelIdxList);   % columns of sets of observations as time indicies from Sat_LG_pol
Index_obs = CC.PixelIdxList; % first set
% NoPasses? is this important? or still just 

% Sat_Obs = Sat_LG_polstore(1:3,Index_obs(:,1),gs_i); % just first pass?

% get three observations
% use middle R0, middle t0
[ClassParaGuess,V2_ECI,R2_ECI] = HG_determine(Sat_LG_polstore(1:3,Index_obs(1:3,1),gs_i),timevec(Index_obs(1:3,1)), GS_LLH);
    
[R2_ECI_best,V2_ECI_best] = NLLSQ2(R2_ECI,V2_ECI,timevec,Index_obs,GS_LLH,Sat_LG_polstore(:,Index_obs,gs_i))

% use best to convert to orbital parameter
% simulate orbit
    