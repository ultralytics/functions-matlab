% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function y = fcncdfnorm(x,mu,s)
%x should be row vector
%mu should be col vector
%s should be scalar

den = sqrt(2*s^2);

k = x./den - mu(:)./den;
y = .5 + .5*erf(k);

%y = .5*(1 + erf((x-mu)./sqrt(2*s^2)));


