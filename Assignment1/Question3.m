%% L Drabsch 16/3/16
% Question 3

figure(4)
% gnd station location
Gnd_LLH = [deg2rad(2);deg2rad(-62);0];

Gnd_ECEF = llhgc2ecef(Gnd_LLH);

Sat_ECEF = X_ECEFstore(1:3,:) - Gnd_ECEF*ones(1,865);
Sat_LG_cart = ecef2lg(Sat_ECEF,Gnd_LLH);
Sat_LG_polar= cartesian2polar(Sat_LG_cart);

subplot(1,3,1), plot(time,Sat_LG_polar(1,:))
title('Range')
subplot(1,3,2), plot(time,Sat_LG_polar(2,:))
title('Azimuth')
subplot(1,3,3), plot(time,Sat_LG_polar(3,:))
title('Elevation')