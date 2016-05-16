% solve with Newton-Raphson
% L Drabsch
% 14/5/16

function phiout = SolveNR(phi_i,i_t,fnhandle,dfnhandle,tol,maxiter)

    iter = 1;
    phi = phi_i;
    error = 1;
    while abs(error) > tol && iter < maxiter
%       Newton-Raphson update equation
        phinext = phi - 0.4*fnhandle(phi,i_t)./dfnhandle(phi);
        error = phi - phinext;
        iter = iter + 1;
        phi = phinext;
    end
    
    phiout = phi;
end

