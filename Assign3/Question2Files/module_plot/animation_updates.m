%% Satellite animation update
% L Drabsch
% 28/4/16
phase = 1;
    for t = 1:1:length(timevec)

%         for satindex = 1:1:length(SatNo)
            
%             Sat = SatNo(satindex);
                eval(['refreshdata(figsim.Sat' num2str(phase) '.ECI.sat,''caller'');'])
%                 eval(['Sattext.Sat' num2str(Sat) '.ECI.text.Position = [X_ECIstore(1,t,Sat),X_ECIstore(2,t,Sat),X_ECIstore(3,t,Sat)];'])
                eval(['refreshdata(figsim.Sat' num2str(phase) '.ECI.orbit,''caller'');'])
%                 eval(['refreshdata(figsim.Sat' num2str(Sat) '.ECEF.sat,''caller'');'])
%                 eval(['Sattext.Sat' num2str(Sat) '.ECEF.text.Position = [X_ECEFstore(1,t,Sat),X_ECEFstore(2,t,Sat),X_ECEFstore(3,t,Sat)];'])
%                 eval(['refreshdata(figsim.Sat' num2str(Sat) '.ECEF.orbit,''caller'');'])
%             eval(['refreshdata(figgnd.Sat' num2str(Sat) '.orbit,''caller'');'])
%             eval(['refreshdata(figgnd.Sat' num2str(Sat) '.sat,''caller'');'])
%             eval(['Gndtext.Sat' num2str(Sat) '.Position = [X_LLHGCstore(2,t,Sat),X_LLHGCstore(1,t,Sat)];'])

%         end
        
            rotate(figsim.globe,[0,0,1],360.*dt./(24*60*60),[0,0,0]);% continuous
            rotate(figsim.ECEFframe.Children,[0,0,1],360.*dt./(24*60*60),[0,0,0]);
       
        
        drawnow ;
            
            
    end