%% L Drabsch 16/3/16
% convert equinoctial elements to ECI frame
%  - used for J2 perturbation modelling
%  - vectorised for mass conversion
% Input: X_equin = [p,f,g,h,k,L]'
% Output: X_ECI = [x,y,z,vx,vy,vz]'
function X_ECI = equin2eci(X_equin)

    global mu_earth

    p = X_equin(1,:);
    f = X_equin(2,:);
    g = X_equin(3,:);
    h = X_equin(4,:);
    k = X_equin(5,:);
    L = X_equin(6,:);
    
    alpha_sq = h.^2 - k.^2;
    s_sq = 1+h.^2+k.^2;
    w = 1 + f.*cos(L) + g.*sin(L);
    r = p./w;

    X_ECI(1,:) = r./s_sq .*(cos(L)+alpha_sq.*cos(L)+2.*h.*k.*sin(L));
    X_ECI(2,:) = r./s_sq .*(sin(L)-alpha_sq.*sin(L)+2.*h.*k.*cos(L));
    X_ECI(3,:) = 2.*r./s_sq.*(h.*sin(L)-k.*cos(L));
    X_ECI(4,:) = -1/s_sq .*sqrt(mu_earth/p).*(sin(L)+alpha_sq.*sin(L)-2.*h.*k.*cos(L)+g-2.*f.*h.*k+alpha_sq.*g);
    X_ECI(5,:) = -1/s_sq .*sqrt(mu_earth/p).*(-cos(L)+alpha_sq.*cos(L)+2.*h.*k.*sin(L)-f+2.*g.*h.*k+alpha_sq.*f);
    X_ECI(6,:) = 2/s_sq .*sqrt(mu_earth/p).*(h.*cos(L)+k.*sin(L)+f.*h+g.*k);
    
end






