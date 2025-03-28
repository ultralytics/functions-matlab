% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [] = rea()
%removes empty axes
ha = findobj(gcf,'Type','axes','-and','Tag','');
a=get(ha,'children');  na = numel(ha);
if na==1; a={a}; end

for i=1:na
    if isempty(a{i}); axis(ha(i),'off'); end
end

