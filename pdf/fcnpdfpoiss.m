function L = fcnpdfpoiss(k,lambda)
%lambda = poisson mean and variance
%k = evaluated at k

%Poisson negative log likelihood
L = -sum( (zN.*log(lambda) - lambda - k.poiss.gammaln) ); %from MATLAB poisspdf function. SLOWER, WORKS WITH NON INTEGER ZN's
%L = -( sum(log(lambda(k.poiss.z1))) + sum(k.poiss.zN2.*log(lambda(k.poiss.z2))) - sum(lambda) - k.poiss.gammalnsum ); %FASTER



% fig(1,1)
% lambda = 1.2;
% x = 0:1:6;
% y = poisspdf(x,lambda);
% stem(x,y,'b.','markersize',30)
% x = 0:.01:6;
% zN = x;
% y = exp( (zN.*log(lambda) - lambda - gammaln(zN+1))); %from MATLAB poisspdf function. SLOWER, WORKS WITH NON INTEGER ZN's
% plot(x,y,'g-'); fcnlinewidth(2)
% legend('Poisson Distribution,  f(k,  \lambda) = \lambda^ke^{-\lambda} / k!','Extended Poisson Distribution,  f(k,  \lambda) = e^{k log(\lambda) - \lambda - log\Gamma(k+1)}')
% ylabel('pdf / pmf'); xlabel('k'); title(sprintf('Extended Poisson Example  \\lambda = %.1f',lambda))
% grid on;
% fcnfontsize(10);
% export_fig(gcf,'-q95','-r150','-a4','exported.jpg','-native')

