% ECEF2LLA - convert earth-centered earth-fixed (ECEF)
%            cartesian coordinates to latitude, longitude,
%            and altitude
%
% USAGE:
% [lat,lon,alt] = ecef2lla(x,y,z)
%
% lat = geodetic latitude (radians)
% lon = longitude (radians)
% alt = height above WGS84 ellipsoid (m)
% x = ECEF X-coordinate (m)
% y = ECEF Y-coordinate (m)
% z = ECEF Z-coordinate (m)
%
% Notes: (1) This function assumes the WGS84 model.
%        (2) Latitude is customary geodetic (not geocentric).
%        (3) Inputs may be scalars, vectors, or matrices of the same
%            size and shape. Outputs will have that same size and shape.
%        (4) Tested but no warranty; use at your own risk.
%        (5) Michael Kleder, April 2006

function [lla] = ecef2lla(xyz) %input in km, output in deg and meters
x = xyz(:,1)*1000;
y = xyz(:,2)*1000;
z = xyz(:,3)*1000;


% WGS84 ellipsoid constants:
a = 6378137;
es = (8.1819190842622e-2)^2;

% calculations:
b   = sqrt(a^2*(1-es));
ep  = (a^2-b^2)/b^2;

p   = sqrt(x.^2+y.^2);
th  = atan2(a*z,b*p);
lon = atan2(y,x);
lat = atan2((z+ep^2.*b.*sin(th).^3),(p-es^2.*a.*cos(th).^3));
N   = a./sqrt(1-es.*sin(lat).^2);
alt = p./cos(lat)-N;

% return lon in range [0,2*pi)
%lon = mod(lon,2*pi); %atan2 should handle this fine

% correct for numerical instability in altitude near exact poles:
% (after this correction, error is about 2 millimeters, which is about
% the same as the numerical precision of the overall function)

k=abs(x)<1 & abs(y)<1;
alt(k) = abs(z(k))-b;

lla = zeros(size(xyz));
lla(:,1) = lat*(180/pi);
lla(:,2) = lon*(180/pi);
lla(:,3) = alt;
