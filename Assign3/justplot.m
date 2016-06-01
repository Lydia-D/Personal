%% Just plot final trajectories without animation
% L Drabsch
% 22/5/16

function justplot(pltno,X,Data,figsim,endtime)
      
        global colours

        eval(['figsim.Plt' num2str(pltno) '.sat = scatter3(' Data '(1,end),' Data '(2,end),' Data '(3,end),''filled'',''MarkerFaceColor'',''k'');'])
%                 eval(['Sattext.Sat' num2str(Sat) '.ECI.text.Position = [X_ECIstore(1,t,Sat),X_ECIstore(2,t,Sat),X_ECIstore(3,t,Sat)];'])
        eval(['figsim.Plt' num2str(pltno) '.orbit = plot3(' Data '(1,1:end),' Data '(2,1:end),' Data '(3,1:end),''' colours(pltno)  ''');'])
        rotate(figsim.globe,[0,0,1],360.*endtime./(24*60*60),[0,0,0]);% continuous
        rotate(figsim.ECEFframe.Children,[0,0,1],360.*endtime./(24*60*60),[0,0,0]);
        drawnow ;
       
            
end