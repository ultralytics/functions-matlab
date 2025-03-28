% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function zi = WMM(lat,lon,type)
%WORLD MAGNETIC MODEL
%INPUTS: lat (deg -90 to 90), lng (deg -180 to 180), type={'Declination','Inclination','HorizontalIntensity','TotalIntensity','X','Y','Z'}
%http://www.ngdc.noaa.gov/geomag/WMM/DoDWMM.shtml
%1 Tesla = 10,000 Gauss
if nargin<3 || isempty(type)
   type = 'TotalIntensity'; 
end

fname = ['igrfgridData' type '.csv'];
fid=fopen(fname,'r');  A=textscan(fid, '%f%f%f%f%f%f%f', inf, 'Delimiter', ',', 'EmptyValue' ,NaN,'HeaderLines',14);  fclose(fid);  A = [A{:}];

s=[361 180]; WMM.lat=reshape(A(:,2),s); WMM.lon=reshape(A(:,3),s); WMM.grid=reshape(A(:,5),s);
F = griddedInterpolant(WMM.lon,-WMM.lat,WMM.grid,'cubic','none');  


if nargin==0 || isempty(lat)
    n=180; [lat,lon]=meshgrid(linspace(-1,1,n)*90,linspace(-1,1,n*2)*180);  zi=F(lon,-lat);
    h=fig(1,1,2,4);  pcolor(WMM.lon,WMM.lat,WMM.grid); shading flat; colorbar; colormap(parula); title(['World Magnetic Model 2015: ' type ]); fcntight('cxy'); coasts(h);
else
    lon = longitude360to180(lon);
    zi=F(lon,-lat);
end


