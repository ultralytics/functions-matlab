% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function i = fcnindex1(xi, x, method)
%str could be:
%'*nearest'
%'*exact'

idxi = (numel(xi) - 1)/(xi(end)-xi(1));
ik = xi(1)*idxi - 1;

if nargin == 2 %'*nearest'
    i = uint32(x*idxi-ik); %faster than 'round((x-k)*idxi)'
    %i = uint32(interp1c(xi,1:numel(xi),x(:)));   
else %'*exact'
    i = x*idxi-ik;
end
