%% L.Drabsch 16/3/16
% Runge-Kutta Integration


function Xknext = RungeKutta(funstring,Xk,dt)
    fn = str2func(funstring);
    k1 = dt.*fn(Xk);
    k2 = dt.*fn(Xk+k1./2);
    k3 = dt.*fn(Xk+k2./2);
    k4 = dt.*fn(Xk+k3);
    
    Xknext = Xk + 1/6.*(k1 + 2.*k2 + 2.*k3 + k4);
end