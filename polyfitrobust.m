% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [P,F] = polyfitrobust(X,Y,N,srl,ni,residuals)
if nargin<4 || isempty(srl); srl=3; end
if nargin<5 || isempty(ni); ni=3; end
if nargin<6 || isempty(residuals); residuals='vertical'; end
X0=X; Y0=Y; 

if strcmp(residuals,'horizontal')
    j=X;  X=Y; Y=j; clear j  %switch X and Y
end

P=polyfit(X,Y,N);
for i=1:ni
    e=Y-polyval(P,X);  s=std(e);
    j=abs(e)<s*srl;  X=X(j); Y=Y(j);
    P = polyfit(X,Y,N);
end

x=linspace(min(X(:)),max(X(:)),1000);
switch residuals
    case 'vertical'        % do nothing
        F = griddedInterpolant(x,polyval(P,x),'linear');

    case 'horizontal'
        P = polyfit(polyval(P,x),x,N);
        j=X;  X=Y; Y=j; clear j  %switch X and Y
                F = griddedInterpolant(x,polyval(P,x),'linear');

end


plotflag=true;
if plotflag
    fig; plot(X0,Y0,'.','Display','All');
    plot(X,Y,'.','Display','Inliers'); xyzlabel('input','output')
    x=fcnsigmarejection(X,6,3); x=linspace(min3(x),max3(x),1000);
    plot(x,polyval(P,x),'-','Display',sprintf('%g%s Order Polynomial',N,prefix(N)));
    fcnmarkersize(10); fcnlinewidth(2); fcntight; legend show
end
end


function s=prefix(n)
switch n
    case 1
        s='st';
    case 2
        s='nd';
    case 3
        s='rd';
    otherwise
        s='th';
end
end