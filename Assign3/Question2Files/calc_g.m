%% Calculate Jacobian of Constraint fn
% L Drabsch
% 13/5/16
% inputs -> Y = [dE1,dV1,el1,az1,dE2,dV2,el2,az2]'
%           fnhandle = handle to function that the gradiant is being calculated for
%           pert = perturbation size
% outputs -> dYpert = gradient 
function dY = calc_g()

    % central differencing
    
    
    dY = [0;1;0;0;0;1;0;0;];






end