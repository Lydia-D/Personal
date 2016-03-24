%% by Lydia Drabsch 12/3/16
% adapted from flight mech (Drabsch,2013)
% plot RH coordinate frame after rotation transformation by euler angles
% input: E = [phi,theta,psi] 
function visualise_Ed(phi,theta,psi) 
phi = deg2rad(phi);
theta = deg2rad(phi);
psi = deg2rad(psi);

L_psi = [cos(psi),sin(psi),0;-sin(psi),cos(psi),0;0,0,1];
L_theta = [cos(theta),0,-sin(theta);0,1,0;sin(theta),0,cos(theta)];
L_phi = [1,0,0;0,cos(phi),sin(phi);0,-sin(phi),cos(phi)];

Lbe = L_phi*L_theta*L_psi;
x = Lbe(1,:);
y = Lbe(2,:);
z = Lbe(3,:);

% vector1([1;0;0],'x','k')
% hold on
% vector1([0;1;0],'y','k')
% vector1([0;0;1],'z','k')
% vector(x','xB','g')
% vector(y','yB','r')
% vector(z','zB','b')
normvector(x',[0;0;0],'xB','--m')
normvector(y',[0;0;0],'yB','--c')
normvector(z',[0;0;0],'zB','--y')
axis square
end