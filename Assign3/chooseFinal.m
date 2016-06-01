% prompt = {'Hessian','Enter colormap name:'};
% dlg_title = 'Input';
% num_lines = 1;
% defaultans = {'20','hsv'};
% answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

function Final = chooseFinal

    prompt = {'Final Period (sidereal days)','Final Eccentricity','Final Inclination','Final Right Ascending Node'};
    dlg_title = 'Imput Final Orbit parameters';
    num_lines = 1;
    defaultans = {'1','0','0','NaN'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

    Final.P = str2double(answer{1});
    Final.e = str2double(answer{2});
    Final.inc = str2double(answer{3});
    Final.Rasc = str2double(answer{4});
    
    
    
end


