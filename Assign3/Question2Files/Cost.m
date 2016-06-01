% Cost function
% L Drabsch 
% 12/5/16
% should cost be scaled?
function C = Cost(Y)
    global Yscale g0 Isp Mass
    Yreal = Y./Yscale;
%     C = abs(Yreal(2)) + abs(Yreal(6));
%     C = abs(Y(2)) + abs(Y(6));
    
    %% using real fuel cost equation -> how to include that you would be lighter the second burn? -> have weighting between burns?
%     C = 1-exp(-Yreal(2)./(g0*Isp)) + 1-exp(-Yreal(6)./(g0*Isp));
    
    fuelloss1 = Mass*(1-exp(-Yreal(2)./(g0*Isp)));
    fuelloss2 = (Mass-fuelloss1)*(1-exp(-Yreal(6)./(g0*Isp)));
%     fuelloss1 = Mass*(1-exp(-Y(2)));
%     fuelloss2 = (Mass-fuelloss1)*(1-exp(-Y(6)));
    C = fuelloss1+fuelloss2;
end
