%% Dijkstra Implementation
% L Drabsch
% 9/5/16

function [distanceFromStart,parent,H,map] = dijkstraBody(currentNode,distanceFromStart,parent,H,map,mapTraversability,neighbours,neighbourInd)

    currentcost = distanceFromStart(currentNode);
    
    % for each neighbour:
    for i_n = 1:1:length(neighbours)
       if distanceFromStart(neighbours(i_n)) > currentcost + mapTraversability(neighbours(i_n))
           distanceFromStart(neighbours(i_n)) = currentcost + mapTraversability(neighbours(i_n));
           parent(neighbours(i_n)) = currentNode;
       end
     % place neighbours in open list
     H(neighbours(i_n)) = 1;
    end
    

end