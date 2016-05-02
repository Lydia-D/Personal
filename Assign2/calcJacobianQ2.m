
function [H,X_LG_UC_cart] = calcJacobianQ2(R2_ECI,V2_ECI,timevec,Index_obs,GS_LLH)
global T_equ
% calculate position and velocity for all time 
[X_ECI_UC_global,a,f,fDot,g,gDot] = UniConic([R2_ECI; V2_ECI], timevec);    

tDiff = timevec - timevec(Index_obs(2));
% positions only
    X_ECI_UC_local =  X_ECI_UC_global(1:3,:) - ecef2eci(llhgc2ecef(GS_LLH),timevec-T_equ);      
    X_LG_UC_cart = ecef2lg(eci2ecef(X_ECI_UC_local,timevec-T_equ),GS_LLH);
    
    % magnitude of the x,y,z local vector
    R_mag_ECI = sqrt(X_ECI_UC_local(1,:).^2 + X_ECI_UC_local(2,:).^2 + X_ECI_UC_local(3,:).^2);
 
% Indices to fill up Jacobian
rStart  = 1:3:length(Index_obs)*3;       % Start of each measurement
rEnd    = [rStart(2:end)-1, length(Index_obs)*3]; % End of each measurement    
H(length(Index_obs)*3, 6) = 0; 


% compute Jacobian
for i = 1:length(Index_obs)
    % Find dX/dX0 = PHI (6 x 6) for each time step
    dXdX0   = Jac_state(X_ECI_UC_global(:,Index_obs(i,1)), [R2_ECI; V2_ECI], a, tDiff(Index_obs(i,1)), ...
                f(Index_obs(i,1)), fDot(Index_obs(i,1)), g(Index_obs(i,1)), gDot(Index_obs(i,1)));
    
    
    
	% Find sensor model derivative (3 x 6) for each time step
    dYdX    = Jac_obs(X_LG_UC_cart(:,Index_obs(i,1)), R_mag_ECI(Index_obs(i,1)), GS_LLH, timevec(Index_obs(i,1))-T_equ);
    
    % Place in Jacobian
    H(rStart(i):rEnd(i),:) = dYdX * dXdX0;
end

end
