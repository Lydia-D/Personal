% constraints fn
% L Drabsch
% 14/5/16
% Inputs -> Y = [dE1,dV1,el1,az1,dE2,dV2,el2,az2]'
% 
function [C,param] = constraints(Y)
    
    global Final mu_earth r2d

    % propogate to the end
    [Xall,t] = dynamics(Y);  % final condition in Xall.X4
    X = Xall.X4;
    
    rmag = norm(X(1:3));
    vmag = norm(X(4:6));
    param.a = (2/rmag - vmag^2/mu_earth)^(-1);
    W = cross(X(1:3),X(4:6))/(rmag*vmag);
    % N = k x W / (|k x W|) = [-Wj;Wi;0]/mag
    N = [-W(2);W(1);0]./(norm(W(1:2)));
    
    % I x N = [0;0;Wi]
    % tan(Rasc) = ((IxN).K)/(I.N)
    cosRasc = N(1);
    sinRasc = N(2);
%     tanRasc =;
    
    % final radius constraint 
    C(1,1) = rmag/Final.a - 1;
    
    % final velocity constraint
    C(2,1) = vmag/Final.v - 1;
    
    % final eccentricity constraint  FOR ZERO r dot v = 0
        % normalised
    C(3,1) = dot(X(1:3),X(4:6))/(rmag*vmag);
    
    param.evec = 1/mu_earth*((vmag^2-mu_earth/rmag).*X(1:3) - dot(X(1:3),X(4:6)).*X(4:6));
    param.e = norm(param.evec);
    %     C(3,1) = dot(X(1:3),X(4:6));
    
    % final inclination constraint
    C(4,1) = cos(Final.inc) - W(3);
    param.inc = acos(W(3))*r2d;
%       C(4,1) = W(3)/cos(Final.inc) - 1;
    param.Rasc = atan2(sinRasc,cosRasc)*r2d;
    
    % while Rasc and inc are calculated like this, the constraint can be
    % the vector normal to the orbital plane W
    if ~isnan(Final.Rasc)
        % final Rasc constraint
        C(4,1) = W(1)-Final.W(1);  % overwrite prev inclination 
        C(5,1) = W(2)-Final.W(2);  % not ratios as /0
        C(6,1) = W(3)-Final.W(3);
%         C(5,1) = tanRasc/tan(Final.Rasc) - 1;
%         C(5,1) = tan(Final.Rasc) - tanRasc;
    end
end