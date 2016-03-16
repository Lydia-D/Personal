%% L. Drabsch 16/3/16
% Integration function Xdot = A*Delta+b
% X = [p,f,g,h,k,L]'
function Xdot = J2statemodel(X)
    
    p = X(1);
    f = X(2);
    g = X(3);
    h = X(4);
    k = X(5);
    L = X(6);
    
    % assuming 'omega' in A is actually w
    
    global mu_earth mu_J2_r_sq

    s = sqrt(1+h.^2+k.^2);
    w = 1+f.*cos(L) + g.*sin(L);
    r = p./w;
    
    A = [0,                     2*p/w*sqrt(p/mu_earth),                     0;...
    sqrt(p/mu_earth).*sin(L), sqrt(p/mu_earth).*((w+1).*cos(L)+f)/w, -sqrt(p/mu_earth).*g/w.*(h.*sin(L)-k.*cos(L));...
    -sqrt(p/mu_earth).*cos(L), sqrt(p/mu_earth).*((w+1).*sin(L)+f)/w,-sqrt(p/mu_earth).*f/w.*(h.*sin(L)-k.*cos(L));...
    0,                          0,                                            sqrt(p/mu_earth).*s.^2.*cos(L)/(2*w);...
    0,                          0,                                            sqrt(p/mu_earth).*s.^2.*sin(L)/(2*w);...
    0,                          0,                                            sqrt(p/mu_earth)./w.*(h.*sin(L)-k.*cos(L))];

    b = [0;0;0;0;0;sqrt(mu_earth.*p).*(w/p).^2];

    Delta(1,1) = -3.*mu_J2_r_sq/(2.*r.^4).*(1-(12.*((h.*sin(L)-k.*cos(L)).^2)/((1+h.^2+k.^2).^2)));
    Delta(2,1) = -12.*mu_J2_r_sq/(r.^4) .* (h.*sin(L)-k.*cos(L)).*(h.*cos(L)+k.*sin(L))/((1+h.^2+k.^2).^2);
    Delta(3,1) = -6.*mu_J2_r_sq/(r.^4) .*((1-h.^2-k.^2).*h.*sin(L)-k.*cos(L))./((1+h.^2+k.^2).^2);
    
    Xdot = A*Delta+b;
    
end
    
