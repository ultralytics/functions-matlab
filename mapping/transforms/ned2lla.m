% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [lla, ecef] = ned2lla(DEM,ned)
ecef = ned2ecef(DEM,ned);
lla = ecef2lla(ecef);


