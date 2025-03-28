% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function mperdeg = fcnmperLLAdeg(LLA)
%from http://en.wikipedia.org/wiki/Latitude#The_length_of_a_degree_of_latitude
%determines the meters per degree longitude and latitude at any location (LLA) on the Earth's surface.
%LLA in deg
%latm = meters per latitude degree
%lngm = meters per longitude degree

a = 6378137.0; %equatorial radius (m)
e2 = 0.00669437999014; %eccentricity squared
phi = LLA(:,1)*(pi/180);

latm = pi*a*(1-e2)/(180*(1-e2*sin(phi).^2).^(3/2)); %1degree lat = this many km north-south
lngm = pi*a*cos(phi)/(180*sqrt(1-e2*sin(phi).^2)); %1degree lng = this many km east-west

mperdeg = [latm lngm];

%a (equatorial radius): 6,378,137.0 m
%1/f (inverse flattening): 298.257,223,563
%from which are derived
%b (polar radius): 6,356,752.3142 m
%e2 (eccentricity squared): 0.006,694,379,990,14
end

