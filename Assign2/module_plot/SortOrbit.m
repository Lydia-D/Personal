%% sort orbits into colours
% L Drabsch
% 28/4/16

function satcolour = SortOrbit(ClassPara,sortby)
%     sortby = 1; % sort by Rasc
    satcolour(1,1) = 1;
    reference = ClassPara(sortby,1);
    for i = 2:1:size(ClassPara,2)
        there = find(abs(reference-ClassPara(sortby,i)) < 0.2);
        if ~isempty(there) % check against references
            satcolour(1,i) = there;
        else                                       % make new reference
            satcolour(1,i) = size(reference,2)+1;
            reference(end+1) = ClassPara(sortby,i);

        end
    end
    
end