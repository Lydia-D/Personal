% L Drabsch
% 9/5/16
% Inputs: i,j = index of current cell
%         map = 
function [neighbours,neighbourInd,map] = getNeighbours(i,j,map,mapHeight,mapWidth,conn,mapTraversability)

    if conn == 8
        N = [1,0;1,-1;0,-1;-1,-1;-1,0;-1,1;0,1;1,1]; 
    elseif conn == 4
        N = [1,0;0,-1;-1,0;0,1]; 
    else
        error('conn must be 4 or 8')
        neightbours = NaN;
        neighbourInd = NaN;
    end

    neighbours_sub = ones(conn,1)*[i,j]+N;
    neighbourInd = [1:1:conn]'; 
    
     % check if valid index on grid
     Invalid = (neighbours_sub < 1) + (neighbours_sub>mapHeight) ;
     [IndInvalid,~] = find(Invalid>0);
     neighbourInd(IndInvalid) = NaN;
     neighbours_sub(IndInvalid,:) = NaN;
     neighbourInd = neighbourInd(~isnan(neighbourInd));
     
     neighbours_sub = neighbours_sub(~isnan(neighbours_sub(:,1)),:);
     
     % check if already visited: if map == 6
     neighbours = sub2ind(size(map),neighbours_sub(:,1),neighbours_sub(:,2));
     IndInvalid = (map(neighbours) == 6);
     
     % check if inf on transverablility map (includes obstacles)
     IndInvalid = IndInvalid | (mapTraversability(neighbours) == inf);
     
     % remove invalid neighbours
     neighbourInd(IndInvalid) = NaN;
     neighbours(IndInvalid,:) = NaN;
     
     % remove nans
     neighbourInd = neighbourInd(~isnan(neighbourInd));
     neighbours = neighbours(~isnan(neighbours));
     
     map(neighbours) = 5;
     
end