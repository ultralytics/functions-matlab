% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [mu,s,F,x] = movingMean(X,Y,x,plotflag)
%X = x data
%Y = y data
%x = output statistics locations (or number of bins)
if numel(x)==1; nb=x; x=linspace(min3(X),max3(X),nb); end; x=x(:);
if nargin<4; plotflag=0; end

range = x(end)-x(1); sigma=range*.02;


mu=zeros(nb,1); s=mu;
for i=1:nb
   w = pdf('norm',X,x(i),sigma);
   [mu(i),s(i)] = weightedMean(Y,w);
end

if plotflag
    plot(x,mu,'DisplayName','\mu','Linewidth',1,'Color',[1 1 1]*.8); 
    plot([x; nan; x],[mu+s; nan; mu-s],'DisplayName','1\sigma','Linewidth',1,'Color',[1 1 1])
end

if nargout>2
    [~,i]=unique(x);  if numel(i)==1; i=[i i]; end;  x=x(i); mu=mu(i); s=s(i);  if numel(i)==2; x(2)=x(2)+1; end
    F.mu=griddedInterpolant(x,mu,'linear','nearest');
    F.s=griddedInterpolant(x,s,'linear','nearest');
end
