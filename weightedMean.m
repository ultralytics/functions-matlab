% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [mu, sigma] = weightedMean(x,w,dim)
%x = NxM, weights = Nx1

i=~(isfinite(x) & isfinite(w)); x(i)=0; w(i)=0;
if nargin<3; dim=1; end
w = w./sum(w,dim);

mu = sum(w.*x,dim);

if nargout==2
    dx = x-mu;
    sigma = sqrt( sum(w.*dx.^2,dim) );
end