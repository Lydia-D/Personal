function Q_e = Euler2Quad(Ed) % (degrees) E = euler [phi;theta;psi] & Q = [q1;q2;q3;q4]
E = Ed.*pi./180; % deg to rad
[R,C] = size(E);
Q_e = zeros(4,C);
i = 1;
if R == 3 % check
    while i <= C
        Eu = E./2;
        q1 = cos(Eu(3,i)).*cos(Eu(2,i)).*cos(Eu(1,i))+sin(Eu(3,i)).*sin(Eu(2,i)).*sin(Eu(1,i));
        q2 = cos(Eu(3,i)).*cos(Eu(2,i)).*sin(Eu(1,i))-sin(Eu(3,i)).*sin(Eu(2,i)).*cos(Eu(1,i));
        q3 = cos(Eu(3,i)).*sin(Eu(2,i)).*cos(Eu(1,i))+sin(Eu(3,i)).*cos(Eu(2,i)).*sin(Eu(1,i));
        q4 = -cos(Eu(3,i)).*sin(Eu(2,i)).*sin(Eu(1,i))+sin(Eu(3,i)).*cos(Eu(2,i)).*cos(Eu(1,i));

        % normalise
        mu2 = q1^2+q2^2+q3^2+q4^2;
        q1 = q1/sqrt(mu2);
        q2 = q2/sqrt(mu2);
        q3 = q3/sqrt(mu2);
        q4 = q4/sqrt(mu2);
        
        Q_e(:,i) = [q1;q2;q3;q4]; 
        i = i+1;
    end
else
    disp('error, you need [phi;theta;psi]')
end



