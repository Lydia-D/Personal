%% Generate the grid to discritise the global map for the robot
% L Drabsch
% 9/5/16
% Inputs ->  mapDim      = [MAP_WIDTH MAP_HEIGHT]
%            cellDim     = [CELL_WIDTH CELL_HEIGHT]
%            startPos    = [x y] position of the start position in meters
%            goalPos     = [x y] position of the goal position in meters
% Outputs -> map         = 2D matrix with start and end node defined  

function map = generateGrid(mapDim,cellDim,startPos,goalPos)
    
    gridsize = mapDim./cellDim;
    map = ones(gridsize);

    startGrid = pos2cell(startPos,cellDim,mapDim);
    goalGrid = pos2cell(goalPos,cellDim,mapDim);
    
    % x position is the column index and y position is the row index
    map(startGrid(2),startGrid(1))  = 2;    % start position is blue
    map(goalGrid(2),goalGrid(1))   = 3;     % end position is red

end