%% L Drabsch 20/3/2016
% convert classical orbital elements to Equinoctial elements
% inputs: X_c = [Rasc,omega,inc,a,e,theta]'
% outputs: X_e = [p,f,g,h,k,L]'
function X_e = class2equin(X_c)

    Rasc = X_c(1,1);
    omega = X_c(2,1);
    inc = X_c(3,1);
    a = X_c(4,1);
    e = X_c(5,1);
    theta = X_c(6,1);
    
    p = a.*(1-e.^2);
    f = e.*cos(omega+Rasc);
    g = e.*sin(omega+Rasc);
    h = tan(inc/2).*cos(Rasc);
    k = tan(inc/2).*sin(Rasc);
    L = Rasc + omega + theta;

    X_e = [p,f,g,h,k,L]';

end