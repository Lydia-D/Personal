%% Line search
% L Drabsch
% 20/5/016

% note: phi'(alpha) = grad_cost(yk + alpha*pk)^T*pk -> pk of dv1 and dv2?

function alphastar = linesearch(Y,p,cost_k,cost_km1,Lfnhnd)
    
    fn_phi = @(alphai) Lfnhnd(Y+alphai*p);  % phi is the lagrangian, lambda included inside this fn handle
    fn_phid = @(alphai) grad_central(Y+alphai*p,Lfnhnd)'*p;   % grad of LAGRANGIAN * pk
    %phid = calc_g()'*p;  % doesnt change with alpha? ASK KELVIN
    phid0 = fn_phid(0);
    
    c1 = 10^-4;
    c2 = 0.9;
    maxiter = 50;
    
    alpha = zeros(1,maxiter+1);
    alpha(1) = 0;  % alpha 0
    
    alphatest = 0:0.01:1;
    for i = 1:1:length(alphatest)
        phi_pl(i) = fn_phi(alphatest(i));
        dphi_pl(i) = fn_phid(alphatest(i));
    end
    
    alpha(2) = initialalpha(cost_k,cost_km1,phid0);  % greater than 0 and alphamax?
    figure(3)
    plot(alphatest,phi_pl,'b')

    phi = zeros(1,maxiter+1);
    phi0 = fn_phi(0);
    phid0 = fn_phid(0);

    i = 2;
    while i < maxiter
        phi(i) = fn_phi(alpha(i));
        if (phi(i) > phi0 + c1*alpha(i)*phid0) || (phi(i) >= phi(i-1) && i>1)
            alphastar = lineSearchWolfeZoom(alpha(i-1),alpha(i),fn_phi,fn_phid,c1,c2);
            break; % break out of while or out of fn?
        end
        
        phid = fn_phid(alpha(i));
        if abs(phid) <= -c2*fn_phid(0)   % as phid doesnt change this is never true?
            alphastar = alpha(i);
            break;
        end
        if phid >= 0
            alphastar = lineSearchWolfeZoom(alpha(i),alpha(i-1),fn_phi,fn_phid,c1,c2);
            break;
        end
        alpha(i+1) = alpha(i) + (alphamax-alpha(i))*0.1;
        i = i+1;
    end
    if i >= maxiter
        alphastar = alphamax;
    end
    
end