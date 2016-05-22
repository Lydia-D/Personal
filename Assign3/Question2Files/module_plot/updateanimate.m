%% Satellite animation update
% L Drabsch
% 28/4/16
% X must be passed in in order for the figsim to see
function updateanimate(pltno,X,figsim,timevec)
    dt = timevec(2)-timevec(1); % assume uniform dt
    for t = 1:1:length(timevec)

%         for pltno = 1:1:total

            eval(['refreshdata(figsim.Plt' num2str(pltno) '.sat,''caller'');'])
%                 eval(['Sattext.Sat' num2str(Sat) '.ECI.text.Position = [X_ECIstore(1,t,Sat),X_ECIstore(2,t,Sat),X_ECIstore(3,t,Sat)];'])
            eval(['refreshdata(figsim.Plt' num2str(pltno) '.orbit,''caller'');'])
%         end

        rotate(figsim.globe,[0,0,1],360.*dt./(24*60*60),[0,0,0]);% continuous
        rotate(figsim.ECEFframe.Children,[0,0,1],360.*dt./(24*60*60),[0,0,0]);
        drawnow ;
       
            
    end
end