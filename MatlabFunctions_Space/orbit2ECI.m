%% by Lydia Drabsch 13/3/16
% function to convert states from orbit coordinates to ECI coordinates
% inputs: X_orbit = [x,y,z,vx,vy,vz]' in orbit frame
%           Rasc = right ascentionn of the ascending node in radians
%           i = inclination angle in radians
%           omega = argument of perigee in radians

function X_ECI = orbit2ECI(X_orbit,Rasc,i,omega)
    
%     orbit_2_ECI = [cos(Rasc)*cos(omega)-sin(Rasc)*sin(omega)*cos(i), -cos(Rasc)*sin(omega)-sin(Rasc)*cos(omega)*cos(i),sin(Rasc)*sin(i);...
%                    sin(Rasc)*cos(omega)+cos(Rasc)*sin(omega)*cos(i), -sin(Rasc)*sin(omega)+cos(Rasc)*cos(omega)*cos(i),-cos(Rasc)*sin(i);...
%                    sin(omega)*sin(i),                                cos(omega)*sin(i),                                cos(i)];
    
    X_ECI(1,:) =  (cos(Rasc).*cos(omega)-sin(Rasc).*sin(omega).*cos(i)).*X_orbit(1,:) +(-cos(Rasc).*sin(omega)-sin(Rasc).*cos(omega).*cos(i)).*X_orbit(2,:) + sin(Rasc).*sin(i).*X_orbit(3,:);
    X_ECI(2,:) = (sin(Rasc).*cos(omega)+cos(Rasc).*sin(omega).*cos(i)).*X_orbit(1,:) + (-sin(Rasc).*sin(omega)+cos(Rasc).*cos(omega).*cos(i)).*X_orbit(2,:) -cos(Rasc).*sin(i).*X_orbit(3,:);
    X_ECI(3,:) = sin(omega).*sin(i).*X_orbit(1,:) + cos(omega).*sin(i).*X_orbit(2,:) + cos(i).*X_orbit(3,:);
    X_ECI(4,:) =  (cos(Rasc).*cos(omega)-sin(Rasc).*sin(omega).*cos(i)).*X_orbit(4,:) +(-cos(Rasc).*sin(omega)-sin(Rasc).*cos(omega).*cos(i)).*X_orbit(5,:) + sin(Rasc).*sin(i).*X_orbit(6,:);
    X_ECI(5,:) = (sin(Rasc).*cos(omega)+cos(Rasc).*sin(omega).*cos(i)).*X_orbit(4,:) + (-sin(Rasc).*sin(omega)+cos(Rasc).*cos(omega).*cos(i)).*X_orbit(5,:) -cos(Rasc).*sin(i).*X_orbit(6,:);
    X_ECI(6,:) = sin(omega).*sin(i).*X_orbit(4,:) + cos(omega).*sin(i).*X_orbit(5,:) + cos(i).*X_orbit(6,:);               
               
%     X_ECI(1:3,1) = orbit_2_ECI*X_orbit(1:3,1);
%     X_ECI(4:6,1) = orbit_2_ECI*X_orbit(4:6,1);

end

