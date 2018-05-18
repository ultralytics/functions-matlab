function []=fcnfontsize(varargin)

switch nargin
    case 0
        hf = gcf;
        size = 8;
    case 1
        hf = gcf;
        size = varargin{1};
    case 2
        hf = varargin{1};
        size = varargin{2};
end

h = findobj(hf,'-property','FontSize'); %string handles
if numel(h)==1
    h.FontSize=size;
else
    set(h,'FontSize',size);
end