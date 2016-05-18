%% Calculate Hohmann Transfer with inclination change
% L Drabsch
% 16/5/16
% NOTE: currently assumes circular orbits
%       
function Y = hohmann(Final,Park)
    global mu_earth
    
    inc_change = cos(Final.inc-Park.inc);
    
    % transfer orbit parameters
    Trans.a = (Final.a + Park.a)/2;
    Trans.e = (Final.a-Park.a)/(2*Trans.a);
    Park.v = sqrt(mu_earth/Park.a);
    
    Trans.vp = sqrt(mu_earth*(1+Trans.e)/Park.a);
    Trans.va = sqrt(mu_earth*(1-Trans.e)/Final.a);
    
    dV1 = Trans.vp-Park.v; % no inclination change when close
    dV2 = sqrt(Final.v^2 + Trans.va^2 - 2*Trans.va*Final.v*inc_change); % does the direction need to change?

    
    
    % direction of thrust vector - assume azmuith = 0?
    az1 = 0;
%     az2 = (Final.inc-Park.inc);
    az2 = asin(Final.v/dV2*sin(Final.inc-Park.inc));
    Y = [pi;dV1;0;az1;pi;dV2;0;az2];


end