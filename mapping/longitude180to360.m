function lon = longitude180to360(lon)
%lon (deg)
%converts [-180 to 180] to [0 to 360] deg format

%Used by readNOAA_NCAR.m

i = lon<0;
lon(i) = lon(i) + 360;


