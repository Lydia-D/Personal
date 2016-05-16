function [ PHI ] = Jac_state(Xt, X0, a, tDiff, f, fDot, g, gDot)
global mu_earth
%% Extract data
r   = Xt(1:3);
v   = Xt(4:6);
r0  = X0(1:3);
v0  = X0(4:6);

rMag    = norm(Xt(1:3));
r0Mag   = norm(X0(1:3));

%% Intermediate variables
alpha   = 1./a;
sqrtAlph= sqrt(alpha);
sqrtMu  = sqrt(mu_earth);

chi     = alpha*sqrtMu*tDiff + (r'*v - r0'*v0)/sqrtMu;
u2      = (1-cos(sqrtAlph*chi))/alpha;
u3      = (sqrtAlph*chi - sin(sqrtAlph*chi))/(alpha*sqrtAlph);
u4      = 0.5*chi^2/alpha - u2/alpha;
u5      = chi^3/(6*alpha) - u3/alpha;
c       = (3*u5 - chi*u4 - sqrtMu*tDiff*u2)/sqrtMu;

%% Output
PHI             = zeros(size(Xt,1));

% PHI_11
PHI(1:3,1:3)    = rMag/mu_earth*(v - v0)*(v - v0)' + ...
                    r0Mag^(-3)*(r0Mag*(1-f)*r*r0' + c*v*r0') + f*eye(3);

% PHI_12
PHI(1:3,4:6)    = r0Mag/mu_earth*(1-f) * ((r-r0)*v0' - (v-v0)*r0') + ...
                    c/mu_earth*v*v0' + g*eye(3);

% PHI_21
PHI(4:6,1:3)    = -r0Mag^-2 * (v-v0)*r0' - rMag^-2 * r*(v-v0)' ...
                    - (mu_earth*c*r*r0')/(rMag^3*r0Mag^3) + fDot*(eye(3) - r0Mag^-2 ...
                    *(r*r') + (r*v' - v*r')*r*(v-v0)'/(mu_earth*rMag));

% PHI_22
PHI(4:6,4:6)    = r0Mag/mu_earth*(v-v0)*(v-v0)' + r0Mag^-3 * ...
                    (r0Mag*(1-f)*r*r0' - c*r*v0') + gDot*eye(3);

end