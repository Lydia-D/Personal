
% solve with newtowns method 
function  E_true = newtown(Mt,e)
            E = Mt; % initialise
        while abs(E-e*sin(E)-Mt) > 10^-3      % solve for f = 0
                E_next = E - (E-e*sin(E) - Mt)/(1-e*cos(E)); 
                E=E_next;
        end
        E_true = E;

end



