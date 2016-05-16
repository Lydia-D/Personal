%% Extract ranges for each individual satellite over all time
% L Drabsch
% 2/5/16
function SatObs = Satextract(Observables,Ranges,SatNo,Timevec,colours)

    for Sat = 1:1:SatNo

        SatObs{Sat}.ide = find(Observables == Sat);
        SatObs{Sat}.range = Ranges(SatObs{Sat}.ide);
        [SatObs{Sat}.idx,SatObs{Sat}.idy] = ind2sub(size(Observables),SatObs{Sat}.ide);
        SatObs{Sat}.time = Timevec(SatObs{Sat}.idy)';

        % Ranges relative to global time vector
        SatObs{Sat}.globalt.range = NaN*ones(1,length(Timevec));
        SatObs{Sat}.globalt.range(SatObs{Sat}.idy) = SatObs{Sat}.range;
                
    end

end