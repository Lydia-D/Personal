% Convert classical elements to perifocal frame using newton to solve for
% eccentric anomoly
% L Drabsch
% 14/5/16

function X_orbit = class2orbit(a,e,M0,t0)

        global mu_earth
        n = sqrt(mu_earth./a.^3);       % mean motion
        p = a*(1-e^2);                  % semilatus rectum
        Mt = M0 + n*(t-t0);             % Mean anomaly at time t
        
        % solve kepler equation with newton method
        E = newton(Mt,e);               % Eccentric anomaly

        % solve for theta (true anomaly) using eccentric anomaly
        theta = 2*atan(sqrt(1+e)/sqrt(1-e)*tan(E/2));
        r = p/(1+e*cos(theta));         % solve for r

        % resolve in state space in the perifocal frame 
        % X = [x,y,z,vx,vy,vz]'
        X_orbit = [r*cos(theta);...
                   r*sin(theta);...
                   0;...
                   -sqrt(mu_earth/p)*sin(theta);...
                   sqrt(mu_earth/p)*(e+cos(theta));...
                   0];

end