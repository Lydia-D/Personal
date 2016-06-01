%% Line search
% L Drabsch
% 20/5/016

% note: phi'(alpha) = grad_cost(yk + alpha*pk)^T*pk -> pk of dv1 and dv2?

function alphastar = linesearch(Y,p,cost_k,cost_km1)
    
    fn_phi = @(alphai) calc_phi(Y,alphai,p);
    fn_phid = @(alpha) calc_g()'*p;
    phid = calc_g()'*p;  % doesnt change with alpha? ASK KELVIN
    
    c1 = 10^-4;
    c2 = 0.9;
    maxiter = 50;
    
    alpha = zeros(1,maxiter+1);
    alpha(1) = 0;  % alpha 0
    alpha(2) = initialalpha(cost_k,cost_km1,phid);  % greater than 0 and alphamax?
    alphamax = 1;

    phi = zeros(1,maxiter+1);
    phi(1) = Cost(Y);

    i = 2;
    while i < maxiter
        phi(i) = fn_phi(alpha(i));
        if phi(i) > phi(1) + c1*alpha(i)*phid
            alphastar = lineSearchWolfeZoom(alpha(i-1),alpha(i),fn_phi,fn_phid,c1,c2);
            break; % break out of while or out of fn?
        end
        
        if abs(phid) <= -c2*phid   % as phid doesnt change this is never true?
            alphastar = alpha1;
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
        alphastar = 1;
    end
    
end