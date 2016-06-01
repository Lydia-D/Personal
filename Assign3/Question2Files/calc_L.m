%% Calculate Lagrangian
% L Drabsch
% 20/5/16

function L = calc_L(Y,X0,lambda,Final)
    c = constraints(X0,Y,Final);
    L = Cost(Y) - lambda'*c;
end