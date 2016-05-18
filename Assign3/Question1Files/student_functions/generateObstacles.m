%% Generate the obstacles in configuration space
% L Drabsch
% 9/5/16
% The radius of the rovers 
% Inputs ->  map        = 2D matrix with start and end node defined
%            obstacles  = [x,y,radius] of each obstacle
%            cellDim    = [CELL_WIDTH CELL_HEIGHT]
%            mapDim     = [MAP_WIDTH MAP_HEIGHT]
% Outputs -> map        = 2D matrix with start node, goal node and 
%                         obstacles defined

function map = generateObstacles(map,obstacles,cellDim,mapDim)

    global ROVER_FOOTPRINT_RADIUS

    for i_obs = 1:1:size(obstacles,1)
        % calculate new radius
        newrad{i_obs} = obstacles(i_obs,3)+ ROVER_FOOTPRINT_RADIUS;
        
        % x domain of the obstacle (meters)
        xcells{i_obs}.m = [obstacles(i_obs,1)-newrad{i_obs}: 0.2*cellDim(1) :obstacles(i_obs,1)+newrad{i_obs}];
        
        % calculate upper and lower y edge of the circle (meters)
        y{i_obs}.m_up = obstacles(i_obs,2) + sqrt(newrad{i_obs}.^2 - (xcells{i_obs}.m - obstacles(i_obs,1)).^2);
        y{i_obs}.m_down = obstacles(i_obs,2) - sqrt(newrad{i_obs}.^2 - (xcells{i_obs}.m - obstacles(i_obs,1)).^2);
            
        % indicies of edge
        pos{i_obs}.grid_up = real(pos2cell([xcells{i_obs}.m',y{i_obs}.m_up'],cellDim,mapDim));
        pos{i_obs}.grid_down = real(pos2cell([xcells{i_obs}.m',y{i_obs}.m_down'],cellDim,mapDim));
        
        % set inclusive indicies as obstacles 
        for x_i = 1:1:length(xcells{i_obs}.m)
            map([pos{i_obs}.grid_down(x_i ,2):pos{i_obs}.grid_up(x_i ,2)], pos{i_obs}.grid_up(x_i,1)) = 4;
        end
    
    end

end