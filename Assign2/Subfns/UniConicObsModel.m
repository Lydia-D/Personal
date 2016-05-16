function [ YModel, H ] = UniConicObsModel(X0, nReadings, tDiff, mu, GS_LG_cart, GS_ECEF, tSinceVE, tol)

%% Universal conic section model solution for X0
[ X_CSModel,a,f,fDot,g,gDot ] = UniConic(X0, tDiff, mu, tol);

nObs = length(tDiff);

%% Sensor model measurement
YModel(nObs*nReadings,1) = 0;   % Initilise

% Convert to polar and turn everything into column vector
YModel(:) = cartesian2polar(bsxfun(@minus, ...
     ecef2lg(eci2ecef(X_CSModel(1:3,:), tSinceVE), GS_LG_cart), ...
     ecef2lg(GS_ECEF, GS_LG_cart)));

% Range measurement in [x,y,z]
RangeECI    = X_CSModel(1:3,:) - ecef2eci(GS_ECEF, tSinceVE);       % ECI
RangeLGV    = ecef2lg(eci2ecef(RangeECI, tSinceVE), GS_LG_cart);    % LGV

% Range magnitude
RangeMag    = sqrt(sum(RangeECI.^2));

%% Extract data for Jacobian construction
H(nObs*nReadings, 6) = 0;               % Initialise Jacobian

% Indices to fill up Jacobian
rStart  = 1:nReadings:nObs*nReadings;       % Start of each measurement
rEnd    = [rStart(2:end)-1 nObs*nReadings]; % End of each measurement

%% Construct Jacobian
for i = 1:nObs
    % Find dX/dX0 = PHI (6 x 6) for each time step
    dXdX0   = GetPHI(X_CSModel(:,i), X0, a, tDiff(i), ...
                mu, f(i), fDot(i), g(i), gDot(i));
            
	% Find sensor model derivative (3 x 6) for each time step
    dYdX    = RAzElSensor(RangeLGV(:,i), RangeMag(i), GS_LG_cart(:,i), tSinceVE(i));
    
    % Place in Jacobian
    H(rStart(i):rEnd(i),:) = dYdX * dXdX0;
end

end