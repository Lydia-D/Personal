% L Drabsch
% 9/5/16
% transform real map coordinates to grid indicies, vectorised
function gridPos = meters2grid(pos,mapDim,cellDim)

    % +1 as 'grid origin' is from 1 not 0
    gridPos =  ceil((0.5.*ones(size(pos,1),1)*mapDim + pos)./(ones(size(pos,1),1)*cellDim)) + 1;
    
end