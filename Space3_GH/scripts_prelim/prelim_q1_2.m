%% Preliminary Question 1.2
%
%  Author: Your Name
% Sydney is GMT + 11 (ignoring daylight savings)
function answer = prelim_q1_2()
    time = (12+5-11)*60*60; % seconds since vernal equinox
    Sat_ECEF = prelim_q1_1();
    Sat_ECI = ecef2eci(Sat_ECEF,time)
end