% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [] = set_(varargin)
nargin = numel(varargin);
if isgraphics(varargin{1})
    ha = varargin{1};
    varargin = varargin(2:end);  nargin=numel(varargin);
else
    ha = gcf;
end
property = varargin(1:2:nargin);
value = varargin(2:2:end);

for i=1:numel(property)
    h = findobj(ha,'-property',property{i}); %string handles
    set(h,property{i},value{i});
end

end