function visualise_Q(Q) % Q = [q1,q2,q3,q4]
hold off
q1 = Q(1);
q2 = Q(2);
q3 = Q(3);
q4 = Q(4);

l1 = q1^2+q2^2-q3^2-q4^2;
l2 = 2*(q2*q3+q1*q4);
l3 = 2*(q2*q4-q1*q3);
m1 = 2*(q2*q3-q1*q4);
m2 = q1^2-q2^2+q3^2-q4^2;
m3 = 2*(q3*q4+q2*q1);
n1 = 2*(q1*q3+q2*q4);
n2 = 2*(q3*q4-q1*q2);
n3 = (q1^2-q2^2-q3^3+q4^2);

Lbe = [l1,l2,l3;m1,m2,m3;n1,n2,n3];
x = Lbe(1,:);
y = Lbe(2,:);
z = Lbe(3,:);

vector(eye(3),['x';'y';'z'],['k';'k';'k'])
hold on
vector(x','xB','g')
vector(y','yB','r')
vector(z','zB','b')
axis square
end