% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [] = xyzlabel(varargin)
%xyzlabel(h,strx,stry,strz) or xyzlabel(strx,stry,strz) or xyzlabel([],stry)
sx = [];
sy = [];
sz = [];
st = [];
fs = [];

if nargin==0 || ischar(varargin{1})
    h = gca;
    if nargin==0; xlabel('X'); ylabel('Y'); zlabel('Z'); return; end
else
    h = varargin{1};
    varargin = varargin(2:end);
end


n = numel(varargin);
switch n
    case 1
        sx = varargin{1};
    case 2
        sx = varargin{1};  sy = varargin{2};
    case 3
        sx = varargin{1};  sy = varargin{2};  sz = varargin{3};
    case 4
        sx = varargin{1};  sy = varargin{2};  sz = varargin{3};  st = varargin{4};
    case 5
        sx = varargin{1};  sy = varargin{2};  sz = varargin{3};  st = varargin{4};  fs = varargin{5};
end

for i=1:numel(h)
    hi = h(i);
    if numel(sx)>0; hi.XLabel.String = sx; end
    if numel(sy)>0; hi.YLabel.String = sy; end
    if numel(sz)>0; hi.ZLabel.String = sz; end
    if numel(st)>0; hi.Title.String  = st; end
    if numel(fs)>0; hi.XLabel.FontSize=fs; hi.YLabel.FontSize=fs; hi.ZLabel.FontSize=fs; hi.Title.FontSize=fs; end
end
