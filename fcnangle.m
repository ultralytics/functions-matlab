% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [theta, ct] = fcnangle(a,b)
%theta (radians)

if nargin==2
    ct = (a(:,1).*b(:,1) + a(:,2).*b(:,2) + a(:,3).*b(:,3))./(sqrt(a(:,1).^2+a(:,2).^2+a(:,3).^2).*sqrt(b(:,1).^2+b(:,2).^2+b(:,3).^2));
else %nargin==1    %vec2 = [1 0 0];
    ct = a(:,1)./sqrt(a(:,1).^2+a(:,2).^2+a(:,3).^2);
end
theta = acos(ct);

%check for imaginary component (caused by poor numerical precision)
if ~isreal(theta)
    ct = max(min(ct,1),-1);
    theta = acos(ct);
end

