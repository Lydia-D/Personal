%% Generic Gradient function
% L Drabsch
% 13/5/16
% inputs -> Y = [dE1,dV1,el1,az1,dE2,dV2,el2,az2]'
%           fnhandle = handle to function that the gradiant is being calculated for
%           pert = perturbation size
% outputs -> dYpert = gradient 
function dYpert = grad(Y,fnhandle,pert)
    
    % output from function with initial Y
    Outputfn_Y = fnhandle(Y);   

    for i = 1:1:size(Y,1)
        Ypert = Y;
        Ypert(i) = Ypert(i) + pert;
        
        % change in fn output after perturbations
        dYpert(i) = fnhandle(Ypert) - Outputfn_Y; 
    end
    
    dYpert = dYpert./pert;
end