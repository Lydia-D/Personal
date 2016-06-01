%% Calculate Hohmann Transfer with inclination change
% L Drabsch
% 16/5/16
% NOTE: currently assumes circular orbits
%       
function Y = hohmann(Final,Park)
    global mu_earth
    
%     inc_change = cos(Final.inc-Park.inc);
    
    % transfer orbit parameters
    Trans.a = (Final.a + Park.a)/2;
    Trans.e = (Final.a-Park.a)/(2*Trans.a);
    Park.v = sqrt(mu_earth/Park.a);
    
    Trans.vp = sqrt(mu_earth*(1+Trans.e)/Park.a);
    Trans.va = sqrt(mu_earth*(1-Trans.e)/Final.a);
    
    dV1 = Trans.vp-Park.v; % no inclination change when close
%     dV2 = sqrt(Final.v^2 + Trans.va^2 - 2*Trans.va*Final.v*inc_change); % does the direction need to change?
    dE1 = pi;
    el1 = 0;
    az1 = 0;
    
    if isnan(Final.Rasc)
        Final.Rasc = pi;
    end
%         inc_change = Final.inc-Park.inc;
        
        % direction of thrust vector - assume elevation = 0?
        
        a1 = sin(Park.inc)*cos(Park.Rasc);
        b1 = sin(Final.inc)*cos(Final.Rasc);
        a2 = sin(Park.inc)*sin(Park.Rasc);
        b2 = sin(Final.inc)*sin(Final.Rasc);
        a3 = cos(Park.inc);
        b3 = cos(Final.inc);
        c1 = a2*b3-a3*b2;
        c2 = a3*b1-a1*b3;
        c3 = a1*b2-a2*b1;
        angle_change = acos(a1*b1 + a2*b2 + a3*b3);
        lat1  = atan2(c3,norm([c1,c2]));
        long1 = atan2(c2,c1) - sign(c1)*pi/2;
        if abs(c1) < 10^-7
            long1 = long1 + pi/2;
        end
        % need to convert to dE in park orbit
        % assuming  Park.Rasc = 0 
        dE1 = acos(cos(lat1)*cos(long1));
        
    
        %% Calculate Vfinal direction based on inc_change and Rasc_change
%         inc_change = 
        
        
    
    % use X_trans_ECI velocity vector -> at perigee or trans orbit
    % just do Rasc adjustment?
    dV2 = sqrt(Final.v^2 + Trans.va^2 - 2*Trans.va*Final.v*cos(angle_change));
    az2 = asin(Final.v/dV2*sin(angle_change));
    el2 = 0;
%     el2 = asin(Final.v/dV2*cos(angle_change))
    Y = [dE1;dV1;0;az1;pi;dV2;el2;az2];


end