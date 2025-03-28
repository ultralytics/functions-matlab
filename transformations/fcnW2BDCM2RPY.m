% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function rpy = fcnW2BDCM2RPY(DCM)
% phi = atan(DCM(2,3)/DCM(3,3));
% theta = asin(-DCM(1,3));
% psi = atan2(DCM(1,2),DCM(1,1));
% rpy = [phi theta psi];
rpy = zeros(1,3);

rpy(1) = atan(DCM(2,3)/DCM(3,3));
rpy(2) = real(asin(-DCM(1,3)));
rpy(3) = atan2(DCM(1,2),DCM(1,1));
