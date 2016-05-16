%% Script to initilise satellite tracks in 3D animation
% L Drabsch 
% 28/4/2016

colours = 'rgcbmy'; % will throw an error if more than 6 colours required?
% coloursgnd = 
% for orbitindex = 1:1:size(ClassPara,2)
% PhaseText = ['Park';'Burn1'
phase = 1;
    % ECI
    figure(figsim.globe)
    eval(['figsim.Sat' num2str(phase) '.ECI.sat = scatter3(NaN,NaN,NaN,''filled'',''MarkerFaceColor'',''k'',''XDatasource'',''X.park(1,t)'',''YDataSource'',''X.park(2,t)'',''ZDataSource'',''X.park(3,t)'');'])
%     eval(['Sattext.Sat' num2str(phase) '.ECI.text= text(NaN,NaN,NaN,''' num2str(PhaseText(phase,:)) ''',''Color'', ''' colours(phase)  ''');'])
    eval(['figsim.Sat' num2str(phase) '.ECI.orbit = plot3(NaN,NaN,NaN,''' colours(phase)  ''',''XDatasource'',''X.park(1,1:t)'',''YDatasource'',''X.park(2,1:t)'',''ZDatasource'',''X.park(3,1:t)'');'])

%     % ECEF
%     figure(figsim.globe2)
%     eval(['figsim.Sat' num2str(Sat) '.ECEF.sat = scatter3(NaN,NaN,NaN,''filled'',''MarkerFaceColor'',''k'',''XDatasource'',''X_ECEFstore(1,t,Sat)'',''YDataSource'',''X_ECEFstore(2,t,Sat)'',''ZDataSource'',''X_ECEFstore(3,t,Sat)'');'])
%     eval(['Sattext.Sat' num2str(Sat) '.ECEF.text= text(NaN,NaN,NaN,''' num2str(SatText(Sat)) ''',''Color'', ''' colours(satcolour(Sat))  ''');'])
%     eval(['figsim.Sat' num2str(Sat) '.ECEF.orbit = plot3(NaN,NaN,NaN,''' colours(satcolour(Sat))  ''',''XDatasource'',''X_ECEFstore(1,1:t,Sat)'',''YDatasource'',''X_ECEFstore(2,1:t,Sat)'',''ZDatasource'',''X_ECEFstore(3,1:t,Sat)'');'])

    
%     figure(figgnd.handle)
%     eval(['figgnd.Sat' num2str(Sat) '.orbit = plot(NaN,NaN,''.' colours(satcolour(Sat)) ''',''XDatasource'',''X_LLHGCstore(2,1:t,Sat)'',''YDatasource'',''X_LLHGCstore(1,1:t,Sat)'');'])
%     eval(['figgnd.Sat' num2str(Sat) '.sat= plot(NaN,NaN,''x' colours(satcolour(Sat)) ''',''XDatasource'',''X_LLHGCstore(2,t,Sat)'',''YDataSource'',''X_LLHGCstore(1,t,Sat)'');'])
%     eval(['Gndtext.Sat' num2str(Sat) '= text(NaN,NaN,''' num2str(SatText(Sat)) ''',''Color'', ''' colours(satcolour(Sat))  ''');'])


% end


