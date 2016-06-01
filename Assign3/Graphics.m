%% Create graphics, animation or plot
% L Drabsch
% 22/5/16

function figsim = Graphics(Plotting,Animation,Y,X0,timestart,dt)

    global r_earth secs_per_hour
    
    
    if Plotting == 1
        [Trans,t] = dynamics(Y,X0);  % return each step
        animation3Dearth();
        TimeVec.park = timestart:dt:t.t1;
        X.park = ConicDynamics(X0,TimeVec.park);
        % Transfer
        TimeVec.trans = [t.t1:dt:t.t1+t.t3];
        X.trans = ConicDynamics(Trans.X2,TimeVec.trans);
        X.trans = real(X.trans);
        
        % Final calculated
        endsim = t.t1+t.t3+24*secs_per_hour;

        TimeVec.final = t.t1+t.t3:dt:endsim;
        X.final = ConicDynamics(Trans.X4,TimeVec.final);
        X.final = real(X.final);

        
        if Animation == 1
            % animate
            figsim = setup3Danimate('X.park',figsim,1);   
            figsim = setup3Danimate('X.trans',figsim,2);
            figsim = setup3Danimate('X.final',figsim,3);
            updateanimate(1,X,figsim,TimeVec.park);
            updateanimate(2,X,figsim,TimeVec.trans);
            updateanimate(3,X,figsim,TimeVec.final);
        else
            % just plot
            justplot(1,X,'X.park',figsim,0)
            justplot(2,X,'X.trans',figsim,0)
            justplot(3,X,'X.final',figsim,endsim)
        end
    end



end