%% function 'lg2ecef'
%
% Transforms coordinates in LG to coordinates in ECEF
% LG  : Local Geocentric Vertical Frame OR Local Geodetic Vertical Frame
% ECEF: Earth Centered Earth Fixed Frame
%
% Inputs:   ->  Sat_LG            = [N, E, D]' catesian in LG frame of Observer
%           ->  Obs_LLH           = [lat, lon, h]'|Observer
%
% Outputs:  ->  Pos_ECEF            = [x, y, z]' in ECEF frame
%
% Kelvin Hsu
% AERO4701, 2016
%% Edited: Lydia Drabsch 6/3/16
% NOTE: radius of earth included in llhgx2ecef
% 1) transform Sat_LG to Sat_ECEF by rotating about y (+ve)  by pi-theta
% then about z (-ve) by phi
% 2) transform Obs_LLH to Obs_ECEF using llhgc2ecef
% 3) get position vector Pos_ECEF=Obs_ECEF+Sat_ECEF
function Vec_ECEF = lg2ecef(Sat_LG, Obs_LLH)
    
% euler angles
    Vec_ECEF = rot('z',-Obs_LLH(2,1))*rot('y',pi/2+Obs_LLH(1,1))*Sat_LG;
%     Sat_ECEF = rot('y',pi-Obs_LLH(1,1))*rot('z',-Obs_LLH(2,1))*Sat_LG;
    
%     switch frame
%         case 'd'
%             Obs_ECEF = llhgd2ecef(Obs_LLH);  % detic
%         case 'c'
%             Obs_ECEF = llhgc2ecef(Obs_LLH);  % centric
%         otherwise
%             fprintf('error with frame definition');
%     end
%     Pos_ECEF = Obs_ECEF+Sat_ECEF;
    
    

end