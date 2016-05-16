% test moving txt
str = 'hi';
x = 1;
y = 1;
fig = plot(1:1:10,1:1:10,'b')
hold on
t = text(x,y,str);
%t.Position = ['x' ' 0];
t.UserData = ['x','y'];
%linkdata on
for i = 1:1:10
    x = i;
    y = i;
    drawnow
end