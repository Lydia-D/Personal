%% Preliminary Question 1.1
%
%  Author: Lydia Drabsch 6/3/16
function Sat_ECEF_global = prelim_q1_1()
    % location of Sydney    
    Obs_LLH = [-deg2rad(33.8650),deg2rad(151.2094),0]';   % lat long height (assume sea level)
    
    % satellite observation
    Sat_LG_polar = [1970*10^3,deg2rad(27.5),deg2rad(72.1)]';  % R, az, el,   not including rad of earth
    Sat_LG_cart  = polar2cartesian(Sat_LG_polar); 
    
    Sat_ECEF_local     = lg2ecef(Sat_LG_cart,Obs_LLH);
    
    Obs_ECEF = llhgd2ecef(Obs_LLH);
    Sat_ECEF_global = Obs_ECEF+Sat_ECEF_local;
    
    
% R = rot('z',-Obs_LLH(2,1))*rot('y',pi/2+Obs_LLH(1,1));
% % R = rot('y',pi/2+Obs_LLH(1,1))
% Rtrans = R'
% Rother = rot('y',(Obs_LLH(1,1)))*rot('z',Obs_LLH(2,1));
% Pos = [0;0;0];%Obs_ECEF;
% T = [Rother,Pos;[0,0,0,1]]
% plotcoord(T)
end