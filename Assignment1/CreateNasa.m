
function [Nasa_A,Nasa_R] = CreateNasa()
nasa = wmsfind('nasa', 'SearchField', 'serverurl');
layer = nasa.refine('bluemarbleng',  'SearchField', 'layername', ...
   'MatchType', 'exact');
[Nasa_A, Nasa_R] = wmsread(layer);
% figure
% axesm globe
% axis off
% geoshow(A, R)
end