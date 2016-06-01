%%  Standard first order central differencing
% L Drabsch 
% 23/5/16

function output = grad_fwd(x,fnhnd)

    global eps

    for i = 1:1:length(x)
        perturb = zeros(size(x));
        perturb(i) = eps;
        positive = fnhnd(x+perturb);
%         c_p = constraints(X0,Y+perturb,final);
%         c_m = constraints(X0,Y-perturb,final);
        dfdx{i} = (positive - fnhnd(x))/(eps);
    end
    
    output = cat(2,dfdx{:});
    
    if size(output,1) == 1
        output = output';
    end

end
