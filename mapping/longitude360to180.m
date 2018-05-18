function lon = longitude360to180(lon)
%lon (deg)
%wraps longitudes past -180 and 180. 
%converts [0 to 360] to [-180 to 180] deg format

%Used by egm1.m, etopo1.m, readNOAA_NCAR.m

if max(lon(:))>180
    s = sign(lon);
    i=(lon.*s)>180; 
    lon(i) = lon(i) - 360*s(i); %y wrapped
end

