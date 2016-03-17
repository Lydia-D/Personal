%% Question 3 HG start from 3 observations

% inputs: Sat_LG_polar = [R1,R2,R3;az1,az2,az3;,el1,el2,el3];
%         Sat_time    = [t1,t2,t3]
%         Gnd_LLH = [lat,long,height] of gnd station
R = Sat_LG_polar(1,:); % R vectors

v2_Rframe = HG_velvector(R,Sat_time);

% transform LG_polar to LG_cart to ECEF to ECI
% all vectorised 
Sat_LG_cart = polar2cartesian(Sat_LG_polar);
Sat_ECEF_local = lg2ecef(Sat_LG_cart,Gnd_LLH);
Gnd_ECEF = llhgd2ecef(Gnd_LLH);
Sat_ECEF_global = Sat_ECEF_local + Gnd_ECEF;
Sat_ECI = ecef2eci(Sat_ECEF_global,Sat_time);

% only local vector? pg12
v2_ECI_local = Sat_ECI*v2_Rframe;   % matrix multiplication
v2_ECI_global = v2_ECI_



% use v2_ECI and Sat_ECI(:,2) to find orbital parameters
% pg13-16 or orbit determination
