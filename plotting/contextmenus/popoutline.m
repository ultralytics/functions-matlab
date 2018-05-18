function [] = popoutline(ha)
if nargin==0 %add the context menu to existing items
    hcmenu = uicontextmenu;
    uimenu(hcmenu,  'Label', 'View Larger',             'Callback', 'popoutline(gca)');
    set(findobj(gcf,'type','line'),'uicontextmenu',hcmenu)
    return
end
    
%apply context menu after right mouse click
ho = findobj(gca,'selected','on');
popoutsubplot(gca, fig); cla
c=copyobj(ho,gca);


