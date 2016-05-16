% constraints fn
% L Drabsch
% 14/5/16
% Inputs -> Y = [dE1,dV1,el1,az1,dE2,dV2,el2,az2]'
% 
function C = constraints(Xfinal,Final)

    C(1,1) = norm(Xfinal(1:3))/Final.r - 1;
    C(2,1) = norm(Xfinal(4:6)/Final.v  - 1;
    C(3,1) = Xfinal(1).*Xfinal(4)/(Final.r*FInal.v);
    C(4,1) = Xfinal(2).*Xfinal(5)/(Final.r*FInal.v);
    C(5,1) = Xfinal(3).*Xfinal(6)/(Final.r*FInal.v);
    C(6,1) = Xfinal(6)/Final.v;
    C(7,1) = Xfinal(3)/Final.v;

end