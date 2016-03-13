% By Lydia Drabsch
% 11/3/2016
% adapted from Flight Mech (Drabsch,2013)
% inputs: coord_to = 3 x n with x,y,z coords of direction to
%         coord_from = 3 x n with x,y,z coords of direction from
%         n = string name of string to position at the ned of the vector
%         c = string colour of plot including type eg: --c
function normvector(coord_to,coord_from,n,c) 
[Rows,Columns] = size(coord_to);
i = 1;
while i <= Columns
    %Abs = sqrt(coord_to(1,i)^2+coord_to(2,i)^2+coord_to(3,i)^2); % normalise
    Abs = 1;
    plot3([coord_from(1,i),coord_to(1,i)/Abs],[coord_from(2,i),coord_to(2,i)/Abs],[coord_from(3,i),coord_to(3,i)/Abs],c(i))
    text('Position',[coord_to(1,i)/Abs,coord_to(2,i)/Abs,coord_to(3,i)/Abs],'String',n(i))
    i = i+1;
end
end

