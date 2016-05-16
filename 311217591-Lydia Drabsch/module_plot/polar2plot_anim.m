%% convert az,el angles to x,y corrdinates on PolarPlotVisual
% L Drabsch
% 30/4/16

function [x,y] = polar2plot_anim(az,el)
    radius = -rad2deg(el)/90 + 1;
    theta = -rad2deg(az) + 90;

    x = radius.*cosd(theta);
    y = radius.*sind(theta);
    
    hold all
    % x is multiple satellites?
    
    

    
end