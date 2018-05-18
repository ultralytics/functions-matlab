function [r, dx, rs] = fcnrange(v1,v2)
%accepts nx3 column vectors

if nargin==1 
    dx=v1;
else
    dx=v2-v1;
end
nc = size(dx,2);

switch nc
    case 3
        rs = dx(:,1).^2+dx(:,2).^2+dx(:,3).^2;
    case 2
        rs = dx(:,1).^2+dx(:,2).^2;
    otherwise
        sum(dx.^2,2);
end
r=sqrt(rs);