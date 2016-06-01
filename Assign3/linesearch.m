%% Line search
% L Drabsch
% 20/5/016

function linesearch(Y,p)
    
    fn_phi = @(alphai) calc_phi(Y,alphai,p)
    phi0 = Cost(Y);
    
    alpha0 = 0;
    alpha1 = ;  % greater than 0 and alphamax?
    i = 1;
    while 1
        phi1 = fn_phi(alpha1);
        if phi1 > 
            
            
        end
        
    end
    
    
end