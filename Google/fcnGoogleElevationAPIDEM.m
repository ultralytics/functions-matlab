function DEM = fcnGoogleElevationAPIDEM(latv,lngv,geoidstr)
ni = numel(latv); 
[DEM.lat, DEM.lng] = meshgrid(latv, lngv);
DEM.latv=DEM.lat(:);
DEM.lngv=DEM.lng(:);

DEM.altv  = fcnGoogleElevation(DEM.latv,DEM.lngv);
if nargin==3 && strcmp(geoidstr,'geoid')
    %geoid elevations used
elseif nargin==2
    lla = llag2lla([DEM.latv DEM.lngv DEM.altv]); %geoid elevations to ellipsoid elevations
    DEM.altv = lla(:,3);
end
DEM.alt = reshape(DEM.altv,[ni ni]);

% zm = zeros(ni,ni);
% DEM.lat = zm;
% DEM.lng = zm;
% DEM.alt = zm;
% xv = linspace(-1,1,ni);
% yv = xv;
% for i=1:ni
%     fprintf('row %.0f\n',i)
%     for j=1:ni
%         z = hge.GetPointOnTerrainFromScreenCoords(xv(i), yv(j));
%         DEM.lat(i,j) = get(z,'Latitude');
%         DEM.lng(i,j) = get(z,'Longitude');
%         DEM.alt(i,j) = get(z,'Altitude');
%     end 
% end

DEM.lla = [DEM.latv DEM.lngv DEM.altv];
DEM.centerlla = [mean(latv) mean(lngv) 0];
DEM.centerecef = lla2ecef(DEM.centerlla);

DEM.DCM_ECEF2NED = fcnLLA2DCM_ECEF2NED(DEM.centerlla*d2r); %NOT OK!!!

DEM.ecef = lla2ecef(DEM.lla); %ok
DEM.ned = [DEM.ecef(:,1)-DEM.centerecef(1), DEM.ecef(:,2)-DEM.centerecef(2), DEM.ecef(:,3)-DEM.centerecef(3)]*DEM.DCM_ECEF2NED'; %NOT OK
DEM.nedx = reshape(DEM.ned(:,1),[ni ni]);
DEM.nedy = reshape(DEM.ned(:,2),[ni ni]);
DEM.nedz = reshape(DEM.ned(:,3),[ni ni]);
DEM.delaunayfaces = delaunay(DEM.lng,DEM.lat);

DEM.F = scatteredInterpolant(DEM.lngv, DEM.latv, DEM.altv); %ok
DEM.Fned = scatteredInterpolant(DEM.ned(:,1), DEM.ned(:,2), DEM.altv); %ok

DEM.centerlla(3) = DEM.F(DEM.centerlla(2),DEM.centerlla(1));
end