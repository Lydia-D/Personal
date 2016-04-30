%% Script to initilise satellite tracks in 3D animation
% L Drabsch 
% 28/4/2016

colours = 'rgcbmy'; % will throw an error if more than 6 colours required?
% coloursgnd = 
for satindex = 1:1:size(ClassPara,2)
    Sat = SatNo(satindex);
    figure(figsim.globe)
    eval(['figsim.Sat' num2str(Sat) '.sat = scatter3(NaN,NaN,NaN,''filled'',''MarkerFaceColor'',''k'',''XDatasource'',''X_ECIstore(1,t,Sat)'',''YDataSource'',''X_ECIstore(2,t,Sat)'',''ZDataSource'',''X_ECIstore(3,t,Sat)'');'])
    eval(['Sattext.Sat' num2str(Sat) '= text(NaN,NaN,NaN,''' num2str(SatText(Sat)) ''',''Color'', ''' colours(satcolour(Sat))  ''');'])
    eval(['figsim.Sat' num2str(Sat) '.orbit = plot3(NaN,NaN,NaN,''' colours(satcolour(Sat))  ''',''XDatasource'',''X_ECIstore(1,1:t,Sat)'',''YDatasource'',''X_ECIstore(2,1:t,Sat)'',''ZDatasource'',''X_ECIstore(3,1:t,Sat)'');'])

    figure(figgnd.handle)
    eval(['figgnd.Sat' num2str(Sat) '.orbit = plot(NaN,NaN,''.' colours(satcolour(Sat)) ''',''XDatasource'',''X_LLHGCstore(2,1:t,Sat)'',''YDatasource'',''X_LLHGCstore(1,1:t,Sat)'');'])
    eval(['figgnd.Sat' num2str(Sat) '.sat= plot(NaN,NaN,''x' colours(satcolour(Sat)) ''',''XDatasource'',''X_LLHGCstore(2,t,Sat)'',''YDataSource'',''X_LLHGCstore(1,t,Sat)'');'])
    eval(['Gndtext.Sat' num2str(Sat) '= text(NaN,NaN,''' num2str(SatText(Sat)) ''',''Color'', ''' colours(satcolour(Sat))  ''');'])


end


