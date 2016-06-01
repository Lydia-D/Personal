% Dynamics of Cruise using Universal Conic Section
% L Drabsch
% 14/5/16
% The change in eccentric anomoly is given in Y
function [Xt,dt] = Cruise(dE,X0)

    global mu_earth
    
    % Univeral Conic Section - state space [r,v]
%     a = (2/norm(X0(1:3)) - norm(X0(4:6)).^2./mu_earth)^(-1);
%     dt = (time.now - time.start);
    dt = NaN;
    fnhandle = UCSfns(X0,dt,dE);  % need to edit
    
    % Calculate time in orbit
    dt = fnhandle.dt(dE);
    % state at final time
    Xt = zeros(6,1);
    Xt(1:3,1) = fnhandle.f(dE).*X0(1:3) + fnhandle.g(dE)*X0(4:6,1);
    Xt(4:6,1) = fnhandle.df(dE).*X0(1:3) + fnhandle.dg(dE)*X0(4:6,1);
    
end
    