% Dynamics of two orbit burn
% L Drabsch 
% 14/5/16
% Cruise,Instantaneous Burn,Cruise,Instantaneous Burn

function [X4,t] = dynamics(Y,X0)
    
    [X1,t.t1] = Cruise(Y(1),X0);
    X2 = Burn(Y(2),Y(3:4),X1);
    [X3,t.t3] = Cruise(Y(5),X2);
    X4 = Burn(Y(6),Y(7:8),X3);



end