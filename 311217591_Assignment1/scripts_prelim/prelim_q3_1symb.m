% prelim_q3_1


% function answer = prelim_q3_1()
    global r_earth
    
    Sat_ECEF_global = [-6763200;3940900;5387700]; % given, meters
    Sat_LLH_global = ecef2llhgc(Sat_ECEF_global);
    
    % Unit vector of line of sight from satellite position
    Landunit_LG_sat_polar = [1;deg2rad(-131.57);deg2rad(-30.40)]; % unit vector
    Landunit_LG_sat_cat = polar2cartesian(Landunit_LG_sat_polar);
    Landunit_ECEF_sat = lg2ecef(Landunit_LG_sat_cat,Sat_LLH_global);
    
    %% Create line equation (intersection of 2 planes) from unit vector
    % about satellite position. unit vector of direction of line [a,b,c]
    % and origin at [x1,y1,z1]
    syms X Y Z
    % z = c/a(x-x1) + z1 
%         Xplane = solve((X-Sat_ECEF_global(1,1))*(Landunit_ECEF_sat(3,1)/Landunit_ECEF_sat(1,1))+Sat_ECEF_global(3,1)-Z == 0,...

    Intersect = solve([(X-Sat_ECEF_global(1,1))*(Landunit_ECEF_sat(3,1)/Landunit_ECEF_sat(1,1))+Sat_ECEF_global(3,1)-Z == 0,...
    ((Y-Sat_ECEF_global(2,1))*(Landunit_ECEF_sat(3,1)/Landunit_ECEF_sat(2,1))+Sat_ECEF_global(3,1)-Z) == 0,...
    X^2+Y^2+Z^2-r_earth^2 == 0],[X,Y,Z])
% z = c/b(y-y1) + z1     
%     Yplane =  solve((Y-Sat_ECEF_global(2,1))*(Landunit_ECEF_sat(3,1)/Landunit_ECEF_sat(2,1))+Sat_ECEF_global(3,1)-Z == 0,Z);
   
% sphere: 0= x^2+y^2+z^2 - r^2
%     sphere = solve( X^2+Y^2+Z^2-r_earth^2 == 0,Z,Y)
    
    
    
% end