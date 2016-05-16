function dyn = errorDetect(UAV_LG_cart,Timevec)
    dyn.pos.vec = UAV_LG_cart;
    dyn.vel.vec = (dyn.pos.vec(:,2:end)-dyn.pos.vec(:,1:end-1))./(ones(3,1)*(Timevec(2:end)-Timevec(1:end-1)));
    dyn.acc.vec = dyn.vel.vec(:,2:end) - dyn.vel.vec(:,1:end-1)./(ones(3,1)*(Timevec(3:end)-Timevec(2:end-1)));
    dyn.acc.norm = sqrt(dyn.acc.vec(1,:).^2+dyn.acc.vec(2,:).^2+dyn.acc.vec(3,:).^2);
    dyn.acc.mean = mean(dyn.acc.norm(~isnan(dyn.acc.norm)));
    dyn.acc.std = std(dyn.acc.norm(~isnan(dyn.acc.norm)));

    % indicies of acceleration
    dyn.acc.erroridx = find(dyn.acc.norm>100);
    dyn.vec.erroridx = dyn.acc.erroridx - 1;
    dyn.pos.erroridx = dyn.acc.erroridx - 2;
    
    
end