function ecef = lla2ecef(lla)
%lla = [lat (deg), lng (deg), altitude (m)]
%ecef = km

d2r = pi/180;
f = (1-1/298.257223563)^2; %WGS84 flattening
R = 6378.1370; %WGS84 equatorial radius (km)

lat = lla(:,1)*d2r;
lng = lla(:,2)*d2r;
alt = lla(:,3)/1000;


lambda = atan(f*tan(lat)); %mean sea level at lat
slambda = sin(lambda);
clambda = cos(lambda);

r = sqrt( R^2./(1+(1/f-1)*slambda.^2) ); %radius at surface point
k1 = r.*clambda + alt.*cos(lat);

ecef = zeros(numel(lat),3);
ecef(:,1) = k1.*cos(lng);
ecef(:,2) = k1.*sin(lng);
ecef(:,3) = r.*slambda + alt.*sin(lat);



