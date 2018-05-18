function [y, x, h] =  fcnhist(z,x,c,plottype,displayname)
if nargin==1; x=30; end;  nx = numel(x);  if size(z,1)==1; z=z(:); end
z=double(z(isfinite(z)));
tol = 1E-9; 

histcflag = 0;
sigmarejectionflag = 1;

if isempty(z)
    if nx==1;  nx=x; x=zeros(nx,1);  end
    y = zeros(nx,1);
else
    if nx==1;  nx=x;
        if sigmarejectionflag;  zr=fcnsigmarejection(z,6,3); xa=min(zr); xb=max(zr);  else  xa=min(z); xb=max(z);  end
        if histcflag;  x=midspace(xa-tol,xb+tol,nx);  else  x=linspace(xa-tol,xb+tol,nx);  end
    end
    xi = fcnindex1c(x, z);    
    xi = min(max(xi,1),nx);
    y = accumarray(xi, 1, [nx 1]);
    
%     xi = discretize(z, x-(x(2)-x(1))/2);
%     y = accumarray(xi(isfinite(xi)), 1, [nx 1]);
end
if isrow(x); y=y(:)'; end

%PLOTTING
if nargout==0 || nargout==3 || (nargin>3 && ~isempty(plottype)) %then plot results
    if nargin<3 || isempty(c);  c=fcndefaultcolors(1);  end
    if nargin<4 || strcmp(plottype,'bar')
        h=bar(x,y,1,'edgecolor',c,'facecolor',fcnlightencolor(c));  %set(get(h,'children'),'facealpha',.7,'edgealpha',.7)
    else %plottype = 'line'
        h=plot(x,y,'.-','color',c);
    end
    %axis tight; grid on;
    
    if nargin>4 && ~isempty(displayname)
        %h.DisplayName = displayname;
        h.DisplayName = sprintf('%s (%.2g \\pm %.2g)',displayname,mean(z),std(z));
    else
        h.DisplayName = sprintf('%.2g \\pm %.2g',mean(z),std(z));
    end
end

%histNfit(x,y,'b'); legend show