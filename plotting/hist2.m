% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function h=hist2(X,Y,v,type,srf)
%v=hist3([X Y],{vx,vy});
sigmaRejectionFlag = true;
if ~exist('type','var') || isempty(type); type='tile';  end %scatter, profile, pcolor
if exist('srf','var'); sigmaRejectionFlag = srf; end

switch type
    case 'profile'
        y = linspace(min(X),max(X),v);  if y(1)==y(end); y = linspace(min(X)-.5,max(X)+.5,v); end
        xi = fcnindex1c(double(y), double(X));  nxi=numel(y);  mu=zeros(1,nxi); s=mu;
        for i=1:nxi
            yi = Y(xi==i);
            yi = fcnsigmarejection(yi,4,3);
            mu(i) = nanmean(yi);
            s(i) = nanstd(yi);
        end
        h=errorbar(y,mu,s);        %fcnerrorbar(y,mu,s,s,c)
        h.DisplayName = sprintf(' {\\bf%.3g\\sigma}',nanmean(fcnsigmarejection(s,2,3)));
    case 'scatter'
        if iscell(v)
            i = X<max(v{1}) & X>min(v{1}) & Y<max(v{2}) & Y>min(v{2});
        else
            i = isfinite(X) & isfinite(Y);
        end
        X=X(i);  Y=Y(i);  h=plot(X,Y,'.');
    
    case 'tile'
        if ~iscell(v)
            if numel(v)==1; v(2)=v(1); end
            i = isfinite(X) & isfinite(Y);
            if sigmaRejectionFlag; [~,ja]=fcnsigmarejection(Y,6,1); [~,jb]=fcnsigmarejection(X,9,3); i = i & ja & jb; end %#ok<*UNRCH>
            X=X(i); vx = linspace(min3(X),max3(X),v(1));
            Y=Y(i); vy = linspace(min3(Y),max3(Y),v(2));
            v = {vx,vy};
        end
        
        if iscell(v)
            h=histogram2(X,Y,v{1},v{2},'DisplayStyle',type);
        else
            h=histogram2(X,Y,v,'DisplayStyle',type);
        end
        h.DisplayName = sprintf('\\mu_x = %.4g \\pm %.4g\n\\mu_y = %.4g \\pm %.4g',mean(X),std(X),mean(Y),std(Y));

        fcntight(gca,'csigma')
        %legend('Location','Best')
        
    case 'contour'
        if iscell(v)
            i = X<max(v{1}) & X>min(v{1}) & Y<max(v{2}) & Y>min(v{2});
        else
            i = isfinite(X) & isfinite(Y);
        end
        X=X(i);  Y=Y(i);  h=plot(X,Y,'.');
        
        Z = histcounts2(X,Y,v{1},v{2});  Xc=midspace(v{1}(1),v{1}(end),numel(v{1})-1);  Yc=midspace(v{2}(1),v{2}(end),numel(v{2})-1);
        contour(Xc,Yc,Z',8,'linewidth',1.5);
end
