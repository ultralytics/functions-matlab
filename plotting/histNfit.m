% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [f, gof] = histNfit(x,y,c,rotateplot)
%plots a normal fit to the peak histogram data
if nargin<3 || isempty(c);  c='b';  end
if nargin<4 || isempty(rotateplot);  rotateplot=false;  end

[x,y] = prepareCurveData(x,y);
%mu0 = sum(x.*y)/sum(y);
%s0 = max(x)/30-min(x)/30;

% Set up fittype and options.
ft = fittype( 'gauss1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
%opts.Display = 'Off';
%opts.StartPoint = [1 mu0 s0];
opts.StartPoint = [1 173 2];


if sum(y~=0)<3; f=[]; return; end %NOT ENOUGH POINTS!

try
    %[f, gof] = fit( x, y, ft, opts );% Fit model to data
    [f, gof] = fit( x, y, ft );% Fit model to data
catch
    f=[]; gof=[]; fprintf('Warning: histNfit failed!\n')
    return
end

mu = f.b1;
s = f.c1/sqrt(2); %sigma
%s = 1/(f.a1*sqrt(2*pi));
i = (x > mu-3*s) & (x < mu+3*s); %interp fcn needs 9 pts

if any(i) && nargin>2
    xi=x(i);  %yi=y(i);
    xi=linspace(xi(1),xi(end),numel(xi)*8);
    fxi=f(xi);
    
    if rotateplot; xj=xi; xi=fxi; fxi=xj; end %rotate sideways for hist211
    plot(xi,fxi,'-','linewidth',2,'color',c,'displayname',sprintf('%.3g \\pm %.3g',mu,s));
end
legend show