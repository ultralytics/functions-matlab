% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function alt = lla2ag(lla)
%lla (ellipsoid) to altitude (geoid)
lla = lla2llag(lla);
alt = lla(:,3);
end

