% constraints fn
% L Drabsch
% 14/5/16
% Inputs -> Y = [dE1,dV1,el1,az1,dE2,dV2,el2,az2]'
% 
function [C,param] = constraints(Y)
    global Final
    % propogate to the end
    [Xall,t] = dynamics(Y);  % final condition in Xall.X4
    X = Xall.X4;
    
    rmag = norm(X(1:3));
    vmag = norm(X(4:6));
    W = cross(X(1:3),X(4:6))/(rmag*vmag);
    % N = k x W / (|k x W|) = [-Wj;Wi;0]/mag
    N = [-W(2);W(1);0]./(norm(W(1:2)));
    
    % I x N = [0;0;Wi]
    % tan(Rasc) = ((IxN).K)/(I.N)
    tanRasc = -W(1)/W(2);
    
    % final radius constraint 
    C(1,1) = norm(X(1:3))/Final.a - 1;
    
    % final velocity constraint
    C(2,1) = norm(X(4:6))/Final.v  - 1;
    
    % final eccentricity constraint  FOR ZERO r dot v = 0
        % normalised
    C(3,1) = dot(X(1:3),X(4:6))/(norm(X(1:3))*norm(X(4:6)));
%     C(3,1) = dot(X(1:3),X(4:6));
    
    % final inclination constraint
    C(4,1) = cos(Final.inc) - W(3);
    
    if ~isnan(Final.Rasc)
        % final Rasc constraint
        C(5,1) = tan(Final.Rasc) - tanRasc;
    end
end