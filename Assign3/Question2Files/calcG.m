%% Calculate Jacobian of Constraint fn
% L Drabsch
% 13/5/16
% inputs -> Y = [dE1,dV1,el1,az1,dE2,dV2,el2,az2]'
%           fnhandle = handle to function that the gradiant is being calculated for
%           pert = perturbation size
% outputs -> dYpert = gradient 
function G = calcG(Y,eps,X0,final)

    % central differencing
    
    for i = 1:1:length(Y)
        perturb = zeros(size(Y));
        perturb(i) = eps;
        c_p = constraints(X0,Y+perturb,final);
        c_m = constraints(X0,Y-perturb,final);
        dcdx{i} = (c_p - c_m)/(2*eps);
    end
        G = cat(2,dcdx{:});



end