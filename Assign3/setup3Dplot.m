%% Plot static figure of final orbits
% L Drabsch 
% 16/5/16

function setup3Dplot(Data,figurehandle,pltno)
    global colours
    figure(figurehandle)
%     eval(['figsim.Plt' num2str(pltno) '.sat = scatter3(Data(1,t),Data(2,t),Data(3,t),''filled'',''MarkerFaceColor'',''k'',''XDatasource'',''' Data '(1,t)'',''YDataSource'',''' Data '(2,t)'',''ZDataSource'',''' Data '(3,t)'');'])
%     eval(['Sattext.Sat' num2str(phase) '.ECI.text= text(NaN,NaN,NaN,''' num2str(PhaseText(phase,:)) ''',''Color'', ''' colours(phase)  ''');'])
    eval(['figsim.Plt' num2str(pltno) '.orbit = plot3(' Data '(1,:),' Data(2,:) ',' Data(3,:) ',''' colours(pltno)  ''');'])

    
end