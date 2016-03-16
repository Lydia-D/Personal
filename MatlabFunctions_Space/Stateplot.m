%% L Drabsch 16/3/16
% Plot each state in 2x3 subplot


function Stateplot(X_ECI,time,fighandle)
    figure(fighandle)
    hold on
    grid on
    subplot(2,3,1), plot(time, X_ECI(1,:));
    title('x')
    subplot(2,3,2), plot(time, X_ECI(2,:));
    title('y')
    subplot(2,3,3), plot(time, X_ECI(3,:));
    title('z')
    subplot(2,3,4), plot(time, X_ECI(4,:));
    title('vel x')
    subplot(2,3,5), plot(time, X_ECI(5,:));
    title('vel y')
    subplot(2,3,6), plot(time, X_ECI(6,:));
    title('vel z')


    
    
end
