%% L Drabsch
% find period
% inputs: xorbit = the x vector in the perifocal frame
%           dt = time between each index
% output: period = in seconds
function period = Pfind(xorbit,dt)
    [val,index] = sort(xorbit,'descend');
    
    maxindex = sort(index(1:3),'ascend');
    dtime = (maxindex(2:3)-maxindex(1:2)).*dt;
    period = mean(dtime);
end