%% L Drabach 17/3/16
% inputs: R = [r1;r2;r3]
%         t = [t1;t2;t3]
% output: v2= vectorised with the magnitudes with unit vectors r1,r2,r3
function v2 = HG_velvector(R,t)
    
    global mu_earth
    
    dt32 = t(3)-t(2);
    dt21 = t(2)-t(1);
    dt31 = t(3)-t(1);
    
    % components 
    v2(1,1) = -dt32.*(1./(dt21.*dt31) + mu_earth/(12.*R(1).^3));
    v2(2,1) = (dt32-dt21).*(1./(dt21.*dt32) + mu_earth/(12.*R(2).^3));
    v2(3,1) = dt21.*(1./(dt32.*dt31) + mu_earth/(12.*R(3).^3));
    
    
    
end