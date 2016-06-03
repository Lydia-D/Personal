% prompt = {'Hessian','Enter colormap name:'};
% dlg_title = 'Input';
% num_lines = 1;
% defaultans = {'20','hsv'};
% answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

function Final = chooseFinal

    global d2r

    prompt = {'Final Period (sidereal days)','Final Eccentricity','Final Inclination (deg)','Final Right Ascending Node (deg)'};
    dlg_title = 'Imput Final Orbit parameters';
    num_lines = 1;
    defaultans = {'1','0','0','NaN'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

    Final.Pdays = str2double(answer{1});
    Final.e = str2double(answer{2});
    Final.inc = str2double(answer{3})*d2r;
    Final.Rasc = str2double(answer{4})*d2r;
    if isnan(Final.Rasc)
        Final.Rasc = pi; % just for inclination calculation
        Final.FlagRasc = 1;
    else
        Final.FlagRasc = 0;
    end
    
    
end


