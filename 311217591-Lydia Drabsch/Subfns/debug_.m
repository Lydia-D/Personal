for Sat = 1:1:size(X_ECIstore,3)
            Sat_ECEF_local = X_ECIstore(:,:,Sat)-GS_ECEF*ones(1,length(timevec)) %all time - gs
            Sat_LG_cart = ecef2lg(Sat_ECEF_local,GS_LLH)
            Sat_LG_pol = cartesian2polar(Sat_LG_cart)
            obs_time(long_i,lat_i) = obs_time(long_i,lat_i) + sum(Sat_LG_pol(3,:)>=0) % number of observable points in time? for this sat

            if sum(Sat_LG_pol(3,:)>=deg2rad(10)) > 0
                obs_sats(long_i,lat_i) = obs_sats(long_i,lat_i)+1;
            end
end