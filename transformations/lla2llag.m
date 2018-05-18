function lla = lla2llag(lla,EGM)
if nargin==1;  EGM = load('EGM96single.mat');  end
lla(:,3) = lla(:,3) - egm1(EGM,lla(:,1),lla(:,2));
end

function [zi] = egm1(EGM,xi,yi) %xi=lats, yi=lngs 
%RETURNS ELEVATIONS IN METERS!
% [x,y] = meshgrid(EGM.latbp,input.EGM.lonbp);
% zi = interp2(x,y,EGM.grid,xi,yi,'*linear')

if numel(EGM.lonbp)<2000 %EGM96
    %zm = EGM.grid(9:1449,9:729);
    latv = EGM.latbp(9:729);
    lonv = EGM.lonbp(9:1449);
    nwi = 8;
else %EGM2008
    %zm = EGM.grid(8:8648,8:4328);
    latv = EGM.latbp(8:4328);
    lonv = EGM.lonbp(8:8648);
    nwi = 7; %number of wrapped indices
end
nrows = numel(latv);
ncols = numel(lonv);
scale = (nrows-1)/180; %pixels per deg

%GET SUITABLE LIMITS ON LAT LON MATRIX BEFORE PASSING TO INTERP2 ----------
latlim = [max(min(xi),-90)    min(max(xi),90)]; %put a ceiling at the poles
lnglim = [min(yi) max(yi)];
dp = 1;

rows = (  max(round(90*scale-latlim(2)*scale - 2*dp),1) : dp : min(round(90*scale-latlim(1)*scale + 2*dp),nrows)  )'; %add 2 pixels for buffer zone when interpolating
lats = 90 - (rows-1)/scale;

cols = (  round(180*scale+lnglim(1)*scale - 2*dp) : dp : round(180*scale+lnglim(2)*scale + 2*dp)  )';
lngs = (cols-1)/scale - 180;
cols = max(mod(cols,ncols),1); %wrap at the negative prime meridian

%[x,y] = meshgrid(lats,lngs);
z = EGM.grid(cols+nwi,rows+nwi); %smaller subset of the huge etopo1 database
zi = interp2(lats,lngs,z,xi,yi,'*linear');
end