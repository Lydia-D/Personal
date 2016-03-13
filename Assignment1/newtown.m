
% solve with newtowns method 
function  E_next=  newtown(E)
    E_next = E - (E-e*sin(E) - Mt)/(1-e*cos(E));
end



