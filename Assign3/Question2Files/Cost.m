% Cost function
% L Drabsch 
% 12/5/16

function C = Cost(X)
    C = abs(X(2)) + abs(X(6));
end