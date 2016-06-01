%% Calculate initial step size
% L Drabsch 
% 22/5/2016

function alpha = initialalpha(cost_k,cost_km1,phid)
    
    testalpha = 1.01*2*(cost_k-cost_km1)/phid;
    alpha = min(1,testalpha);
    
end


