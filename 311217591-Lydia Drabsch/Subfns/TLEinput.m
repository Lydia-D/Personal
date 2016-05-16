%% TLE inputs
% L Drabsch
% Edited 27/4/16 - 
% importing TLEs
% inputs: TLE = matrix of Two line elements
% line 1: line number, sat number, ID, epochyear&day fraction, 1st der, 2nd
% der, drag term, ephemeris, element number and check sum
% line 2: line number, sat number, inclination, Rasc, e, omega, M0, MM,
% revolution number and check sum
function [X,extra,time,SatNo] = TLEinput(TLE)

    global secs_per_day mu_earth

    index = 1;
    while index <= size(TLE, 1)
        
        
        if TLE(index,1) == 1 % if first line of TLE
            NoradID = TLE(index,2);
            Epochyr = floor(TLE(index,4)/1000);
            Epochday = TLE(index,4) - Epochyr*1000;  % -1?
            t0 = Epochday*secs_per_day;

            index = index+1;
            if TLE(index,1) == 2 % check second line
                inc = deg2rad(TLE(index,3));
                Rasc = deg2rad(TLE(index,4));
                e = TLE(index,5)*10^-7;
                omega = deg2rad(TLE(index,6));
                M0 = deg2rad(TLE(index,7));
                MM = TLE(index,8);
                extra.Rev(index/2) = floor(TLE(index,9)/10); % revolution number, checksum removed
            else
                fprintf('Error with TLE, next line isnt sync at index %f',index);
                break;
            end
        else
            fprintf('Error next line not in sync at index %f',index);
            break;
        end

        % calculate other parameters
        n = MM*2*pi/secs_per_day;  % mean motion per second
        a = (mu_earth/(n).^2).^(1/3); % m from mean motion TLE 
        p = a*(1-e^2);% semilatus rectum
        

        % solve for initial theta at t = t0
        t = t0;
        Mt = M0 + n*(t-t0);
        % solve kepler equation
        E = newtown(Mt,e);
        % solve for true anomaly using eccentric anomaly
        theta = wrapTo2Pi(2*atan2(sqrt((1+e)./(1-e)) .* sin(E/2),  cos(E/2)));
        % add the number of revolutions
        extra.thetaRev(index/2) = 2*pi*extra.Rev(index/2)+theta;
        X(:,index/2) = [Rasc;omega;inc;a;e;theta];
        SatNo(1,index/2) = NoradID;
        time(1,index/2) = t0;
%         eval(['Output.X_c' num2str(index/2) ' = [Rasc,omega,inc,a,e,theta]'';'])
%         eval(['Output.X_e ' num2str(index/2) ' = class2equin(Output.X_c' num2str(index/2) ');'])
        index = index + 1;

    end
    
end