% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function y = minnonzero(x,dim)
%same as min, but returns values closest to zero rather than 0

if nargin==1
    dim=1; %min of each row
end

x(x==0)=inf;
y = min(x,[],dim);

if y==inf; y=0; end


