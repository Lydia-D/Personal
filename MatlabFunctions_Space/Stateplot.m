%% L Drabsch 16/3/16
% Plot each state in 2x3 subplot
% inputs: X_ECI = vector of 6 elements
%           time = time vector
%         fighandle 
%           titles = cell of strings, default {'x','y','z','vel x','vel y','vel z'}

function Stateplot(X,time,fighandle,titles,linespec)
    
    if isempty(titles)
        titles = {'x','y','z','vel x','vel y','vel z'};
    end

    figure(fighandle)
    subplot(2,3,1), plot(time, X(1,:),linespec);
    grid on
    hold on
    title(titles(1))
    subplot(2,3,2), plot(time, X(2,:),linespec);
    grid on
    hold on
    title(titles(2))
    subplot(2,3,3), plot(time, X(3,:),linespec);
    grid on
    hold on
    title(titles(3))
    subplot(2,3,4), plot(time, X(4,:),linespec);
    grid on
    hold on
    title(titles(4))
    subplot(2,3,5), plot(time, X(5,:),linespec);
    grid on
    hold on
    title(titles(5))
    subplot(2,3,6), plot(time, X(6,:),linespec);
    grid on
    hold on
    title(titles(6))


    
    
end
