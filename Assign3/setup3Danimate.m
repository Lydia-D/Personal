%% Script to initilise satellite tracks in 3D animation
% L Drabsch 
% 28/4/2016

function figsim = setup3Danimate(Data,figsim,pltno)
    global colours     % will throw an error if more than 6 colours required?


    % ECI
    figure(figsim.globe)
    eval(['figsim.Plt' num2str(pltno) '.sat = scatter3(NaN,NaN,NaN,''filled'',''MarkerFaceColor'',''k'',''XDatasource'',''' Data '(1,t)'',''YDataSource'',''' Data '(2,t)'',''ZDataSource'',''' Data '(3,t)'');'])
%     eval(['Sattext.Sat' num2str(phase) '.ECI.text= text(NaN,NaN,NaN,''' num2str(PhaseText(phase,:)) ''',''Color'', ''' colours(phase)  ''');'])
    eval(['figsim.Plt' num2str(pltno) '.orbit = plot3(NaN,NaN,NaN,''' colours(pltno)  ''',''XDatasource'',''' Data '(1,1:t)'',''YDatasource'',''' Data '(2,1:t)'',''ZDatasource'',''' Data '(3,1:t)'');'])

    
%     eval(['figsim.Plt' num2str(pltno) '.sat = scatter3(NaN,NaN,NaN,''filled'',''MarkerFaceColor'',''k'',''XDatasource'',''Data(1,t)'',''YDataSource'',''Data(2,t)'',''ZDataSource'',''Data(3,t)'');'])
% %     eval(['Sattext.Sat' num2str(phase) '.ECI.text= text(NaN,NaN,NaN,''' num2str(PhaseText(phase,:)) ''',''Color'', ''' colours(phase)  ''');'])
%     eval(['figsim.Plt' num2str(pltno) '.orbit = plot3(NaN,NaN,NaN,''' colours(pltno)  ''',''XDatasource'',''Data(1,1:t)'',''YDatasource'',''Data(2,1:t)'',''ZDatasource'',''Data(3,1:t)'');'])
end