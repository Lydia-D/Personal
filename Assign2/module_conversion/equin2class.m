%% L Drabsch 21/3/16
% function to convert equinoctial elements to classical elements vectorised
% input:X_e = [p,f,g,h,k,L]'
% outputs: X_c = [Rasc,omega,inc,a,e,theta]'
 
function X_c = equin2class(X_e)

    p = X_e(1,:);
    f = X_e(2,:);
    g = X_e(3,:);
    h = X_e(4,:);
    k = X_e(5,:);
    L = X_e(6,:);

    a(1,:) = p./(1-f.^2-g.^2);
    e(1,:) = sqrt(f.^2+g.^2);
    inc = atan2(2.*sqrt(h.^2+k.^2),(1-h.^2-k.^2));
    omega = atan2(g.*h-f.*k,f.*h+g.*k);
    Rasc = atan2(k,h);
    theta = L - atan2(g,f);
    
    X_c = [Rasc;omega;inc;a;e;theta];
end

