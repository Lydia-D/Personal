%% Calculate Hohmann Transfer with inclination change
% L Drabsch
% 16/5/16
% NOTE: currently assumes circular orbits
%       
function Y = hohmann(Final,Park)
    global mu_earth
    
    % transfer orbit parameters
    Trans.a = (Final.a + Park.a)/2;
    Trans.e = (Final.a-Park.a)/(2*Trans.a);
    Park.v = sqrt(mu_earth/Park.a);
    
    Trans.vp = sqrt(mu_earth*(1+Trans.e)/Park.a);
    Trans.va = sqrt(mu_earth*(1-Trans.e)/Final.a);
    
    dV1 = Trans.vp-Park.v; % no inclination change when close
    inc_change = Final.inc-Park.inc;
    if isnan(Final.Rasc)
%         inc_change = Final.inc-Park.inc;
         % does the direction need to change?
        
        % direction of thrust vector - assume elevation = 0?
        dE1 = pi;
        el1 = 0;
        az1 = 0;
    else
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
        if c1 == 0
            long1 = long1 + pi/2;
        end
        % need to convert to dE in park orbit
        % assuming  Park.Rasc = 0 
        dE1 = acos(cos(lat1)*cos(long1));
        
%         dV1 = Trans.vp-Park.v; % no inclination change when close
        dV1 = sqrt(Trans.vp^2 + Park.v^2 - 2*Trans.vp*Park.v*sin(Final.Rasc-Park.Rasc));
        az1 = (Final.Rasc-Park.Rasc);
        
    end
    
    % use X_trans_ECI velocity vector -> at perigee or trans orbit
    % just do Rasc adjustment?
    el1 = 0;
    dV2 = sqrt(Final.v^2 + Trans.va^2 - 2*Trans.va*Final.v*cos(inc_change));
%     az1 = 0;
    az2 = asin(Final.v/dV2*sin(inc_change));
%     az2 = pi+ Park.inc -asin(Final.v/dV2*sin(angle_change));

    
    
    
%     az2 = (Final.inc-Park.inc);
    
    Y = [dE1;dV1;el1;az1;pi;dV2;0;az2];


end