function [ dYdX ] = Jac_obs(X_LG_cart, R, GS_LLHGC, tSinceVE)

dYdX    = zeros(3,6);

% Constants
Rxy         = norm(X_LG_cart(1:2));

%% Construct sensor Jacobian
% dR/dX
dRdX_LGV    = X_LG_cart(1:3)./R;
dYdX(1,1:3) = ecef2eci(lg2ecef(dRdX_LGV, GS_LLHGC), tSinceVE);

% dPsi/dX
dPsidX_LGV = [-X_LG_cart(2)./Rxy^2  ;
               X_LG_cart(1)./Rxy^2  ;
               0        	];
dYdX(2,1:3) = ecef2eci(lg2ecef(dPsidX_LGV, GS_LLHGC), tSinceVE);

% dTheta/dX
dThetadX_LGV = [    X_LG_cart(1)*X_LG_cart(3) / (Rxy * R^2) ;
                    X_LG_cart(2)*X_LG_cart(3) / (Rxy * R^2) ;
                    -Rxy / (R^2)            ];
dYdX(3,1:3) = ecef2eci(lg2ecef(dThetadX_LGV, GS_LLHGC), tSinceVE);

end