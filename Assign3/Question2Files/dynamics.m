% Dynamics of two orbit burn
% L Drabsch 
% 14/5/16
% Cruise,Instantaneous Burn,Cruise,Instantaneous Burn

function [X,t] = dynamics(Y,X0)
    
    [X.X1,t.t1] = Cruise(Y(1),X0);
    X.X2 = Burn(Y(2),Y(3),Y(4),X.X1);
    [X.X3,t.t3] = Cruise(Y(5),real(X.X2));
    X.X4 = Burn(Y(6),Y(7),Y(8),real(X.X3));



end