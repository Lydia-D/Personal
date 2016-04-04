%% L Drabsch 20/3/16
% fill out function to store orbital parameters
function createorbitpar(name)
    global secs_per_day mu_earth
    inc = deg2rad(10.1687);
    Rasc = deg2rad(46.5607);
    e = 0.6813430;
    omega =deg2rad(77.2770);
    M0 = deg2rad(346.0491); % mean anomoly at time t0
    t0 = 68.37507029*secs_per_day; % time at
    MM = 2.68103309; % mean motion rev per day
    a = (mu_earth/(MM*2*pi/secs_per_day).^2).^(1/3); % m from mean motion TLE 
    p = a*(1-e^2);% semilatus rectum
    n = MM*2*pi/secs_per_day;  % mean motion
    
    % solve for initial theta at t = t0
    t = t0;
    Mt = M0 + n*(t-t0);
    % solve kepler equation
    E = newtown(Mt,e);
    % solve for true anomaly using eccentric anomaly
    theta = 2*atan(sqrt(1+e)/sqrt(1-e)*tan(E/2));
    
    X_c = [Rasc,omega,inc,a,e,theta]';
    X_e = class2equin(X_c);
    
    eval(['save ' name ' inc Rasc e omega M0 t0 a p n X_c X_e'])
    
end

