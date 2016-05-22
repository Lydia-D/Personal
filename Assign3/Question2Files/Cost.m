% Cost function
% L Drabsch 
% 12/5/16
% should cost be scaled?
function C = Cost(Y)
    global Yscale
    Yreal = Y./Yscale;
    C = abs(Yreal(2)) + abs(Yreal(6));
end

