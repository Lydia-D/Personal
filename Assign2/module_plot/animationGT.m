%% Set up Ground Trace simulation animation
% L Drabsch 4/4/16
% Adapted from Assign 1 for Assign 2

% Inputs: X_ECI = [x(t);y(t);z(t);...] ECI coordinates at time t
%         X_ECIstore = [x(t0:t);y(t0:t);z(t0:t);...] ECI coordinates for
%         all time
function figgnd = animationGT(X_LLHGD,X_LLHGDstore)
    global Nasa_R Nasa_A
    figure
    figgnd.map = geoshow(Nasa_A,Nasa_R);
    title('Ground Trace of Van Allen Probe')
    hold on
    figgnd.sat = plot(NaN,NaN,'bo','MarkerFaceColor','b','XDatasource','X_LLHGD(2,1)','YDataSource','X_LLHGD(1,1)');
    figgnd.orbit = plot(NaN,NaN,'.c','XDatasource','X_LLHGDstore(2,1:i)','YDatasource','X_LLHGDstore(1,1:i)');
end