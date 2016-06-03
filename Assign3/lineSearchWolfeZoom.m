%% function 'lineSearchWolfeZoom'
%
%  Credit: AERO4701 Tutors

function alphaOpt = lineSearchWolfeZoom(alpha_lo, alpha_hi,...
        phihdl, phidhdl, c1, c2)
    

    % Maximum number of iterations
    jMax = 20;

    alpha2 = zeros(jMax, 1);
    phi2 = zeros(jMax, 1);
    phid2 = zeros(jMax, 1);

    j = 0;

    alphaOpt = [];
    phi0 = phihdl(0);
    phid0 = phidhdl(0);
    % selection phase
    while j < jMax
        j = j + 1;

        alpha2(j) = lineSearchWolfeInterpolate(alpha_lo, alpha_hi, ...
            phihdl(alpha_lo), phihdl(alpha_hi), ...
            phidhdl(alpha_lo), phidhdl(alpha_hi));
        fprintf('alpha2j in LineSearch Wolfe Zoom %f\n', alpha2(j))
        if alpha2(j) > 1
            alphaOpt = 1;
            break;
        elseif alpha2(j) < 0
            alphaOpt = 0;
            break
        end
        phi2(j) = phihdl(alpha2(j)); % evaluate phi(j)   

        if ( (phi2(j)>phi0+c1*alpha2(j)*phid0) ...
                || (phi2(j)>=phihdl(alpha_lo)) )
            % sufficient decrease condition violated
            alpha_hi = alpha2(j);
        else
            phid2(j) = phidhdl(alpha2(j)); % evaluate phi(j)   
            if (abs(phid2(j)) <= -c2*phid0)
                % solution found
                alphaOpt = alpha2(j);
                break;
            end

            if (phid2(j)*(alpha_hi - alpha_lo) >= 0)
                alpha_hi = alpha_lo;
            end
            alpha_lo = alpha2(j);
        end
    end

    alpha2 = alpha2(1:j, 1); % remove entries
    
    if isempty(alphaOpt)
        
        alphaOpt = alpha2(end);
    end
 
%     if alphaOpt < alpha_lo
%         alphaOpt = alpha_lo;
%     end
end

function alphaInterp = lineSearchWolfeInterpolate(alpha0, alpha1,...
    phi0, phi1, phid0, phid1)

    if alpha1 == alpha0
        alphaInterp = alpha1;
    else
        % 3rd order polynomial interpolation
        d1 = phid0 + phid1 - 3*(phi0 - phi1)/(alpha0 - alpha1);
        d2 = sign(alpha1 - alpha0)*sqrt(d1^2 - phid0*phid1);
        alphaInterp = alpha1 - (alpha1 - alpha0)*(phid1 + d2 - d1)...
            /(phid1 - phid0 + 2*d2); % minimum of the 3rd order model
    end

end