%% Calculate Hessian using finite differencing (centre)
% L Drabsch
% 17/5/16

% do i even need this normally?

function calcH(X0

    for i = 1:1:length(X0)
        perturbi = zeros(size(X0));
        perturbi(i) = eps;
        for j = i:1:length(X0)
            perturbj = zeros(size(X0));
            perturbj(j) = eps;
            
            f_p = cost(X0,Y+perturb,final);
            c_m = constraints(X0,Y-perturb,final);
            dcdx{i} = (c_p - c_m)/(2*eps);
        end
        G = cat(2,dcdx{:});
    end

        
end