%% Set up 3D simulation animation
% L Drabsch 4/4/16 edited 27/4/16
% Adapted from Assign 1 for Assign 2
% Note: set some camera angle? run as script?

% Inputs: X_ECI = [x(t);y(t);z(t);...] ECI coordinates at time t
%         X_ECIstore = [x(t0:t);y(t0:t);z(t0:t);...] ECI coordinates for
%         all time

    figsim.globe = Earthplot();
    grid on
    hold on

    T_ECI = (r_earth+6*10^6).*eye(4);

    % position of ECEF frame at t0 rel to ECI
    ECEFframe = ecef2eci(eye(3),timestart);
    T_ECEF = (r_earth+6*10^6).*[ECEFframe,[0;0;0];[0,0,0,1]];

    % plot ECI and ECEF axes
    figsim.ECIframe = hggroup;
    plotcoord(T_ECI,'k',figsim.ECIframe);
    figsim.ECEFframe = hggroup;
    plotcoord(T_ECEF,'r',figsim.ECEFframe);
