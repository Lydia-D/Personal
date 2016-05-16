%% solve eccentric anomoly with newtowns method 
% L Drabsch 
% Created March 2016
% Updated 11/4/16 - vectorised
% edited 26/4/16 with for loop error checking

function  E_true = newtown_loops(Mt,e)
    E_true(1,size(Mt,2)) = 0; % initalise size
     
     for i = 1:1:size(Mt,2)
         E = Mt(i); % initialise
        while min(E-e.*sin(E)-Mt(i)) > 10^-3      % solve for f = 0
                E_next = E - (E-e.*sin(E) - Mt(i))./(1-e.*cos(E)); 
                E=E_next;
        end
        E_true(1,i) = E;
    end
end



