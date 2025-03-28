% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function rpy = fcnVEC2RPY(cc)
%rpy = [phi theta psi]
%rpy = [zeros(nr,1)   asin(-z./r)   atan2(y,x)]; %rpy=[phi theta psi]
rpy = zeros(size(cc));
rpy(:,2) = asin(-cc(:,3)./(cc(:,1).^2+cc(:,2).^2+cc(:,3).^2).^.5);
rpy(:,3) = atan2(cc(:,2),cc(:,1)); 
