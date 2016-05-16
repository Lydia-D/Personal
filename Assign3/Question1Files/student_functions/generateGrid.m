
function map = generateGrid(mapDim,cellDim,startPos,goalPos)
    
    gridsize = mapDim./cellDim;
    map = ones(gridsize);
    
%     startGrid = meters2grid(startPos,mapDim,cellDim);
%     goalGrid = meters2grid(goalPos,mapDim,cellDim);

    startGrid = pos2cell(startPos,cellDim,mapDim);
    goalGrid = pos2cell(goalPos,cellDim,mapDim);

    
    % x position is the column index and y position is the row index
    map(startGrid(2),startGrid(1))  = 2; % start position is blue
    map(goalGrid(2),goalGrid(1))   = 3; % end position is red

    
    
end