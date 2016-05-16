%% Function that calculates ECEF and ECI coords
% L Drabsch 11/4/16

% Input: ClassPara =  [Rasc;omega;inc;a;e;M0,t0];
%        t   = current time   column vec?

% have multiple time/multiple sats?.

function [X_ECI,X_ECEF] = keplerorbit(ClassPara,t)
        
        global mu_earth

        Rasc = ClassPara(1,:);
        omega = ClassPara(2,:);
        inc = ClassPara(3,:);
        a = ClassPara(4,:);
        e = ClassPara(5,:);
        M0 = ClassPara(6,:);
        t0 = ClassPara(7,:);
        
        % calculate n and p
        n = sqrt(mu_earth./a.^3);  % mean motion
        p = a.*(1-e.^2);% semilatus rectum
        
        Mt = M0 + n.*(t-t0);
        % solve kepler equation
        E = newtown(Mt,e);

        % solve for theta (true anomaly) using eccentric anomaly
        theta = 2.*atan(sqrt(1+e)./sqrt(1-e).*tan(E/2));

        % solve for r
        r = p./(1+e.*cos(theta));

        % resolve in state space in the perifocal frame 
        % X = [x,y,z,vx,vy,vz]' not partially dependent on time
        X_orbit = [r.*cos(theta);r.*sin(theta);zeros(size(theta));...
            -sqrt(mu_earth./p).*sin(theta);sqrt(mu_earth./p).*(e+cos(theta));zeros(size(theta))];
        
        % transform to ECI 
        X_ECI = orbit2ECI(X_orbit,Rasc,inc,omega);
        
        % transform to ECEF
        X_ECEF = eci2ecef(X_ECI(1:3,1),t); % only position

        
end




