%% Set up 3D simulation animation
% L Drabsch 4/4/16
% Adapted from Assign 1 for Assign 2
% Note: set some camera angle? run as script?

% Inputs: X_ECI = [x(t);y(t);z(t);...] ECI coordinates at time t
%         X_ECIstore = [x(t0:t);y(t0:t);z(t0:t);...] ECI coordinates for
%         all time
% function figsim = animation3D(X_ECI,X_ECIstore)

    figsim.globe = Earthplot();
    grid on
    hold on
    %figsim.axes = set(VanAllenAxes);
%     eval(['figsim.sat = scatter3(NaN,NaN,NaN,''filled'',''XDatasource'',''' X_ECI(1,1) ''',''YDataSource'',''' X_ECI(2,1) ''',''ZDataSource'',''' X_ECI(3,1) ''');'])
%     eval(['figsim.orbit = plot3(NaN,NaN,NaN,''k'',''XDatasource'',''' X_ECIstore(1,:) ''',''YDatasource'',''' X_ECIstore(2,:) ''',''ZDatasource'',''' X_ECIstore(3,:) ''');'])
    
% setup each satellite
    for satindex = 1:1:length(SatNo)
        Sat = SatNo(satindex);
        eval(['figsim.Sat' num2str(Sat) '.sat = scatter3(NaN,NaN,NaN,''filled'',''XDatasource'',''X_ECIstore(1,i,Sat)'',''YDataSource'',''X_ECIstore(2,i,Sat)'',''ZDataSource'',''X_ECIstore(3,i,Sat)'');'])
        eval(['figsim.Sat' num2str(Sat) '.orbit = plot3(NaN,NaN,NaN,''k'',''XDatasource'',''X_ECIstore(1,1:i,Sat)'',''YDatasource'',''X_ECIstore(2,1:i,Sat)'',''ZDatasource'',''X_ECIstore(3,1:i,Sat)'');'])
    end

    T_ECI = (r_earth+6*10^6).*eye(4);

    % position of ECEF frame at t0 rel to ECI
    ECEFframe = ecef2eci(eye(3),timestart);
    T_ECEF = (r_earth+6*10^6).*[ECEFframe,[0;0;0];[0,0,0,1]];

    % plot ECI and ECEF axes
    figsim.ECIframe = hggroup;
    plotcoord(T_ECI,'k',figsim.ECIframe);
    figsim.ECEFframe = hggroup;
    plotcoord(T_ECEF,'r',figsim.ECEFframe);


% end