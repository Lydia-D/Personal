%% Calculate Hessian using finite differencing (centre)
% L Drabsch
% 17/5/16
%b hessian of lagrangian
% do i even need this normally?

function H = calcH_fwd(Y,lambda,L_Y)

    global eps

    fnL = @(Ypert) calc_L(Ypert,lambda);

    H = zeros(length(Y));
    
    for i = 1:1:length(Y)
        perturbi = zeros(size(Y));
        perturbi(i) = eps;
        for j = i:1:length(Y)
            perturbj = zeros(size(Y));
            perturbj(j) = eps;
            
            L_ij = fnL(Y+perturbi+perturbj);
            L_i = fnL(Y+perturbi);
            L_j = fnL(Y+perturbj);
            
            H(i,j) = (L_ij - L_i - L_j + L_Y)./(eps^2);
        end
    end
    % make symmetric
    H = H + triu(H,1)';
    
        
end
