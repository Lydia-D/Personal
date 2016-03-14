
function [A,R] = CreateNasa()
nasa = wmsfind('nasa', 'SearchField', 'serverurl');
layer = nasa.refine('bluemarbleng',  'SearchField', 'layername', ...
   'MatchType', 'exact');
[A, R] = wmsread(layer);
% figure
% axesm globe
% axis off
% geoshow(A, R)
end