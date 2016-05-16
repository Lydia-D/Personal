
for tindex = 1:1:length(Timevec_eq)
    % remove trailing zeros
    Obs_t = ObserveSats{tindex};
    %Obs_t = Obs_t(Obs_t~=0);        % satellites that are observable now

    clear Range_t
    for obs_i = 1:1:length(Obs_t)
        Range_t(obs_i,1) = SatObs{Obs_t(obs_i)}.globalt.range(tindex);
    end
    
     if length(Obs_t)<=3
         UAV_ECEF_global(1:4,tindex) = [NaN;NaN;NaN;NaN];
         UAV_ECEF_local(1:3,tindex)  = [NaN;NaN;NaN];
         UAV_LG_cart(1:3,tindex)     = [NaN;NaN;NaN];
         DOP(1:5,tindex)             = [NaN;NaN;NaN;NaN;NaN];
         clockbias(1,tindex)         = NaN;
     else
        % only look at position of sats for this point in time for the
        % observable satellites
        X_ECEF = squeeze(X_ECEFstore(:,tindex,Obs_t));
        X_ECI = squeeze(X_ECIstore(1:3,tindex,Obs_t));

        % NLLS (with clock bias)
        [UAV_ECEF_global(1:4,tindex),DOP(1:5,tindex),clockbias(1,tindex)] = convergance(GuessLoc,X_ECEF,Range_t);

        UAV_ECEF_local(1:3,tindex) = UAV_ECEF_global(1:3,tindex) - GndStation_ECEF;
        UAV_LG_cart(1:3,tindex) = ecef2lg(UAV_ECEF_local(1:3,tindex),GndStation_LLH);

        GuessLoc = [UAV_ECEF_global(1:3,tindex);0]; % use previous timestep for guess of next location

        SatLoc_ECEF_local = X_ECEF - GndStation_ECEF*ones(1,size(X_ECEF,2));
        Sat_Loc_LG = cartesian2polar(ecef2lg(SatLoc_ECEF_local,GndStation_LLH));

        figure(figpol.base)
        [Sat_Locplot.x,Sat_Locplot.y] = polar2plot(Sat_Loc_LG(2,:),Sat_Loc_LG(3,:));


        for p = 1:1:length(Sat_Locplot.x)
            plot(Sat_Locplot.x(p),Sat_Locplot.y(p),'o','Color' ,colours(Obs_t(p),:))

            if tindex == 1 
                text(Sat_Locplot.x(p)+0.03,Sat_Locplot.y(p),num2str(Obs_t(p)),'Color',colours(Obs_t(p),:),'FontSize',12)
                done = Obs_t;
            elseif sum(Obs_t(p)==done) == 0
                text(Sat_Locplot.x(p)+0.03,Sat_Locplot.y(p),num2str(Obs_t(p)),'Color',colours(Obs_t(p),:),'FontSize',12)
                done = [done; Obs_t(p)];
            end
        end
     end
end
