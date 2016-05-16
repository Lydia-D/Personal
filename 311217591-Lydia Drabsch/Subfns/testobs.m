% test
% figure
% hold off
buffer = 1;
erroranalysis = dyn.pos.erroridx ;
% erroranalysis = DOPerror.ind ;


for error_i = 1:1:length(erroranalysis)
    domain = erroranalysis(error_i)-buffer:1:erroranalysis(error_i)+buffer;
%     Obs_t = Observables(:,domain);
%     Obs_t = Obs_t(Obs_t~=0);
    obs_i = 1;
    while   obs_i<length(ObserveSats{domain(1)}) 
        % if observed on either side extrapolate data for that time step
        if sum(ObserveSats{domain(1)}(obs_i) == ObserveSats{domain(end)}) && ~sum((ObserveSats{domain(1)}(obs_i) == ObserveSats{domain(buffer+1)}))
           % extrapolate range for that time step
            
           known.ind = ~isnan(SatObs{ObserveSats{domain(1)}(obs_i)}.globalt.range(domain));
           
           known.t = Timevec(domain(known.ind));
           known.r = SatObs{ObserveSats{domain(1)}(obs_i)}.globalt.range(domain(known.ind)) ;
           hold off
           plot(known.t,known.r,'xb')
          hold on
           
           filler = interp1(known.t,known.r,Timevec(domain(~known.ind))) ;
           SatObs{ObserveSats{domain(1)}(obs_i)}.globalt.range(domain(~known.ind)) = filler;
           % add to Observables matrix
           
           tostore = domain(~known.ind);
           for store_i = 1:1:length(tostore);
           
%            newobs = Obs_t(obs_i).*~known.ind;
%            Observables(end+1,domain) = newobs;
           
           ObserveSats{tostore(store_i)}(end+1) = ObserveSats{domain(1)}(obs_i);
           end
            plot(Timevec(domain(~known.ind)),filler,'ro')
           
            
        end
        obs_i = obs_i+1; 
    end
    
    
%     check.domain.low = dyn.pos.erroridx(error_i):-1:dyn.pos.erroridx(error_i)-buffer;
%     check.domain.high = dyn.pos.erroridx(error_i):1:dyn.pos.erroridx(error_i)+buffer;
% 
%     % cycle through observed sats
%  
%     for  obs_i = 1:1:length(Obs_t)  
%         check.range.low = SatObs{Obs_t(obs_i)}.globalt.range(check.domain.low);
%         check.range.high = SatObs{Obs_t(obs_i)}.globalt.range(check.domain.high);
%         % check if one or two data points missing in the middle but back
%         % again
%         plot(Timevec(check.domain.low),check.range.low,'x-b')
%         hold on
%         plot(Timevec(check.domain.high),check.range.high,'x-b')
% 
%         
%         if isnan(check.range.low(2)) == 1 && ~isnan(check.range.low(3))
%             % extrapolate and store
%             check.range.low(2) =  interp1(Timevec(check.domain.low(~isnan(check.range.low))),check.range.low(~isnan(check.range.low)),Timevec(check.domain.low(isnan(check.range.low)))) ;
%             SatObs{Obs_t(obs_i)}.globalt.range(check.domain.low(isnan(check.range.low))) = check.range.low(2);
%             plot(Timevec(check.domain.low),check.range.low,'ro')
% 
%         elseif  isnan(check.range.high(2)) == 1 && ~isnan(check.range.high(3))
%             % extrapolate and store
%             
%             check.range.high(2) =  interp1(Timevec(check.domain.high(~isnan(check.range.high))),check.range.high(~isnan(check.range.high)),Timevec(check.domain.low(isnan(check.range.high)))); 
%             SatObs{Obs_t(obs_i)}.globalt.range(check.domain.high(isnan(check.range.high))) = check.range.high(2);
%             plot(Timevec(check.domain.high),check.range.high,'ro')
%         end
%         % test for dicontinuity
%         %check.Rvel = check.range(2:end)-check.range(1:end-1);
%         %abs(check.Rvel - mean(check.Rvel))>2*std(check.Rvel)
%         
% %         plot(Timevec(check.domain),check.range,'x-')
%         title(['error ' num2str(dyn.pos.erroridx(error_i)) ' Sat ' num2str(Obs_t(obs_i))])
%         xlim([Timevec(check.domain.low(end)) Timevec(check.domain.high(end))])
%         hold off
%     end

end