% Change in orbit during an instantaneous burn
% L Drabsch
% 14/5/16

function [Xt] = Burn(dV,el,az,X0)
    % local cartesian frame 
%     dV_LG_cart = polar2cartesian([dV;az;el]);
    dV_LG_cart = [dV*cos(el)*cos(az);
                  dV*cos(el)*sin(az);
                  dV*sin(el)];
    %% convert to ECI frame:
    % need position of sat relative to ECI
    % Hp = angular momentum vector r x v
    % elevation direction: in v-r plane, +ve away from earth
    % azimuth direction: in v-Hp, +ve from v to Hp
    % right hand system v,Hp,r
    r_vec = X0(1:3)/norm(X0(1:3));
    v_vec = X0(4:6)/norm(X0(4:6));
    
    Hp = cross(r_vec,v_vec);
    Hp_vec = Hp/norm(Hp);
    
    Orth = cross(v_vec,Hp_vec);
    Orth_vec = Orth/norm(Orth);
    DCM = [v_vec,Hp_vec,Orth_vec];
    
%     dV_ECI = [v_vec,Hp_vec,r_vec]*dV_LG_cart;
    dV_ECI = DCM*dV_LG_cart;
    
    Xt = X0+[0;0;0;dV_ECI];
    
    % just dV along original velocity vector
%     dVorbit = v_vec.*dV_LG_cart;
    
    
    
    

end