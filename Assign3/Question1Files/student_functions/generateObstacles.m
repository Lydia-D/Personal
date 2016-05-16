% L Drabsch
% 9/5/16
function map = generateObstacles(map,obstacles,cellDim,mapDim)

    global ROVER_FOOTPRINT_RADIUS


    % find the edge of obstacles - wont always be the same size
    for i_obs = 1:1:size(obstacles,1)
        newrad{i_obs} = obstacles(i_obs,3)+ ROVER_FOOTPRINT_RADIUS;
        xcells{i_obs}.m = [obstacles(i_obs,1)-newrad{i_obs}: 0.2*cellDim(1) :obstacles(i_obs,1)+newrad{i_obs}];
        
        
        y{i_obs}.m_up = obstacles(i_obs,2) + sqrt(newrad{i_obs}.^2 - (xcells{i_obs}.m - obstacles(i_obs,1)).^2);
        y{i_obs}.m_down = obstacles(i_obs,2) - sqrt(newrad{i_obs}.^2 - (xcells{i_obs}.m - obstacles(i_obs,1)).^2);
    
%         pos{i_obs}.grid_up = real(meters2grid([xcells{i_obs}.m',y{i_obs}.m_up'],mapDim,cellDim));
%         pos{i_obs}.grid_down = real(meters2grid([xcells{i_obs}.m',y{i_obs}.m_down'],mapDim,cellDim));
        
        pos{i_obs}.grid_up = real(pos2cell([xcells{i_obs}.m',y{i_obs}.m_up'],cellDim,mapDim));
        pos{i_obs}.grid_down = real(pos2cell([xcells{i_obs}.m',y{i_obs}.m_down'],cellDim,mapDim));
        

        for x_i = 1:1:length(xcells{i_obs}.m)
            map([pos{i_obs}.grid_down(x_i ,2):pos{i_obs}.grid_up(x_i ,2)], pos{i_obs}.grid_up(x_i,1)) = 4;
        end
        
    
    end

    
    
    
end