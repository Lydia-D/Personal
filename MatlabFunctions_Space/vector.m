% By Lydia Drabsch
% 11/3/2016
% adapted from Flight Mech (Drabsch,2013)

function vector(coord_to,coord_from,n,c) % [ i; j; k ], ['name','name'],['k','k']
[R,C] = size(coord_to);
i = 1;
while i <= C
Abs = sqrt(coord_to(1,i)^2+coord_to(2,i)^2+coord_to(3,i)^2);
plot3([coord_from(1,i),coord_to(1,i)/Abs],[coord_from(2,i),coord_to(2,i)/Abs],[coord_from(3,i),coord_to(3,i)/Abs],c(i))
text('Position',[coord_to(1,i)/Abs,coord_to(2,i)/Abs,coord_to(3,i)/Abs],'String',n(i))
i = i+1;
grid on
end
end

