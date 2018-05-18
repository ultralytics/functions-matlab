function [] = fcngrid(varargin)
if nargin==0
    h=fcngetaxesh(gcf);
    s='on';
elseif nargin==1
    h=fcngetaxesh(gcf);
    s = varargin{1};
elseif nargin==2
    h=fcngetaxesh(varargin{1});
    s=varargin{2};
end


for i=1:numel(h)
    grid(h(i),s)
end

% if s(end)=='n'
%     set(h,'gridlinestyle','-','LineWidth',.1)
% else
%     set(h,'gridlinestyle',':','LineWidth',1)
% end

end

function ha = fcngetaxesh(h)
if strcmp(get(h,'Type'),'figure')
    ha=findobj(h,'type','axes','-and','Tag','');
else
   ha = h; 
end
end