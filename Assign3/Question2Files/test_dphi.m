%% testing phi dot

Ynew = Y+alpha*p;
for i = 1:1:length(Ynew)
        perturb = zeros(size(Ynew));
        perturb(i) = eps;
        cost_p = Cost(Ynew+perturb);
        cost_m = Cost(Ynew-perturb);
        df_phi(i) = (cost_p - cost_m)/(2*eps);
end

dphi = df_phi*p


