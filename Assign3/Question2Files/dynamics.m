% Dynamics of two orbit burn
% L Drabsch 
% 14/5/16
% Cruise,Instantaneous Burn,Cruise,Instantaneous Burn

function [X,t] = dynamics(Y)
    global Yscale ParkX0
    Yreal = Y./Yscale;
%     Yreal([1,3,4,5,7,8],1) = wrapTo2Pi(Yreal([1,3,4,5,7,8],1));
    Yreal(1,1) = wrapTo2Pi(Yreal(1));
    [X.X1,t.t1] = Cruise(Yreal(1),ParkX0);
    X.X2 = Burn(Yreal(2),Yreal(3),Yreal(4),X.X1);
    [X.X3,t.t3] = Cruise(Yreal(5),real(X.X2));
    X.X4 = Burn(Yreal(6),Yreal(7),Yreal(8),real(X.X3));



end