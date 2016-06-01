%% Calculate Hessian of Lagrangian
% L Drabsch
% 23/5/16

function Hnext = calcH_BFGS(Hk,Yk,Ynext,Lk_fnhnd,Lnext_fnhnd)

    sk = Ynext - Yk;
    yk = grad_central(Ynext,Lnext_fnhnd) - grad_central(Yk,Lk_fnhnd); % lagrangian

    Hnext = Hk - (Hk*sk*sk'*Hk)/(sk'*Hk*sk) + yk*yk'/(yk'*sk);

end