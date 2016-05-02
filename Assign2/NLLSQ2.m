%% NLLS jacobian convergance
% L Drabsch 4/4/16
% 
% Inputs: PosSat = [xrow;yrow;zrow] at time t for all sats in range
%         PosVar = [x0;y0;z0] current itteration 
%         Rsat = column vector of real ranges from satellites
% Outputs: 
%% 
function [R2_ECI,V2_ECI] = NLLSQ2(R2_ECI,V2_ECI,timevec,Index_obs,GS_LLH,Ymeas)
    global T_equ
    % weighted 
    %W = eye(size(PosSat,4)); % something to do with dilution of precision?
   
    % initialise X0 (gnd station location or previous time step position)
    %X = X0;
    dX = Inf;    
    maxiterations = 100;
    iter = 0;
        % while convergance
    while max(abs(dX)) > 10^-8 
        [H,X_LG_UC_cart] = calcJacobianQ2(R2_ECI,V2_ECI,timevec,Index_obs,GS_LLH);
        
        Ymodel = cartesian2polar(X_LG_UC_cart);
        Ymodelobs =  Ymodel(:,Index_obs);
        % just over the single pass
        drho = Ymeas(:) - Ymodelobs(:); % error in readings [R,az,el]
%       

%         dX = (H'*W*H)\H'*W*drho; % minimise
        dX = (H'*H)\H'*drho;
        
        R2_ECI = R2_ECI + dX(1:3,:);% update new X
        V2_ECI = V2_ECI + dX(4:6,:);
%         X = X+dX;    
        if iter > maxiterations
            break
        else
            iter = iter+1;
        end
    end
    
    %% DOPs
%     DOP = DOPs(H);
    

end