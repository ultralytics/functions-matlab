function h=errorarea(varargin)
%can also be called 'errorarea(x,mu,s) or errorarea(x,mu,s,c)
%like errorbar but plots an area instead
%See fcnplotsigmabounds.m for example
%errorbar(xvc,mu,s,'.-','color',c,'markersize',1); %equivalent errorbar fcn
if isgraphics(varargin{1})
    ha=varargin{1}; varargin=varargin(2:end);
else
    ha=gca;
end
x=varargin{1};
mu=varargin{2};
sl=varargin{3}; 
if numel(varargin)==4 
    su=sl;
    c=varargin{4};
else
    su=varargin{4};
    c=varargin{5};
end


c = fcnstr2rgbcolor(c);
cl = fcnlightencolor(c,.75);
x=x(:)';
mu=mu(:)';
sl=sl(:)';
su=su(:)';


h2 = fill([x fliplr(x)],[mu+su, fliplr(mu-sl)],cl,'edgecolor','none','facealpha',.5,'parent',ha,'Display','\mu');
uistack(h2,'top')

h1 = plot(ha,x,mu,'-','color',cl*.3+c*.7,'markersize',1,'linewidth',2,'Display','\pm1\sigma');
uistack(h1,'top')

%h3 = plot(x,mu+s,'-','color',cl*.5+c*.5,'markersize',1,'linewidth',.5);
%h4 = plot(x,mu-s,'-','color',cl*.5+c*.5,'markersize',1,'linewidth',.5);

h = [h1 h2];
