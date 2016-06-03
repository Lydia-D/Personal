%% Calculate Lagrangian
% L Drabsch
% 20/5/16

function L = calc_L(Y,lambda)
    global rho
    c = constraints(Y);
    
    switch rho
        case 0
            L = Cost(Y) - lambda'*c;
        otherwise
            L = Cost(Y) - lambda'*c + rho/2*(c'*c);
    end
end