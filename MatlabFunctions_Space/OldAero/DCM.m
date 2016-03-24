% DCM(Euler) finds the 3-2-1 transformation matrix
%   for a given set of quaternions
%   - Quaternions must be of size 4x1 and form e = [e0, e1, e2, e3]'

% David

% Edits:
% 2/05  1:30 pm: Removed array operators because one set of Euler
%                angles can only output one transformation matrix - DF
% 3/05 10:25 am: Turned everything into quaternions - DF
% 8/05 7:45  am: Removed quaternion extraction; accesses input vector
%                directly now - DF

% Reference: Typed notes Part A, pp. 66-67

function [ DCM_out ] = DCM( e )

% DCM matrix entries
l1 = e(1)^2 + e(2)^2 - e(3)^2 - e(4)^2;
l2 = 2*(e(2)*e(3) + e(1)*e(4));
l3 = 2*(e(2)*e(4) - e(1)*e(3));
m1 = 2*(e(2)*e(3) - e(1)*e(4));
m2 = e(1)^2 - e(2)^2 + e(3)^2 - e(4)^2;
m3 = 2*(e(3)*e(4) + e(1)*e(2));
n1 = 2*(e(1)*e(3) + e(2)*e(4));
n2 = 2*(e(3)*e(4) - e(1)*e(2));
n3 = e(1)^2 - e(2)^2 - e(3)^2 + e(4)^2;

% Construct DCM matrix
DCM_out = [l1 l2 l3; m1 m2 m3; n1 n2 n3];

end