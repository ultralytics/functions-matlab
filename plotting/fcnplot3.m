% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function h=fcnplot3(x,varargin)
switch nargin
    case 0
        set(gca,'zdir','reverse','ydir','reverse'); return
    case 1
        h = plot3(x(:,1),x(:,2),x(:,3),'.-');
    case 2
        s = deal(varargin{:});
        h = plot3(x(:,1),x(:,2),x(:,3),s);
    otherwise
        h = plot3(x(:,1),x(:,2),x(:,3),varargin{:});
end




