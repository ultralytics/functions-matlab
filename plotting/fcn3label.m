% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function fcn3label(varargin)
n = nargin;

if n==0
    xlabel('x')
    ylabel('y')
    zlabel('z')
    return
elseif n==1 && ~ischar(varargin{1})
    ha = varargin{1};
    xlabel(ha,'x')
    ylabel(ha,'y')
    zlabel(ha,'z')
elseif n==1 && ischar(varargin{1})
    ustr = varargin{1}; %units str
    xlabel(['x ' ustr])
    ylabel(['y ' ustr])
    zlabel(['z ' ustr])
    return
end


i=1;
if ~ischar(varargin{1})
    ha = varargin{1};
    i = 2;
else
    ha = gca;
end

xlabel(ha,varargin{i})
if n>=i+1
    ylabel(ha,varargin{i+1})
end
if n>=i+2
    zlabel(ha,varargin{i+2})
end


%set(gca,'ydir','reverse','zdir','reverse')