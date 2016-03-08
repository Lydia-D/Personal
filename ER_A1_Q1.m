%% By Lydia Drabsch 
% 8/3/2016
% Experimental Robotics MTRX5700 
% Assignment 1 Q1
clear

yaw = @(alpha) rot('z',alpha);
pitch = @(beta) rot('y',beta);
roll = @(gamma) rot('x',gamma);

%% Part a
R = yaw(deg2rad(10))*pitch(deg2rad(20))*roll(deg2rad(30))
P = [1,2,3]';
T = [R,P;zeros(1,3),1]

%% Part B
R = yaw(deg2rad(10))*pitch(deg2rad(30))*roll(deg2rad(30))
P = [3,0,0]';
T = [R,P;zeros(1,3),1]

%% Part C.1
R = yaw(deg2rad(90))*pitch(deg2rad(180))*roll(deg2rad(-90))
P = [0,0,1]';
T = [R,P;zeros(1,3),1]
%% Part C.2
R = yaw(deg2rad(90))*pitch(deg2rad(180))*roll(deg2rad(270))
P = [0,0,1]';
T = [R,P;zeros(1,3),1]