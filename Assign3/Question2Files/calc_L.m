%% Calculate Lagrangian
% L Drabsch
% 20/5/16

function L = calc_L(Y,lambda)
    global flag rho
    c = constraints(Y);

    switch flag.penalty
        case 'Yes'
            L = Cost(Y) - lambda'*c+rho*c'*c/2;
        case 'No'
            L = Cost(Y) - lambda'*c;
    end
end