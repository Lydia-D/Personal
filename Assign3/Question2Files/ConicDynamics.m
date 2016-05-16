% Dynamics of Cruise using Universal Conic Section
% L Drabsch
% 14/5/16
% Inputs:   X0 = initial state at t0 = timevec(1)
%           timevector
%         vectorised
function Xt = ConicDynamics(X0,timevec)
    
    
    % Univeral Conic Section - state space [r,v]
    dt = timevec-timevec(1);
    
    fnhandle = UCSfns(X0,dt);
    
    % Calculate change in eccentric anomoly -> need to solve for each point
    % in time seperatly 
    phi_i = 0; 
    tol = 1e-9;
    maxiter = 500;
    phi_t = zeros(size(timevec)); % initialise
    for i_t = 1:1:length(timevec)
        if i_t ~= 1
            phi_i = phi_t(i_t-1);   % use previous phi as initial guess for faster convergance
        end
        phi_t(i_t) = SolveNR(phi_i,i_t,fnhandle.phifn,fnhandle.dphifn,tol,maxiter);
    end
    
    % state at final time
    Xt = zeros(6,length(timevec));
    Xt(1,:) = fnhandle.f(phi_t).*X0(1,:) + fnhandle.g(phi_t)*X0(4,:);
    Xt(2,:) = fnhandle.f(phi_t).*X0(2,:) + fnhandle.g(phi_t)*X0(5,:);
    Xt(3,:) = fnhandle.f(phi_t).*X0(3,:) + fnhandle.g(phi_t)*X0(6,:);
    Xt(4,:) = fnhandle.df(phi_t).*X0(1,:) + fnhandle.dg(phi_t)*X0(4,:);
    Xt(5,:) = fnhandle.df(phi_t).*X0(2,:) + fnhandle.dg(phi_t)*X0(5,:);
    Xt(6,:) = fnhandle.df(phi_t).*X0(3,:) + fnhandle.dg(phi_t)*X0(6,:);

        
%     Xt(1:3,1) = fnhandle.f(phi_t).*X0(1:3) + fnhandle.g(phi_t)*X0(4:6,1);
%     Xt(4:6,1) = fnhandle.df(phi_t).*X0(1:3) + fnhandle.dg(phi_t)*X0(4:6,1);
    
end
    