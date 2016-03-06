%% Preliminary Question 1.1
%  
%  Author: Lydia Drabsch 6/3/16
function answer = prelim_q1_1()
    % location of Sydney    
    Obs_LLH = 

    % satellite observation
    Sat_LG_polar = [1970*10^3,deg2rad(27.5),deg2rad(72.1)]';
    Sat_LG_cart  = polar2cartesian(Sat_LG_polar);
    Sat_ECEF     = lg2ecef(Sat_LG_cart,Obs_LLH,'d');
    
end