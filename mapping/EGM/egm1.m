function zi = egm1(lat,lon,EGM) %xi=lats, yi=lngs
%elevations in meters above the wgs84 ellipsoid
%[x,y] = ndgrid(EGM.latbp,EGM.lonbp); %pcolor(x,y,F(-x,y);
if nargin==2 || isempty(EGM)
    EGM = load('EGM96single.mat');
end

lon = longitude360to180(lon);

F = griddedInterpolant({EGM.lonbp(:),EGM.latbp(:)},double(EGM.grid));  
zi=F(lon,-lat);