%% Calculate Hessian of Lagrangian
% L Drabsch
% 23/5/16

function Hnext = calcH_BFGS(Hk,Yk,Ynext,Lk_fnhnd,Lnext_fnhnd)

    sk = Ynext - Yk;
    yk = grad_central(Ynext,Lnext_fnhnd) - grad_central(Yk,Lk_fnhnd); % lagrangian
%     yk = grad_fwd(Ynext,Lnext_fnhnd) - grad_fwd(Yk,Lk_fnhnd); % lagrangian

    Hnext = Hk - (Hk*(sk*sk')*Hk)/(sk'*Hk*sk) + (yk*yk')/(yk'*sk);
    
%% Damped BFGS
%     skyk = sk'*yk;
%     skHksk = sk'*Hk*sk;
%     if skyk >= 0.2*skHksk
%         thetak = 1;
%     elseif skyk < 0.2*skHksk
%         thetak = (0.8*skHksk)/(skHksk - skyk);
%     else
%         Hnext = eye(size(Hk,1));  % steepest descent
%         return
%     end
%     rk = thetak*yk + (1-thetak)*Hk*sk;
%     
%     Hnext = Hk - (Hk*(sk*sk')*Hk)/skHksk + (rk*rk')/(sk'*rk);
end