% L Drabsch
% 9/5/16

function [g,f,parent,H,map] = aStarBody(currentNode,g,f,parent,H,heuristic,map,mapTraversability,neighbours,neighbourInd);
        
    for i_n = 1:1:length(neighbours)
       if g(neighbours(i_n)) > g(currentNode) + mapTraversability(neighbours(i_n))
            g(neighbours(i_n)) = g(currentNode) + mapTraversability(neighbours(i_n)); 
            f(neighbours(i_n)) = g(currentNode) + heuristic(neighbours(i_n));
            parent(neighbours(i_n)) = currentNode;
       end
     % place neighbours in open list ?if not already closed? - neighbours
     % list already takes out visited places in previous function
     H(neighbours(i_n)) = 1;
    end


end