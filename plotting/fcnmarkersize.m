% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function fcnmarkersize(varargin)

switch nargin
    case 0
        hf = gcf;
        size = 1;
    case 1
        hf = gcf;
        size = varargin{1};
    case 2
        hf = varargin{1};
        size = varargin{2};
end

h = findobj(hf,'Type','patch', '-or','Type','line');
if numel(h)==1
    h.MarkerSize=size;
else
    set(h,'MarkerSize',size);
end