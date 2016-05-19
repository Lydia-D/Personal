%% calculate phi
% L Drabsch
% 20/5/16

function phi = calc_phi(Y,alpha,p)

    phi = Cost(Y+alpha*p);
end