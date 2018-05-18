function varargout = winkel(varargin)
%REPLACE MATLAB NATIV FUNCTION winkel.m with this one!!!!

%WINKEL  Winkel I Pseudocylindrical Projection
%
%  This projection is an arithmetical average of the x and y coordinates of
%  the Sinusoidal and Equidistant Cylindrical projections.  Scale is true
%  along the standard parallels, and is constant along any parallel and
%  between any pair of parallels equidistant from the Equator. There is no
%  point free of distortion.  This projection is not equal area, conformal,
%  or equidistant.
%
%  This projection was developed by Oswald Winkel in 1914.  Its limiting
%  form is the Eckert V when a standard parallel of 0 degrees is chosen.

% Copyright 1996-2011 The MathWorks, Inc.

mproj.default = @winkelDefault;
mproj.forward = @winkelFwd;
mproj.inverse = @winkelInv;
mproj.auxiliaryLatitudeType = 'geodetic';
mproj.classCode = 'Pcyl';

varargout = applyProjection(mproj, varargin{:});

%--------------------------------------------------------------------------

function mstruct = winkelDefault(mstruct)

[mstruct.trimlat, mstruct.trimlon, mstruct.mapparallels] ...
    = fromDegrees(mstruct.angleunits,...
                 [-90  90], [-180 180], dm2degrees([50 28]));

mstruct.nparallels   = 1;
mstruct.fixedorient  = [];

%--------------------------------------------------------------------------

function [x, y] = winkelFwd(mstruct, lat, lon)
% [a, phi1, factor1] = deriveParameters(mstruct);
% x = a * lon .* (cos(phi1) + cos(lat)) / factor1;
% y = 2 * a * lat / factor1;
lambda  = lon;   %longitudes i.e. size 360x180
phi     = lat;   %latitudes  i.e. size 360x180
a = acos(cos(phi).*cos(lambda/2));  a(a==0)=eps;
x = .5*(lambda.*2/pi + ((2*cos(phi).*sin(lambda/2))./(sin(a)./a)));
y = .5*(phi + sin(phi)./(sin(a)./a));

%--------------------------------------------------------------------------

function [lat, lon] = winkelInv(mstruct, x, y)

[a, phi1, factor1] = deriveParameters(mstruct);

lat = factor1 * y / (2*a);
lon = factor1 * x ./ (a*(cos(phi1) + cos(lat)) );

%--------------------------------------------------------------------------

function [a, phi1, factor1] = deriveParameters(mstruct)

a = ellipsoidprops(mstruct);
phi1 = toRadians(mstruct.angleunits, mstruct.mapparallels(1));
if phi1 == 0
    factor1 = sqrt(2 + pi);
else
    factor1 = 2;
end

