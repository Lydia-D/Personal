%% L. Drabsch 15/3/16
% Question 2 Space 3 - Orbit Perturbations
% Modified equinol elements model with numerical integration by runge kutta
clc
close all
clear
%% State model
% x = [p,f,g,h,k,L]'
% Xdot = dx/dt
A = [0,                     2*p/omega*sqrt(p/mu_earth),                     0;...
    sqrt(p/mu_earth).*sin(L), sqrt(p/mu_earth).*((omega+1).*cos(L)+f)/omega, -sqrt(p/mu_earth).*g/omega.*(h.*sin(L)-k.*cos(L));...
    -sqrt(p/mu_earth).*cos(L), sqrt(p/mu_earth).*((omega+1).*sin(L)+f)/omega,-sqrt(p/mu_earth).*f/omega.*(h.*sin(L)-k.*cos(L));...
    0,                          0,                                            sqrt(p/mu_earth).*s.^2.*cos(L)/(2*omega);...
    0,                          0,                                            sqrt(p/mu_earth).*s.^2.*sin(L)/(2*omega);...
    0,                          0,                                            sqrt(p/mu_earth)./omega.*(h.*sin(L)-k.*cos(L))];

b = [0;0;0;0;0;sqrt(mu_earth.*p).*(omega/p).^2];

Delta(1,1) = -3.*mu_earth.*J2.*r_earth.^2/(2.*r.^4).*(1-(12.*((h.*sin(L)-k.*cos(L)).^2)/((1+h.^2+k.^2).^2)));
Delta(2,1) = -12.*mu_earth.*J2.*r_earth.^2/(r.^4) .* (h.*sin(L)-k.*cos(L)).*(h.*cos(L)+k.*sin(L))/((1+h.^2+k.^2).^2);
Delta(3,1) = -6.*mu_earth.*J2.*r_earth.^2/(r.^4) .*((1-h.^2-k.^2).*h.*sin(L)-k.*cos(L))./((1+h.^2+k.^2).^2);

Xdot = A*Delta+b;


