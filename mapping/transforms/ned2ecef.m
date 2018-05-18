function [ ecef ] = ned2ecef(DEM,ned)
ecef = ned*DEM.DCM_ECEF2NED + ones(size(ned,1),1)*DEM.centerecef;




% function ned = ecef2ned(DEM,ecef)
% dx = [ecef(:,1)-DEM.centerecef(1), ecef(:,2)-DEM.centerecef(2), ecef(:,3)-DEM.centerecef(3)]; %translation
% ned = dx*DEM.DCM_ECEF2NED'; %rotation
% end