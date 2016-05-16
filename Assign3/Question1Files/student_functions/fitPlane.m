% L Drabsch
% 9/5/16
% points is coordinates not indicies

function [n,p] = fitPlane(points)

%     global pointCloud

    % average vector
    p = [mean(points(:,1)),mean(points(:,2)),mean(points(:,3))];
    
    R = points - ones(size(points,1),1)*p;
    
    [vectors,values] = eig(R'*R);
    
    n = vectors(:,1);
    
    
end