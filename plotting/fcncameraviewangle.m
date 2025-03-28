% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function fcncameraviewangle(varargin)

switch nargin
    case 0
        hf = gcf;
        size = 10;
    case 1
        hf = gcf;
        size = varargin{1};
    case 2
        hf = varargin{1};
        size = varargin{2};
end

h = findobj(hf,'Type','axes');
if numel(h)>0
    set(h,'CameraViewAngle',size);
end

