%% Function that calculates ECEF and ECI coords
% L Drabsch 11/4/16
%  edited 20/4 to take in single time

% Input: ClassPara = [Rasc;omega;inc;a;e;M0,t0];
%        t   = current time   column vec?

% outputs position for all sats for a single time input

function [X_ECI,X_ECEF] = keplerorbit3Dloop(ClassPara,t)
        
        numofSats = size(ClassPara,2);
        

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
        
        Mt = M0 + n.*(t*ones(1,numofSats)-t0);
        % solve kepler equation
        E = newtown(Mt,e);

        % solve for theta (true anomaly) using eccentric anomaly
        theta = 2.*atan(sqrt(1+e)./sqrt(1-e).*tan(E/2));

        % solve for r
        r = p./(1+e.*cos(theta));

        % resolve in state space in the perifocal frame 
        % X = [x,y,z,vx,vy,vz]' not partially dependent on time
        X_orbit(1,:) = r.*cos(theta);
        X_orbit(2,:) = r.*sin(theta);
        X_orbit(3,:) = zeros(size(theta));
        X_orbit(4,:) = -sqrt(mu_earth./p).*sin(theta);
        X_orbit(5,:) = sqrt(mu_earth./p).*(e+cos(theta));
        X_orbit(6,:) = zeros(size(theta));
            
        
        % transform to ECI 
        
        X_ECI = orbit2ECI(X_orbit,Rasc,inc,omega);
        
        % transform to ECEF
        X_ECEF = eci2ecef(X_ECI,t);
        
end




