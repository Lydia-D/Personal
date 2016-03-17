function Observe = gndstation(X_ECEF,Gnd_LLH,Gnd_ECEF)

    Sat_ECEF = X_ECEF(1:3,:) - Gnd_ECEF*ones(1,size(X_ECEF,2));
    Sat_LG_cart = ecef2lg(Sat_ECEF,Gnd_LLH);
    Sat_LG_polar= cartesian2polar(Sat_LG_cart);

    if Sat_LG_polar(3,1) > 0 % is elevation is >0
        Observe = Sat_LG_polar;
    else
        Observe = [NaN;NaN;NaN]; % not visable
    end


end