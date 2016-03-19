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
Gnd_ECI = ecef2eci(Gnd_ECEF,time);
Sat_ECI_local = ecef2eci(Sat_ECEF_local,time);
Sat_ECI_global = Sat_ECI_local+Gnd_ECI;

% only local vector? pg12
v2_ECI_local = Sat_ECI*v2_Rframe;   % matrix multiplication
v2_ECI_global = v2_ECI_lo



% use v2_ECI and Sat_ECI(:,2) to find orbital parameters
% pg13-16 or orbit determination

%% orbital parameters
Vmag = norm(V2);
Rmag = norm(Sat_ECI_global);

a = mu_earth*Rmag/(2*mu_earth-Vmag.^2.*Rmag);
W = cross(Sat_ECI_global,V2)/norm(cross(Sat_ECI_global,V2));
inc = acos(W(3));
e_vec = 1/mu_earth.*((Vmag.^2-mu_earth/Rmag).*Sat_ECI_global - (dot(Sat_ECI_global,V2).*V2));
e = norm(e_vec);
N = cross([0;0;1],W)/norm(cross([0;0;1],W));
Rasc = atan2(dot(cross([1;0;0],N),[0;0;1]),dot([1;0;0],N));
omega = atan2(dot(cross(N,e_vec)./e,W),dot(N,e_vec)/e);
theta = atan2(dot(cross(e_vec,Sat_ECI_global)./(e.*Rmag),W) , dot(e_vec,Sat_ECI_global)./(e.*Rmag));
