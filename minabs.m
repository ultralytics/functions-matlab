% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function y = minabs(x,dim)
%same as min, but returns values closest to zero while retaining sign

if nargin==1
    dim=1; %min of each row
end

a = x; a(a<0)=inf;
b = x; b(b>0)=-inf;

a=min(a,[],dim);
b=max(b,[],dim);

c=abs(a)<abs(b);

y = zeros(size(a));
y(c) = a(c);
y(~c) = b(~c);

