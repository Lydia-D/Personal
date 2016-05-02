%% Universial conic method
% L Drabsch
% 1/5/16
% Inputs -> X0 = [r(t0);rdot(t0)];
%           timevec = time vector of whole simulation?
% Output -> Xout = position;velocity in ECI frame for all simulation time
function [XOut,a,f,fDot,g,gDot] = UniConic(X0, timevec)

global mu_earth

% Extract data
rMag0       = norm(X0(1:3));
rDotMag0Sq  = sum(X0(4:6).^2);
N           = length(timevec);

% Preallocate output
XOut        = zeros(6, N);

% Find semimajor axis
a       = (2./rMag0 - rDotMag0Sq/mu_earth).^(-1);

% Some variables
r0_rDot0    = X0(1:3)'*X0(4:6);
nInv        = sqrt(a^3 / mu_earth);    % Inverse of mean motion
sqrt_mu_a   = sqrt(mu_earth*a);

%% Newton-Raphson loop
phi     = zeros(1, N);      % Initial guess (1 x N)
fn_phi  = 1;                % Initialise for error
count   = 0;

while max(abs(fn_phi)) > 1e-9 && count < 5000
    % Solve for phi
    fn_phi  = nInv * (phi - (1-rMag0/a).*sin(phi) + ...
        r0_rDot0/sqrt_mu_a * (1-cos(phi))) - timevec;
    dfn_phi = nInv * (1 - (1-rMag0/a).*cos(phi) + ...
        r0_rDot0/sqrt_mu_a * sin(phi));
    
    % Newton-Raphson update equation
    phi     = phi - fn_phi./dfn_phi;
    
    count = count+1;
    
end

if count > 999
    fprintf('Non-convergence after %.d iterations. Max. error: %.4g.\n', count, max(abs(fn_phi)));
end

%% Compute position and velocity
f   = 1 - a*(1-cos(phi))/rMag0;
g   = timevec - nInv*(phi-sin(phi));

r   = a*(1-(1-rMag0/a)*cos(phi)) + r0_rDot0*sqrt(a/mu_earth)*sin(phi);
fDot= -sqrt_mu_a*sin(phi)/rMag0 ./ r;
gDot= 1 - a*(1-cos(phi))./r;

% for all time
% Position
XOut(1:3,:) = bsxfun(@times, f, X0(1:3)) ...
    + bsxfun(@times, g, X0(4:6));

% Velocity
XOut(4:6,:) = bsxfun(@times, fDot, X0(1:3)) ...
    + bsxfun(@times, gDot, X0(4:6));

end