%% solve eccentric anomoly with newtowns method 
% L Drabsch 
% Created March 2016
% Updated 11/4/16 - vectorised

function  E_true = newtown(Mt,e)
            E = Mt; % initialise
        while min(abs(E-ones(size(Mt,1),1)*e.*sin(E)-Mt)) > 10^-3      % solve for f = 0
                E_next = E - (E-ones(size(Mt,1),1)*e.*sin(E) - Mt)./(1-ones(size(Mt,1),1)*e.*cos(E)); 
                E=E_next;
        end
        E_true = E;

end



