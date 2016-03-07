%% Preliminary Question 1.1
%
%  Author: Lydia Drabsch 6/3/16
function Sat_ECEF = prelim_q1_1()
    % location of Sydney    
    Obs_LLH = [-deg2rad(33.8681),deg2rad(151.2075),0]';   % lat long height (assume sea level)

    % satellite observation
    Sat_LG_polar = [1970*10^3,deg2rad(27.5),deg2rad(72.1)]';  % R, az, el,   not including rad of earth
    Sat_LG_cart  = polar2cartesian(Sat_LG_polar); 
    Sat_ECEF     = lg2ecef(Sat_LG_cart,Obs_LLH,'d')
    
end