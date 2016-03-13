function vector_origin(in,n,c) % [ i; j; k ], ['name';'name'],['k';'k']
[R,C] = size(in);
i = 1;
hold on
while i <= C
Abs = sqrt(in(1,i)^2+in(2,i)^2+in(3,i)^2);
plot3([0,in(1,i)/Abs],[0,in(2,i)/Abs],[0,in(3,i)/Abs],c(i,:),'LineWidth',3)
text('Position',[in(1,i)/Abs,in(2,i)/Abs,in(3,i)/Abs],'String',n(i,:))
i = i+1;
grid on
end
end

