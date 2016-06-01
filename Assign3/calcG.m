%% Calculate g = dcost/dy ?
% L Drabsch 
% 18/5/16

function G = calcG(Y,fnhandle)
    global flag
%     g = [0;1;0;0;0;1;0;0];
    switch flag.hessian            
        case 'Forward Differencing'
            G = grad_fwd(Y,fnhandle);
        otherwise
            G = grad_central(Y,fnhandle);
    end
end





