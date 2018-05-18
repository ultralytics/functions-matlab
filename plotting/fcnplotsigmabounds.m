function [mu, s, xvc] = fcnplotsigmabounds(confidence,nbins)
%confidence = confidence bounds to plot, from 0 to 1. If no arguments passed, assumes confidence = 0.683
%example x = rand(500,1)*10; y = (x+randn(500,1)).^2; fig; plot(x,y,'b.',x,max(y)-y,'g.'); fcnplotsigmabounds

hc = findobj(gca,'Type','line');
nc = numel(hc);
sm = 1;

if nargin<2;
    if nargin==1 %plot 1sigma bounds
        sm = fcnconfidence2sigma(confidence); %sigma multiple
    end
    nbins = 30;
end


zv = zeros(1,nbins);
for i=1:nc;
    X = double(get(hc(i),'XData'));
    Y = double(get(hc(i),'YData'));
    c = get(hc(i),'Color');
    
    j = isfinite(X) & isfinite(Y);
    if ~all(j)
       X = X(j);
       Y = Y(j);
    end
    
    mu = zv;
    s = zv;
    xve = linspace(min(X)-eps,max(X)+eps,nbins+1); %xvector edges
    xvc = xve(1:end-1)/2 + xve(2:end)/2; %xvector centers
    
    xvc([1 end]) = xve([1 end]); %xvector plot (first and last xvc are set to xve values)
    for bin = 1:nbins
        j = X>(xve(bin)) & X<=(xve(bin+1));
        if any(j)
            yj = Y(j);
            mu(bin) = mean(yj);
            if numel(yj)>1
                s(bin) = fcnstd(yj,mu(bin));
            end
        end
    end

    h=errorarea(xvc,mu,s*sm,c);  set(h(1),'DisplayName','\mu'); set(h(2),'DisplayName',sprintf('%.2g\\sigma',sm))
    %h=errorbar(xvc,mu,s*sm,'.-','color',c,'markersize',1);
end



