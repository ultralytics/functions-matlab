function fcnlinewidth(varargin)
%example for legends: fcnlinewidth(findobj(gcf,'Tag','legend'),10)

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

h = findobj(hf,'Type','line','-or','Type','ErrorBar');%, '-or','Type','hggroup');
%h = findobj(hf,'-property','LineWidth'); %string handles
if numel(h)==1
    h.LineWidth=size;
else
    set(h,'LineWidth',size);
end