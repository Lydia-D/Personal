%% L Drabsch 16/3/16
% Plot each state in 2x3 subplot
% inputs: X_ECI = vector of 6 elements
%           time = time vector
%         fighandle 
%           titles = cell of strings, default {'x','y','z','vel x','vel y','vel z'}

function Stateplot(X_ECI,time,fighandle,titles)
    
    if isempty(titles)
        titles = {'x','y','z','vel x','vel y','vel z'};
    end

    figure(fighandle)
    title('here')
    hold on
    grid on
    subplot(2,3,1), plot(time, X_ECI(1,:));
    title(titles(1))
    subplot(2,3,2), plot(time, X_ECI(2,:));
    title(titles(2))
    subplot(2,3,3), plot(time, X_ECI(3,:));
    title(titles(3))
    subplot(2,3,4), plot(time, X_ECI(4,:));
    title(titles(4))
    subplot(2,3,5), plot(time, X_ECI(5,:));
    title(titles(5))
    subplot(2,3,6), plot(time, X_ECI(6,:));
    title(titles(6))


    
    
end
