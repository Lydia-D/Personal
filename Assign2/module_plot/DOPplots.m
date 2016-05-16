% plot dilution of precision 

sats = Observables(:,INDEX);
sats = sats(sats~=0);
figpol.lim = PolarPlot();
hold on
SatLoc_ECEF_local = squeeze(X_ECEFstore(:,DOPlim.minIdx,sats)) - GndStation_ECEF*ones(1,length(sats));
Sat_Loc_LG = cartesian2polar(ecef2lg(SatLoc_ECEF_local,GndStation_LLH));
[Sat_Locplot.x,Sat_Locplot.y] = polar2plot(Sat_Loc_LG(2,:),Sat_Loc_LG(3,:));
for p = 1:1:length(Sat_Locplot.x)
        plot(Sat_Locplot.x(p),Sat_Locplot.y(p),'o','Color' ,colours(sats(p),:))
        text(Sat_Locplot.x(p)+0.03,Sat_Locplot.y(p),num2str(sats(p)),'Color',colours(sats(p),:),'FontSize',12)
end
