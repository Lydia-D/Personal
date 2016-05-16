%% debug convergance one time t 
clear
clc

UAVtrue = [5;5;0];

SatPos = [[-5;5;10],[3;15;8],[-2;-3;15]];

Ranges(1,1) = norm(SatPos(:,1)-UAVtrue);
Ranges(2,1) = norm(SatPos(:,2)-UAVtrue);
Ranges(3,1) = norm(SatPos(:,3)-UAVtrue);

X0 = [0;0;0];
UAV_nlls = convergance(X0,SatPos,Ranges)
