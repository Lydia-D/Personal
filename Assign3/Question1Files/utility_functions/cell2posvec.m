function pos = cell2posvec(gridCoords,cellDim,mapDim)

    xg = gridCoords(:,1); yg = gridCoords(:,2);
    cellWidth = cellDim(1); cellHeight = cellDim(2);
    mapWidth = mapDim(1); mapHeight = mapDim(2);
    
    xm = (xg)*cellWidth-cellWidth*ones(size(xg));
    ym = (yg)*cellHeight-cellHeight*ones(size(yg));
    
    xm = xm - ones(size(xg))*mapWidth/2;
    ym = ym - ones(size(xg))*mapHeight/2;
    
    pos = [xm, ym];

end