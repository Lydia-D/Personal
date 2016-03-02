%% function 'ecef2lg'
%
% Transforms coordinates in ECEF to coordinates in LG
% ECEF: Earth Centered Earth Fixed Frame
% LG  : Local Geocentric Vertical Frame OR Local Geodetic Vertical Frame
%
% Inputs:   ->  X_ECEF                  = [x, y, z]' in ECEF frame
%           ->  LLH                     = [lat, lon, h]'|Observer Centric
%
% Outputs:  ->  X_LGDV                  = [x, y, z]' in LGV frame
%
% Kelvin Hsu
% AERO4701, 2016

function pos_lg = ecef2lg(pos_ecef, pos_llh_ground)
    

end