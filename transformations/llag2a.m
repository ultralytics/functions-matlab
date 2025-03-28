% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function alt = llag2a(lla)
%llag (geoid) to altitude (ellipsoid)
lla = llag2lla(lla);
alt = lla(:,3);
end

