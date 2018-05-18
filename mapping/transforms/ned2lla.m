function [lla, ecef] = ned2lla(DEM,ned)
ecef = ned2ecef(DEM,ned);
lla = ecef2lla(ecef);


