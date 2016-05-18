%% Least Squares Fit of Plane
% L Drabsch
% 9/5/16
% Inputs ->  points = 3D matrix of (x,y,z) of points that fall within 
%                     distance from pos
% Outputs -> n      = normal to the plane vector
%            p      = average vector
function [n,p] = fitPlane(points)

    % average vector
    p = [mean(points(:,1)),mean(points(:,2)),mean(points(:,3))];
    
    R = points - ones(size(points,1),1)*p;
    
    % first eigenvector is the vector normal to the plane
    [vectors,values] = eig(R'*R);
    n = vectors(:,1);
      
end