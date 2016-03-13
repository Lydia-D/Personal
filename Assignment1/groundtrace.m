%% plotting ground trace
figure(2)
clf
geoshow('landareas.shp', 'FaceColor', [0.5 1.0 0.5]);
h = animatedline;%('LineWidth',0,'Marker;
for i=1:1:size(X_LLH,2)
    % latitude is X_LLH(1,:) but the y axis on geoshow
    addpoints(h,rad2deg(X_LLH(2,i)),rad2deg(X_LLH(1,i)))
    drawnow
end

% geoshow(rad2deg(X_LLH(1,1:10)),rad2deg(X_LLH(2,1:10)),'DisplayType','Multipoint')