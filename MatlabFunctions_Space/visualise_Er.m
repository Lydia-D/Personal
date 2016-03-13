function fig = visualise_Er(E) % E = [phi,theta,psi]
psi = E(1);
theta = E(2);
psi = E(3);

L_psi = [cos(psi),sin(psi),0;-sin(psi),cos(psi),0;0,0,1];
L_theta = [cos(theta),0,-sin(theta);0,1,0;sin(theta),0,cos(theta)];
L_phi = [1,0,0;0,cos(phi),sin(phi);0,-sin(phi),cos(phi)];

Lbe = L_phi*L_theta*L_psi;
Vb = Lbe*[1;1;1];

vector([1;0;0],'x','k')
hold on
vector([0;1;0],'y','k')
vector([0;0;-1],'z','k')
vector(Vb,'Body','g')
end