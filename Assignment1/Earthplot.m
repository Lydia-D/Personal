% Function to plot earth
% By Lydia Drabsch adapted from PlotEarthSphere.m (Bryson, 2007)

function Earthplot()
    hold on
    load('topo.mat','topo');

    % Create a sphere, make it earth sized (in meters)
    [x,y,z] = sphere(50);
    x = -x.*6378000;
    y = -y.*6378000;
    z = z.*6378000;

    props.FaceColor= 'texture';
    props.EdgeColor = 'none';
    props.FaceLighting = 'phong';
    props.Cdata = topo;

    % Plot Earth
    axes('dataaspectratio',[1 1 1],'visible','on')
    hold on
    surface(x,y,z,props);
end