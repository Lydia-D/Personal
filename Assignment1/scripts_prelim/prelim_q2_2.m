%% Preliminary Question 2.2
%
%  Author: Your Name

function Land_LLHGD = prelim_q2_2()
    Sat_ECEF_global = [-6763200;3940900;5387700]; % given, meters
    Sat_LLH_global = ecef2llhgc(Sat_ECEF_global);
    Land_LG_sat_polar = [3970*10^3;deg2rad(-131.57);deg2rad(-30.40)]; % given, rad,rad,m
    Land_LG_sat_cat = polar2cartesian(Land_LG_sat_polar);
    
    Land_ECEF_sat   = lg2ecef(Land_LG_sat_cat,Sat_LLH_global);
    
    Land_ECEF_global = Sat_ECEF_global+Land_ECEF_sat;

%     Land_LLHGC = ecef2llhgc(Land_ECEF_global);
    Land_LLHGD = ecef2llhgd(Land_ECEF_global);
end