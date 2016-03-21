%% Question 3 HG start from 3 observations

% inputs: Sat_LG_polar = [R1,R2,R3;az1,az2,az3;,el1,el2,el3];
%         Sat_time    = [t1,t2,t3]
%         Gnd_LLH = [lat,long,height] of gnd station
Sat_LG_polar = TakeLLHGD(:,[1,2,4]);
Sat_time = Taketime([1,2,4]);
Gnd_LLH = [deg2rad(2);deg2rad(-62);0];
Gnd_ECEF = llhgd2ecef(Gnd_LLH);

R = Sat_LG_polar(1,1:3); % R vectors

v2_Rframe = HG_velvector(R,Sat_time);

% transform LG_polar to LG_cart to ECEF to ECI
% all vectorised 
Sat_LG_cart = polar2cartesian(Sat_LG_polar);
Sat_ECEF_local = lg2ecef(Sat_LG_cart,Gnd_LLH);
Sat_ECI_local = ecef2eci(Sat_ECEF_local,Sat_time);

% Gnd station moves in ECI frame over time
Gnd_ECEF = llhgd2ecef(Gnd_LLH);
Gnd_ECI = ecef2eci(Gnd_ECEF*ones(1,3),Sat_time);

% Take from origin of earth
Sat_ECI_global = Sat_ECI_local+Gnd_ECI;

% ECI velocity vector where Sat_ECI_global = [r1,r2,r3] in x,y,z
% corrdinates in ECI frame
V2_ECI = Sat_ECI_global*v2_Rframe;   % matrix multiplication
R2_ECI = Sat_ECI_global(:,2);

%% orbital parameters
Vmag = norm(V2_ECI); % m/s
Rmag = norm(R2_ECI);

a = mu_earth*Rmag/(2*mu_earth-Vmag.^2.*Rmag);
W = cross(R2_ECI,V2_ECI)/norm(cross(R2_ECI,V2_ECI));
inc = acos(W(3));
e_vec = 1/mu_earth.*((Vmag.^2-mu_earth/Rmag).*R2_ECI - (dot(R2_ECI,V2_ECI).*V2_ECI));
e = norm(e_vec);
N = cross([0;0;1],W)/norm(cross([0;0;1],W));
Rasc = atan2(dot(cross([1;0;0],N),[0;0;1]),dot([1;0;0],N));
omega = atan2(dot(cross(N,e_vec)./e,W),dot(N,e_vec)/e);
theta = atan2(dot(cross(e_vec,R2_ECI)./(e.*Rmag),W) , dot(e_vec,R2_ECI)./(e.*Rmag));

