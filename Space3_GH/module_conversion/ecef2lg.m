%% function 'ecef2lg'
%
% Transforms coordinates in ECEF to coordinates in LG
% ECEF: Earth Centered Earth Fixed Frame
% LG  : Local Geocentric Vertical Frame OR Local Geodetic Vertical Frame
%
% Inputs:   ->  Sat_ECEF                  = [x, y, z]' in ECEF frame
%           ->  Obv_LLH                     = [lat, lon, h]'|Observer Centric
%
% Outputs:  ->  Pos_LG                    = [x, y, z]' in LGV frame
%
% Kelvin Hsu
% AERO4701, 2016
%% Edited by Lydia Drabsch 5/3/16
% 1) convert observer Obs_LLH to Obs_ECEF
% 2) find vector pointing from observer to satellite Pos_ECEF=Sat_ECEF-Obs_ECEF
% 3) convert Obs_ECEF to polar coordinates [phi,theta,R]' ?? can just use
% long lat?
% 4) rotate Pos_ECEF using fixed angles about z by phi (Rz) then about y by -(pi-theta) (Ry) 
function Pos_LG = ecef2lg(Sat_ECEF, Obs_LLH,frame)
        % Earth's radius

    % step 1
    switch frame
        case 'd'
            Obs_ECEF = llhgd2ecef(Obs_LLH);   % detic not centric
        case 'c'
            Obs_ECEF = llhgc2ecef(Obs_LLH);   % detic not centric
        otherwise
            fprintf('error with frame definition');            
    end
    
    % step 2
    Pos_ECEF = Sat_ECEF-Obs_ECEF;
    
    % step 4
    
    Pos_LG = rot('y',-(pi/2+Obs_LLH(1,1)))*rot('z',Obs_LLH(2,1))*Pos_ECEF; 
    
end