%% Solve KKT
% L Drabsch
% 20/5/16

function [p,lambda] = KKT(Hl,G,g,c)

    M = [Hl,G';G,zeros(size(G,1))];
    m = [g;c];
    
    KKT = M\m;
    
    % direction
    p = -KKT(1:length(g));
    lambda = KKT(length(g)+1:end);


end