% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function dx = fcndiff(x,n,dim)
if nargin==2
    dim=n; %dimension to take derivative along
    n=1; %first derivative
end
s = size(x);  s(dim)=n;

a=diff(x,n,dim);

zm = zeros(s);
dx=cat(dim, zm, a);
