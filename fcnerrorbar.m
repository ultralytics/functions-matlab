% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function hb = fcnerrorbar(varargin)
if isgraphics(varargin{1})
    ha=varargin{1}; varargin=varargin(2:end);
else
    ha=gca;
end
x=varargin{1};      x=x(:);
mu=varargin{2};     mu=mu(:);
su=varargin{3};     su=su(:);
sl=varargin{4};
if numel(sl)==numel(su);
    c = fcnstr2rgbcolor(varargin{5});
else
    c  = sl;
    sl = su;
end
sl = sl(:);

hb=plot(ha,x,mu,'.','Color',c,'Markersize',20);

xa=[x x];           xa(:,3)=nan;
ya=[mu+su mu-sl];   ya(:,3)=nan;
hc=plot(ha,xa',ya','-','Color',c,'linewidth',2);

