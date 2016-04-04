%% function to calculate the ECEF cords from range 
% L Drabsch 4/4/16
% 
% Inputs: PosSat = [xrow;yrow;zrow] at time t for all sats in range
%         PosVar = [x0;y0;z0] current itteration 
%         Rsat = column vector of real ranges from satellites

%% 
function convergance(X0,PosSat,Rsat)
    % weighted 
    W = eye(size(PosSat(2))); % something to do with dilution of precision?
   
    % initialise X0 (gnd station location or previous time step position)
    X = X0;
    dX = Inf;

    % while convergance
while norm(dX) < 10^-3 
    H = Jacobian(PosSat,X);
    drho = Rsat - rangecalc(PosSat,X); % error in range
    dX = (H'*W*H)\H'*W*drho; % minimise
    X = X+dX;   % update new X
    
end

