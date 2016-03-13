% plot displacement at each time step and plot orientation every 10 time
% steps
 % call X - state vector
 % X(11-13) = x,y,z position
 % x(7-10) quaternions for orientation
 
 function vectrajectory(X)
 plot3(X(11,:),X(12,:),X(13,:),'k');  % position
 Xori = X(:,[1:100:end]); %takes every 10 columns 
 hold on
 LW = [0;-280/2;0];   % position of left wing tip from cg [assume inline with cg]
 RW = [0;280/2;0];   % position of right wing tip from cg
 N = [300;0;0];   % Position of nose from cg
 T = [-300;0;0];  % position of tail from cg
 
 for i = [1:size(Xori,2)]
 Leb = DCM(Xori(7:10,i))';
 LWposb(:,i) =  Leb*LW;
 RWposb(:,i) = Leb*RW;
 Nposb(:,i) = Leb*N;
 Tposb(:,i) = Leb*T;
 end
 
 LWpos = LWposb+Xori(11:13,:);
 RWpos = RWposb+Xori(11:13,:);
 Npos = Nposb+Xori(11:13,:);
 Tpos = Tposb+Xori(11:13,:);
 
vector(LWpos,Xori(11:13,:),'r');
vector(RWpos,Xori(11:13,:),'g');
vector(Npos,Xori(11:13,:),'b');
 vector(Tpos,Xori(11:13,:),'y');

 
% plot3(LWpos(1,:),LWpos(2,:),LWpos(3,:),'r');
% plot3(RWpos(1,:),RWpos(2,:),RWpos(3,:),'g');
% plot3(Npos(1,:),Npos(2,:),Npos(3,:),'b');
% plot3(Tpos(1,:),Tpos(2,:),Tpos(3,:),'y');

legend('Centre of gravity','Left Wing Tip','Right Wing Tip','Nose','Tail')  
xlabel('x')
ylabel('y')
zlabel('z')
grid on
 end
 
 
 
 