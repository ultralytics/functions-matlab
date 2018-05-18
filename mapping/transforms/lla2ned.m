function [ned, ecef] = lla2ned(DEM,lla)

if nargin==1
    ecef = lla2ecef(DEM); %'DEM' is really 'lla'
    ned = ecef2ned(ecef);
else
    ecef = lla2ecef(lla);
    ned = ecef2ned(DEM,ecef);
end
