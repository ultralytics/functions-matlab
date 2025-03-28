% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function y = fcnpdfEMG(x,mu,sigma,lambda)
%http://en.wikipedia.org/wiki/ExGaussian_distribution

erfcv = 1 - erf( ((mu+lambda*sigma^2) - x)/(sqrt(2)*sigma) );
y = (lambda/2) * exp( lambda * ((mu+lambda/2*sigma^2) - x) ).* erfcv;





% x = linspace(-1,6,10000);
% mu = 0;
% sigma = .5;
% lambda = 1/2.2;
% 
% erfcv = 1 - erf( ((mu+lambda*sigma^2) - x)/(sqrt(2)*sigma) );
% yemg = (lambda/2) * exp( lambda * ((mu+lambda/2*sigma^2) - x) ).* erfcv;
% yexp = exppdf(x,1/lambda);
% ynormal = normpdf(x,mu,sigma);
% 
% fig;
% plot(x,yemg,'r',x,yexp,'g',x,ynormal,'b');
% xlabel('x (ns)')
% ylabel('pdf'); box on; grid on; fcnlinewidth(2); legend('EMG distribution f(\mu,\sigma,\lambda)','exponential distribution f(\lambda)','normal distribution f(\mu,\sigma)')
% title(sprintf('EMG distribution comparison.  \\mu = %.1f,  \\sigma = %.2f,  \\lambda = 1/%.1f',mu,sigma,1/lambda))
% fcnfontsize(12); 
% 
% export_fig(gcf,'-q95','-r150','-a4','exported.jpg','-native')