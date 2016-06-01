%%  Standard first order central differencing
% L Drabsch 
% 23/5/16

function output = grad_central(x,fnhnd)

    global eps

    for i = 1:1:length(x)
        perturb = zeros(size(x));
        perturb(i) = eps;
        positive = fnhnd(x+perturb);
        negative = fnhnd(x-perturb);
%         c_p = constraints(X0,Y+perturb,final);
%         c_m = constraints(X0,Y-perturb,final);
        dfdx{i} = (positive - negative)/(2*eps);
    end
    
    output = cat(2,dfdx{:});
    
    if size(output,1) == 1
        output = output';
    end




end