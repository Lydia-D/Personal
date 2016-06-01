%% Calculate Lagrangian
% L Drabsch
% 20/5/16

function L = calc_L(Y,lambda)
    global flag rho
    c = constraints(Y);
    
    switch flag.penalty
        case 'No'
            L = Cost(Y) - lambda'*c;
        case 'Yes'
            L = Cost(Y) - lambda'*c + rho/2*(c'*c);
    end
end