% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [] = fcnfigaspectratio(varargin)

if nargin==2
    h=gcf;
    length = varargin{1};
    height = varargin{2};
else
    h=varargin{1};
    length = varargin{2};
    height = varargin{3};
end

units0 = get(gcf,'units'); set(gcf,'units','centimeters');
p0 = get(gcf,'Position');
height0 = p0(4);
length0 = p0(3);

set(gcf,'position',[p0(1:2) p0(4)*length/height p0(4)]);




set(gcf,'units',units0);
end

