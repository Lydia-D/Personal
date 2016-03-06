% Lydia Drabsch created 5/3/16
% Funtion to define rotation matricies in x,y,z
% angle in radians

function Rout = rot(axis,angle)

    switch axis
        case 'x'
            Rout = [1,0,0;...
                0,cos(angle),-sin(angle);...
                0,sin(angle),cos(angle)];
        case 'y'
            Rout = [cos(angle), 0, sin(angle);...
                0,1,0;...
                -sin(angle), 0, cos(angle)];
        case 'z'
            Rout = [cos(angle),-sin(angle),0;...
                sin(angle),cos(angle),0;...
                0,0,1];
    end
end

            
        