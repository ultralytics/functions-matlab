% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function y = fcnpdfnorm(x,mu,sigma)
if nargin < 3
    sigma = 1;
    if nargin < 2;  mu = 0;  end
end

y = exp(-0.5 * ((x - mu)./sigma).^2) ./ (sqrt(2*pi)*sigma);
