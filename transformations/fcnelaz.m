function [el,az] = fcnelaz(x,y,z)
if nargin==1
    z = x(:,3);
    y = x(:,2);
    x = x(:,1);
end

xys = x.^2 + y.^2;

el = asin(-z./sqrt(xys + z.^2));
az = 2*atan((sqrt(xys)-x)./y);  %ea(:,2) = fcnatan2(cc(:,2),cc(:,1));

if nargout==1
    el(:,2) = az;
end

