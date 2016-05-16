function alt_km=ITU_P1511(lat,long)
%function alt_km=ITU_P1511(lat,long)
%computes altitude of a site at given lat,long coordinates
%by means of bicubic interpolation using itu topo 0.5 degrees resolution
%matrix.
%refer to ITU-R Recommendation P 1511.

%
%INPUTS
%lat: latitude + = North, -=south
%long: longitude, positive degrees East.
%
%Required data: TOPO_0d5.txt, available from the ITU-R SG3 software site
%http://www.itu.int/ITU-R/study-groups/software/rsg3-p1511-topography.zip
%http://www.itu.int/ITU-R/index.asp?category=documents&link=rsg3&lang=en
%example of usage:
%alt_km=ITU_P1511(52,0); %somewhere in the UK
%Luis Emiliani. Rel. 16/01/2009

I=find(long<0);
if isempty(I)==0
    long(I)=long(I)+360;
end
clear I
    ITUTopo_0d5=load('./Topo_0dot5.txt');
    [Mlat0d5 Mlon0d5]=meshgrid([90:-0.5:-90]',[0:0.5:360]');
    Mlat0d5=Mlat0d5'; Mlon0d5= Mlon0d5'; %goal dimension is 361x721
    alt_km=abs( interp2(Mlon0d5,Mlat0d5,ITUTopo_0d5(2:362,2:722),long,lat,'cubic') ); %note that this is a dangerous way of doing things
 
end