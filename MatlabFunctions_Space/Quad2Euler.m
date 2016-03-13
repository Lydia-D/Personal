function E_q = Quad2Euler(Q)
[R,C] = size(Q);
E_q = zeros(3,C);
i = 1;
    if R == 4 % check
        while i <= C
            theta = atan2((Q(1,i).*Q(3,i)-Q(2,i).*Q(4,i)),sqrt((Q(1,i).^2+Q(2,i).^2-.5).^2+(Q(2,i).*Q(3,i)+Q(1,i).*Q(4,i)).^2));
            phi = atan2((Q(3,i).*Q(4,i)+Q(1,i).*Q(2,i)),(Q(1,i).^2+Q(4,i).^2-0.5));
            psi = atan2((Q(2,i).*Q(3,i)+Q(1,i).*Q(4,i)),(Q(1,i).^2+Q(2,i).^2-0.5));

            E_q(:,i) = [phi;theta;psi];
            i = i+1;
        end

    else
        disp('error, you need [q1;q2;q3;q4]')
    end
end


